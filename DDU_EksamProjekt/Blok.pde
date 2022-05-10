class Blok {
  Box2DProcessing box2d;

  int blokkeIalt = 7;
  int gridSize;

  HashMap<String, Kasse> kasser;
  HashMap<String, Sav> save;
  HashMap<String, Knap> knapper;
  HashMap<String, Door> doors;
  ArrayList<Body> walls = new ArrayList<Body>();

  Blok(int g, Box2DProcessing w) {
    gridSize = g;
    box2d = w;
    kasser = new HashMap<String, Kasse>();
    save = new HashMap<String, Sav>();
    knapper = new HashMap<String, Knap>();
    doors = new HashMap<String, Door>();
  }

  void Update() {
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
  void DrawBlok(int id, boolean HitboxDebug, String g, float[] kamera, boolean specialPass, boolean editorMode) {
    switch (id) {
    case 0:
      DrawB0(); //Wall blok
      break;

    case 1:
      DrawB1(editorMode); //Luft blok
      break;

    case 2: //Mål blok
      DrawB2();
      break;

    case 3: //Start blok
      DrawB3();
      break;

    case 4: //Kasse
      if (specialPass) {
        pushMatrix();
        resetMatrix();
        kasser.get(g).Draw(kamera, HitboxDebug);
        popMatrix();
      } else DrawB1(editorMode);
      break;

    case 5: //Saw
      if (specialPass) {
        save.get(g).Draw(HitboxDebug);
      } else DrawB1(editorMode);
      break;

    case 6: //Saw
      if (specialPass) {
        save.get(g).Draw(HitboxDebug);
      } else DrawB1(editorMode);
      break;

    case 7: //Knap blok
      knapper.get(g).Draw(HitboxDebug);
      break;

    case 8: //Dør blok
      doors.get(g).Draw(HitboxDebug);
      break;

    default:
      if (editorMode) DrawEmpty();
      break;
    }
  }

  //returnerer typen af hitbox som blokken har, skal genlaves hvis en blok skal have mere end 1 type hitbox i samme blok
  int GetType(int id) {
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
      return 0;

    default:
      return -1;
    }
  }

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

  void DestroyStuff() {
    for (String x : kasser.keySet()) {
      kasser.get(x).finalize();
    }

    save = new HashMap<String, Sav>();
    knapper = new HashMap<String, Knap>();
    doors = new HashMap<String, Door>();

    //for (Body x : walls) {
    //  box2d.destroyBody(x);
    //}
  }

  //returnerer alle hitboxes fra blokken med relativt shift i forhold til blokken bilen er i
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
      temp = BoxesB1();
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
  void DrawB0() {
    //square
    SetSquareSettings();
    strokeWeight(2);
    square(0, 0, gridSize);

    //Text
    textSize(10);
    fill(10);
    text("Wall", 20, 26);
  }

  //Background tile
  void DrawB1(boolean editorMode) {
    //square
    SetSquareSettings();
    if (!editorMode) {
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
  void DrawB2() {
    //square
    SetSquareSettings();
    fill(200, 200, 255);
    square(0, 0, gridSize);
    //Text
    textSize(10);
    fill(10);
    text("Mål", 20, 26);
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
