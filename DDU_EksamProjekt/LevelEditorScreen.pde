class LevelEditorScreen extends GameState { //<>//

  Bane bane;
  Keyboard kb;
  FileHandler fileHandler;
  Box2DProcessing box2d;

  BaneButton topPlus, topMinus, rightPlus, rightMinus, bottomPlus, bottomMinus, leftPlus, leftMinus;
  Kasse kasse;
  Sav lSav;
  Sav sSav;
  Knap knap;
  Door door;

  EditorButton[] barButtons = new EditorButton[10];

  boolean popup = true, hand;
  EditorPopUp popUp;
  float scrollSpeed = -0.1, arrowSpeed = 10;
  int wheel = 0, spacing = 60;
  int storeLeft = 0, storeRight = 1;
  float[] nulKamera = {0, 0, 1, 1920, 1080};
  boolean pressedPrev = false;

  LevelEditorScreen(PApplet program, Keyboard kb, FileHandler fileHandler) {
    super(program, kb);
    this.fileHandler = fileHandler;

    box2d = new Box2DProcessing(program);  
    box2d.createWorld();
    box2d.setGravity(0, -35);

    bane = new Bane(box2d, fileHandler, true);
    this.kb = kb;
    popUp = new EditorPopUp(bane, program, this, fileHandler);

    SetupBlokBar();
    MakeTopBarKnapper();

    topPlus = new BaneButton((bane.bred*40)/2+20, -30, 30, 30, "+", color(255), color(0), 20, color(0), new Vec2(-15, -15));
    topMinus = new BaneButton((bane.bred*40)/2-20, -30, 30, 30, "-", color(255), color(0), 20, color(0), new Vec2(-15, -15));
    rightPlus = new BaneButton(-30, bane.lang*20+20, 30, 30, "+", color(255), color(0), 20, color(0), new Vec2(-15, -15));
    rightMinus = new BaneButton(-30, bane.lang*20-20, 30, 30, "-", color(255), color(0), 20, color(0), new Vec2(-15, -15));
    bottomPlus = new BaneButton((bane.bred*40)/2+20, bane.lang*40+30, 30, 30, "+", color(255), color(0), 20, color(0), new Vec2(-15, -15));
    bottomMinus = new BaneButton((bane.bred*40)/2-20, bane.lang*40+30, 30, 30, "-", color(255), color(0), 20, color(0), new Vec2(-15, -15));
    leftPlus = new BaneButton(bane.bred*40+30, bane.lang*20+20, 30, 30, "+", color(255), color(0), 20, color(0), new Vec2(-15, -15));
    leftMinus = new BaneButton(bane.bred*40+30, bane.lang*20-20, 30, 30, "-", color(255), color(0), 20, color(0), new Vec2(-15, -15));
  }

  void Update() {
    hand = false;
    if (kb.Shift(9)) {
      popup = !popup;
    }
    if (popup) { 
      if (popUp.Update()) hand = true;
    }

    scroll();
    pan();

    UpdateCanvasButtons();
    if (kb.Shift(82)) bane.ResetKamera();

    UpdateTopBarKnapper();
    EditLevelBlok(bane.getKamera());
  }

  void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    println(e);
  }
  void Draw() {
    background(95, 90, 100);
    pushMatrix();
    translate(0, 80);
    bane.Draw(false, kb.getToggle(72), !kb.getToggle(67));
    DrawCanvasButtons();
    popMatrix();

    DrawTopBar();
    DrawBlokBar(kb.getToggle(72), bane.getKamera(), !kb.getToggle(67));

    if (popup)popUp.Draw();
  }

  void DrawTopBar() {
    rectMode(CORNER);
    noStroke();
    fill(230);
    rect(0, 0, width, 88);
  }

  void DrawCanvasButtons() {
    pushMatrix();
    resetMatrix();
    topPlus.Draw(bane.getKamera());
    topMinus.Draw(bane.getKamera());
    rightPlus.Draw(bane.getKamera());
    rightMinus.Draw(bane.getKamera());
    bottomPlus.Draw(bane.getKamera());
    bottomMinus.Draw(bane.getKamera());
    leftPlus.Draw(bane.getKamera());
    leftMinus.Draw(bane.getKamera());
    popMatrix();
  }

  void UpdateCanvasButtons() {
    if (topPlus.Update(bane.getKamera())) hand = true;
    if (topMinus.Update(bane.getKamera())) hand = true;
    if (rightPlus.Update(bane.getKamera())) hand = true;
    if (rightMinus.Update(bane.getKamera())) hand = true;
    if (bottomPlus.Update(bane.getKamera())) hand = true;
    if (bottomMinus.Update(bane.getKamera())) hand = true;
    if (leftPlus.Update(bane.getKamera())) hand = true;
    if (leftMinus.Update(bane.getKamera())) hand = true;

    if (topPlus.MouseReleased()) bane.EditCanvas(1, 0);
    if (topMinus.MouseReleased()) bane.EditCanvas(-1, 0);
    if (rightPlus.MouseReleased()) bane.EditCanvas(1, 3);
    if (rightMinus.MouseReleased()) bane.EditCanvas(-1, 3);
    if (bottomPlus.MouseReleased()) bane.EditCanvas(1, 2);
    if (bottomMinus.MouseReleased()) bane.EditCanvas(-1, 2);
    if (leftPlus.MouseReleased()) bane.EditCanvas(1, 1);
    if (leftMinus.MouseReleased()) bane.EditCanvas(-1, 1);

    topPlus.x = (bane.bred*40)/2+20-15;
    topMinus.x = (bane.bred*40)/2-20-15;
    rightPlus.y = bane.lang*20+20-15;
    rightMinus.y = bane.lang*20-20-15;

    bottomPlus.x = (bane.bred*40)/2+20-15;
    bottomPlus.y = bane.lang*40+30-15;
    bottomMinus.x = (bane.bred*40)/2-20-15;
    bottomMinus.y = bane.lang*40+30-15;
    leftPlus.x = bane.bred*40+30-15;
    leftPlus.y = bane.lang*20+20-15;
    leftMinus.x = bane.bred*40+30-15;
    leftMinus.y = bane.lang*20-20-15;
  }

  void pan() {
    if (mousePressed && (kb.getKey(16) || kb.getKey(17)) && !popup) {
      bane.setKamera(new Vec2(bane.kamera[0]+(mouseX-pmouseX), bane.kamera[1]+(mouseY-pmouseY)));
    } else if (!popup) {
      if (kb.getKey(38)) bane.setKamera(new Vec2(bane.kamera[0], bane.kamera[1] + arrowSpeed));
      if (kb.getKey(39)) bane.setKamera(new Vec2(bane.kamera[0] - arrowSpeed, bane.kamera[1]));
      if (kb.getKey(40)) bane.setKamera(new Vec2(bane.kamera[0], bane.kamera[1] - arrowSpeed));
      if (kb.getKey(37)) bane.setKamera(new Vec2(bane.kamera[0] + arrowSpeed, bane.kamera[1]));
    }
  }

  void scroll() {
    if (!popup && (wheel*scrollSpeed+1) != 1) {
      float delta = (wheel*scrollSpeed+1);

      if (!(bane.kamera[2] * delta > 2.5 || bane.kamera[2] * delta < 0.7)) {
        bane.kamera[2] *= delta;
        bane.kamera[0] -= mouseX;
        bane.kamera[1] -= (mouseY-80);
        bane.kamera[0] *= delta;
        bane.kamera[1] *= delta;
        bane.kamera[0] += mouseX;
        bane.kamera[1] += (mouseY-80);
      }
    }
    wheel = 0;
  }

  void LoadBane(IntList[][] a) {
    bane.LoadBane(a);
  }

  void DrawBlokBar(Boolean HitboxDebug, float[] kamera, boolean coolGFX) {
    DrawTopBarKnapper();

    pushMatrix();
    translate(100, 15); //<>//
    scale(1.2);
    for (int i = -1; i < 4; i++) {
      String g = i+"";
      bane.blok.DrawBlok(i, HitboxDebug, g, kamera, true, true, coolGFX);
      translate(spacing, 0);
    }
    pushMatrix();
    translate(-spacing*3+19, 0);
    text("Empty", 0, 25);
    popMatrix();
    pushMatrix();
    scale(0.7);
    translate(0, 0);
    kasse.Draw(nulKamera, HitboxDebug);
    popMatrix();

    translate(spacing+20, 20);

    lSav.Draw(HitboxDebug);
    fill(0);    
    textSize(8);
    text("Saw", -2, 3);

    translate(spacing, 0);

    pushMatrix();
    scale(0.5);
    sSav.Draw(HitboxDebug);
    popMatrix();
    fill(0);
    textSize(10);
    text("Saw", -1, 3);
    translate(spacing-20, -20);

    knap.Draw(HitboxDebug);
    translate(spacing, -2);
    door.Draw(HitboxDebug, coolGFX);
    fill(0);
    text("Gate", 20, 26);

    popMatrix();

    DrawValg();
  }

  void SetupBlokBar() {
    Vec2 pos = new Vec2(100/10, 15/10);

    kasse = new Kasse(pos.sub(new Vec2(106, -61)), box2d);

    lSav = new Sav(pos, 4, 0.05);
    sSav = new Sav(pos, 12, 0.025);
    knap = new Knap(pos, -2);
    door = new Door(pos, -2, box2d);
  }

  void DrawValg() {
    pushMatrix();
    scale(1.2);
    pushMatrix();
    translate(storeLeft*spacing+93, 62);
    fill(255, 0, 0);
    square(0, 0, 8);
    popMatrix();

    translate(storeRight*spacing+105, 62);
    fill(0, 0, 255);
    square(0, 0, 8);
    popMatrix();
  }

  void MakeTopBarKnapper() {
    for (int i = 0; i < 10; i++) {
      barButtons[i] = new EditorButton(int(i*spacing*1.2+94), 8, 62, 63, "", color(218), color(0), 10, color(0), i, i);
    }
  }

  void UpdateTopBarKnapper() {
    for (EditorButton x : barButtons) {
      if (x.Update()) hand = true;
    }
    if (hand)cursor(HAND);
    else cursor(ARROW);

    for (EditorButton x : barButtons) {
      if (x.isClicked()) storeLeft = x.id;
      if (x.rightIsClicked()) storeRight = x.id;
    }
  }

  void DrawTopBarKnapper() {
    for (EditorButton x : barButtons) {
      x.Draw(storeRight, storeLeft);
    }
  }

  void EditLevelBlok(float[] kamera) {
    if (mousePressed && mouseY > 88) {
      int[] pos = new int[2];
      int y = mouseY - 80;
      int x = mouseX;
      x -= kamera[0];
      y -= kamera[1];
      pos[0]=floor(x/(40*kamera[2]));
      pos[1] =floor(y/(40*kamera[2]));

      try {
        if ((mouseButton == LEFT && bane.bane[pos[0]][pos[1]].get(0) == storeLeft-1) || (mouseButton == RIGHT && bane.bane[pos[0]][pos[1]].get(0) == storeRight-1)) {
          return;
        }
      } 
      catch(Exception e) {
        println("Tried to place block out of bounds T: "+millis());
        return;
      }

      if (mouseButton == LEFT) bane.EditBlok(storeLeft-1, 0, 1, pos);
      else bane.EditBlok(storeRight-1, 0, 1, pos);
    }
  }
}
