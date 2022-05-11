class LevelEditorScreen extends GameState {

  Bane bane;
  Keyboard kb;
  FileHandler fileHandler;
  Box2DProcessing box2d;

  BaneButton topPlus, topMinus, rightPlus, rightMinus, bottomPlus, bottomMinus, leftPlus, leftMinus;

  boolean popup = true, hand;
  EditorPopUp popUp;
  float scrollSpeed = -0.1, arrowSpeed = 10;
  int wheel = 0; 

  LevelEditorScreen(PApplet program, Keyboard kb, FileHandler fileHandler) {
    super(program, kb);
    this.fileHandler = fileHandler;

    box2d = new Box2DProcessing(program);  
    box2d.createWorld();
    box2d.setGravity(0, -35);

    bane = new Bane(box2d, fileHandler, true);
    this.kb = kb;
    popUp = new EditorPopUp(bane, program, this, fileHandler);

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
  }
  void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    println(e);
  }
  void Draw() {
    background(95, 90, 100);
    pushMatrix();
    translate(0, 80);
    bane.Draw(false, kb.getToggle(72));
    DrawCanvasButtons();
    popMatrix();

    DrawTopBar();

    if (popup)popUp.Draw();
  }

  void DrawTopBar() {
    rectMode(CORNER);
    noStroke();
    fill(230);
    rect(0, 0, width, 80);
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
    if (hand)cursor(HAND);
    else cursor(ARROW);

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
    } else if(!popup) {
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
}
