class ControlsScreen extends GameState {
  Button exitButton = new Button(width/2-60, 200, 120, 60, "Main menu", color(200), color(80, 100, 80), 20, color(0, 0, 0), color(255, 105, 105));
  boolean hand;

  ControlsScreen(PApplet program, Keyboard kb) {
    super(program, kb);
  }

  void Update() {
    hand = false;
    if (exitButton.Update()) hand = true;
    if (hand)cursor(HAND);
    else cursor(ARROW);

    if (exitButton.isClicked()) ChangeScreen("MenuScreen");
  }

  void Draw() {
    exitButton.Draw();
  }
}
