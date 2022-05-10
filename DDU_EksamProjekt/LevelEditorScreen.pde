class LevelEditorScreen extends GameState {

  Bane bane;
  Keyboard kb;
  FileHandler fileHandler;
  Box2DProcessing box2d;

  boolean popup = true;
  EditorPopUp popUp;

  LevelEditorScreen(PApplet program, Keyboard kb, FileHandler fileHandler) {
    super(program, kb);
    this.fileHandler = fileHandler;

    box2d = new Box2DProcessing(program);  
    box2d.createWorld();
    box2d.setGravity(0, -35);

    bane = new Bane(box2d, fileHandler, true);
    this.kb = kb;
    popUp = new EditorPopUp(bane, program, this);
  }

  void Update() {
    if (kb.Shift(9)) {
      popup = !popup;
    }
    if (popup) popUp.Update();
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

  void LoadBane(IntList[][] a) {
    bane.LoadBane(a);
  }
}
