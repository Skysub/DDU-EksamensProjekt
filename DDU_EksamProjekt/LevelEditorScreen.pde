class LevelEditorScreen extends GameState {

  Bane bane;
  Keyboard kb;
  FileHandler fileHandler;
  Box2DProcessing box2d;

  boolean popup = true;
  EditorPopUp popUp;
  float lastX = -1, lastY = -1;

  LevelEditorScreen(PApplet program, Keyboard kb, FileHandler fileHandler) {
    super(program, kb);
    this.fileHandler = fileHandler;

    box2d = new Box2DProcessing(program);  
    box2d.createWorld();
    box2d.setGravity(0, -35);

    bane = new Bane(box2d, fileHandler, true);
    this.kb = kb;
    popUp = new EditorPopUp(bane, program, this, fileHandler);
  }

  void Update() {
    if (kb.Shift(9)) {
      popup = !popup;
    }
    if (popup) popUp.Update();
    //if(frameCount % 180 == 0) bane.EditCanvas(-1, floor(frameCount/180f) % 4); //Til testning af editing af banens størrelse
    //bane.Update();

    pan();
  }

  void Draw() {
    background(95, 90, 100);
    pushMatrix();
    translate(0, 80);
    bane.Draw(kb.getToggle(84), kb.getToggle(72));
    popMatrix();

    DrawTopBar();

    if (popup)popUp.Draw();
  }

  void DrawTopBar() {
    noStroke();
    fill(230);
    rect(0, 0, width, 80);
  }

  void pan() {
    if (mousePressed && !popup) {
      bane.setKamera(new Vec2(bane.kamera[0]+(mouseX-lastX), bane.kamera[1]+(mouseY-lastY)));
    }
    lastX = mouseX;
    lastY = mouseY;
  }

  void LoadBane(IntList[][] a) {
    bane.LoadBane(a);
  }
}
