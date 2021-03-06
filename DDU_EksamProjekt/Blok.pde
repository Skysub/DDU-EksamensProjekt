class Blok { //<>//
  Box2DProcessing box2d;

  int blokkeIalt = 7;
  int gridSize;
  int ting = 0;

  //Disse hashmaps holder banens forskellige objekter
  HashMap<String, Kasse> kasser;
  HashMap<String, Sav> save;
  HashMap<String, Knap> knapper;
  HashMap<String, Door> doors;
  ArrayList<Body> walls;

  Blok(int g, Box2DProcessing w) {
    gridSize = g;
    box2d = w;
    kasser = new HashMap<String, Kasse>();
    save = new HashMap<String, Sav>();
    knapper = new HashMap<String, Knap>();
    doors = new HashMap<String, Door>();
    walls = new ArrayList<Body>();
  }

  void Update() { //Opdater banens klasse elementer
    for (String x : doors.keySet()) {
      doors.get(x).StartUpdate();
    }

    for (String x : knapper.keySet()) {
      knapper.get(x).Update(kasser);
    }

    for (String x : doors.keySet()) {
      doors.get(x).Update();
    }

    for (String x : save.keySet()) {
      save.get(x).Update();
    }
  }

  //tegner blokken, al translation og rotation gøres ikke her men i metoden der kalder denne metode
  //Vælger hvilken blok draw metode der skal bruges ud fra blok id'et
  void DrawBlok(int id, boolean HitboxDebug, String g, float[] kamera, boolean specialPass, boolean editorMode, boolean coolGFX) {
    switch (id) {
    case 0: //Wall blok
      DrawB0(coolGFX, editorMode);
      break;

    case 1: //Luft blok
      DrawB1(editorMode, coolGFX);
      break;

    case 2: //Mål blok
      DrawB2( coolGFX, editorMode);
      break;

    case 3: //Start blok
      if (editorMode && !coolGFX)DrawB3();
      else DrawB1(editorMode, coolGFX);
      break;

    case 4: //Kasse
      if (specialPass && ((editorMode && coolGFX) || !editorMode)) {
        pushMatrix();
        resetMatrix();
        kasser.get(g).Draw(kamera, HitboxDebug);
        popMatrix();
      } else if (editorMode) DrawB4(editorMode);
      else DrawB1(editorMode, coolGFX);
      break;

    case 5: //Lille sav
      if (specialPass && ((editorMode && coolGFX) || !editorMode)) {
        save.get(g).Draw(HitboxDebug, coolGFX);
      } else if (editorMode && !coolGFX) DrawB5(editorMode);
      else DrawB1(editorMode, coolGFX);
      break;

    case 6: //Stor sav
      if (specialPass && ((editorMode && coolGFX) || !editorMode)) {
        save.get(g).Draw(HitboxDebug, coolGFX);
      } else if (editorMode && !coolGFX) DrawB6(editorMode);
      else DrawB1(editorMode, coolGFX);
      break;

    case 7: //Knap blok
      knapper.get(g).Draw(HitboxDebug, coolGFX);
      break;

    case 8: //Dør blok
      doors.get(g).Draw(HitboxDebug, coolGFX, editorMode);
      break;

    default:
      if (editorMode && !coolGFX) DrawEmpty();
      break;
    }
  }

  //returnerer typen af hitbox som blokken har, skal genlaves hvis en blok skal have mere end 1 type hitbox i samme blok
  int GetType(int id, String g) {
    switch (id) {
    case 0: //wall blok
      return 1;
    case 1: //luft blok
      return 0;
    case 2: //Mål blok
      return 2;
    case 3: //Start blok
      return 0;
    case 4: //Kasse blok
      return 0;
    case 5: //Sav blok lille
      return 0;
    case 6: //Sav blok stor
      return 0;
    case 7: //Knap blok 
      return 0;
    case 8: //Dør blok 
      if (!doors.get(g).on) return 1;
      else return 0;

    default:
      return -1;
    }
  }

  //Laver væggen i physics verdenen
  void MakeWall(Vec2 pos) {
    BodyDef bd = new BodyDef();
    PolygonShape ps = new PolygonShape();
    pos.addLocal(new Vec2(gridSize/20, -gridSize/20));
    bd.position.set(pos);
    bd.type = BodyType.STATIC;
    Body body = box2d.createBody(bd);
    ps.setAsBox(gridSize/20, gridSize/20);
    body.createFixture(ps, 1);

    walls.add(body);
  }

  void MakeKasse(String g, Vec2 pos) {
    kasser.put(g, new Kasse(pos, box2d));
  }

  void MakeSav(String g, Vec2 pos, float type) {
    if (type == 5) save.put(g, new Sav(pos, 4, 0.05));
    if (type == 6) save.put(g, new Sav(pos, 12, 0.025));
  }

  void MakeKnap(String g, Vec2 pos, int id) {
    knapper.put(g, new Knap(pos, id));
  }

  void MakeDoor(String g, Vec2 pos, int id) {
    doors.put(g, new Door(pos, id, box2d));
  }

  //Fjerner alle objekterne fra verdenen og laver nye hashmaps
  void DestroyStuff() {
    for (String x : kasser.keySet()) {
      kasser.get(x).finalize();
    }

    for (String x : doors.keySet()) {
      doors.get(x).finalize();
    }

    for (Body x : walls) {
      if (box2d.world.getBodyCount() < 1) {
        x.setActive(false);
      } else {
        box2d.destroyBody(x);
      }
    }

    walls = new ArrayList<Body>();
    save = new HashMap<String, Sav>();
    knapper = new HashMap<String, Knap>();
    doors = new HashMap<String, Door>();
    kasser = new HashMap<String, Kasse>();
  }

  //returnerer alle hitboxes fra blokken
  PVector[][] GetHitboxes(int id, int blokTurn) {
    PVector[][] temp = new PVector[0][0];
    switch (id) {
    case 0: //Start blok
      temp = BoxesB0();
      break;
    case 1:
      temp = BoxesB1();
      break;
    case 2:
      temp = BoxesB2();
      break;

    case 3:
      temp = BoxesB1();
      break;

    case 4:
      temp = BoxesB1();
      break;

    case 5:
      temp = BoxesB1();
      break;

    case 6:
      temp = BoxesB1();
      break;

    case 7:
      temp = BoxesB1();
      break;

    case 8:
      temp = BoxesB0();
      break;

    default:
      break;
    }
    for (int i = 0; i<temp.length; i++) {
      temp[i][0].sub(new PVector(gridSize/2, gridSize/2));
      temp[i][0].rotate(blokTurn*PI/2f);
      temp[i][0].add(new PVector(gridSize/2, gridSize/2));

      //Old code, maybe oboslete?
      //temp[i][1].rotate(blokTurn*PI/2f);
      //temp[i][0].add(new PVector(shift.x*gridSize, shift.y*gridSize));
    }
    return temp;
  }

  //Wall hitboxes
  PVector[][] BoxesB0() {
    PVector[][] boxes = new PVector[1][2];
    boxes[0][0] = new PVector(0, 0);
    boxes[0][1] = new PVector(40, 40);
    return boxes;
  }

  //Luft blok hitboxes
  PVector[][] BoxesB1() {
    return new PVector[0][0];
  }

  //Mål hitboxes
  PVector[][] BoxesB2() {
    PVector[][] boxes = new PVector[1][2];
    boxes[0][0] = new PVector(0, 0);
    boxes[0][1] = new PVector(40, 40);
    return boxes;
  }

  //Wall tile
  void DrawB0(boolean coolGFX, boolean editorMode) {
    //square
    SetSquareSettings();
    strokeWeight(2);
    square(0, 0, gridSize);

    //Text
    textSize(10);
    fill(10);
    if (!coolGFX && editorMode) text("Wall", 20, 26);
  }

  //Background tile
  void DrawB1(boolean editorMode, boolean coolGFX) {
    //square
    SetSquareSettings();
    if (!editorMode || coolGFX) {
      //No grid
      noStroke();
      fill(255);
      square(2, 2, gridSize+1);
    } else {
      //Light grid
      stroke(180);
      square(0, 0, gridSize);
    }
  }
  //Goal tile
  void DrawB2(boolean coolGFX, boolean editorMode) {
    //square
    SetSquareSettings();
    fill(200, 200, 255);
    if (coolGFX || !editorMode) noStroke();
    square(0, 0, gridSize);
    //Text
    textSize(10);
    fill(10);
    if (!coolGFX && editorMode)text("Goal", 20, 26);
  }

  //Start tile
  void DrawB3() {
    //square
    SetSquareSettings();
    fill(150, 255, 150);
    noStroke();
    square(0, 0, gridSize+2);
    //Text
    textSize(10);
    fill(10);
    text("Start", 20, 26);
  }

  //Kasse tile
  void DrawB4(boolean editorMode) {
    //square
    SetSquareSettings();
    fill(139, 145, 158);
    noStroke();
    square(0, 0, gridSize+2);
    //Text
    textSize(10);
    fill(10);
    text("Box", 20, 26);
  }

  //Lille sav tile
  void DrawB5(boolean editorMode) {
    //square
    SetSquareSettings();
    fill(220, 64, 255);
    noStroke();
    square(0, 0, gridSize+2);
    //Text
    textSize(10);
    fill(10);
    text("1x1 saw", 20, 26);
  }

  //Stor sav tile
  void DrawB6(boolean editorMode) {
    //square
    SetSquareSettings();
    fill(255, 64, 245);
    noStroke();
    square(0, 0, gridSize+2);
    //Text
    textSize(10);
    fill(10);
    text("3x3 Saw", 20, 26);
  }

  //Empty tile
  void DrawEmpty() {
    //Light grid
    fill(95, 90, 100);
    stroke(130);
    strokeWeight(1);
    square(0, 0, gridSize);

    textAlign(CENTER);
    //Text
    textSize(10);
    fill(230);
    text("Void", 20, 26);
  }

  //Helps standardize the way the square part of a block looks, easier to make quick changes to all blocks
  void SetSquareSettings() {
    fill(250);
    stroke(20);
    strokeWeight(1);
    textAlign(CENTER);
  }
}
