class LevelSelectionScreen extends GameState {
  Button MenuScreenButton = new Button(width/2-150, 600, 300, 100, "Main Menu", color(#253FFF), color(80, 100, 80), 20, color(230));
  Button baneScreenButton = new Button(width/2-150, 450, 300, 100, "BaneScreen (debug)", color(#253FFF), color(80, 100, 80), 20, color(230));
  boolean hand;
  BaneScreen baneScreen;

  LevelSelectionScreen(PApplet program, Keyboard kb, BaneScreen baneScreen, FileHandler FileHandler) {
    super(program, kb);
    this.baneScreen = baneScreen;
  }

  void Update() {
    handleButton();
  }

  void Draw() {
    fill(20);
    textSize(40);
    text("Level selection", 400, 200);
    MenuScreenButton.Draw();
    baneScreenButton.Draw();
  }

  void handleButton() {
    hand = false;
    if (MenuScreenButton.Update()) hand = true;
    if (baneScreenButton.Update()) hand = true;
    if (hand)cursor(HAND);
    else cursor(ARROW);

    if (MenuScreenButton.isClicked()) ChangeScreen("MenuScreen");
    if (baneScreenButton.isClicked()) ChangeScreen("BaneScreen");
  }

  void LoadBaneNr(int baneId) {
  }
}
