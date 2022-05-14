class MenuScreen extends GameState {
  Button loginScreenButton = new Button(width/2-150, 330, 300, 100, "Log in", color(#253FFF), color(80, 100, 80), 50, color(230));
  Button LevelSelectionScreenButton = new Button(width/2-150, 500, 300, 100, "Levels", color(#253FFF), color(80, 100, 80), 50, color(230));
  Button EditorScreenButton = new Button(width/2-150, 650, 300, 100, "Level Editor", color(#253FFF), color(80, 100, 80), 50, color(230));
  Button ControlsScreenButton = new Button(width/2-150, 800, 300, 100, "Controls", color(#253FFF), color(80, 100, 80), 50, color(230));
  boolean loggedIn = false, hand = false;

  MenuScreen(PApplet program, Keyboard kb) {
    super(program, kb);
  }

  void Update() {
    hand = false;
    if (loginScreenButton.Update()) hand = true;
    if (LevelSelectionScreenButton.Update()) hand = true;
    if (EditorScreenButton.Update()) hand = true;
    if (ControlsScreenButton.Update()) hand = true;
    if (hand)cursor(HAND);
    else cursor(ARROW);

    if (loginScreenButton.isClicked()) ChangeScreen("LogInScreen");
    if (LevelSelectionScreenButton.isClicked()) ChangeScreen("LevelSelectionScreen");
    if (EditorScreenButton.isClicked()) ChangeScreen("LevelEditorScreen");
    if (ControlsScreenButton.isClicked()) ChangeScreen("ControlsScreen");
    if (mainLogic.username != null) loggedIn = true;
  }

  void Draw() {
    fill(200);
    rect(0, 0, width, 230);
    
    fill(237, 223, 197);
    textAlign(CENTER, CENTER);
    textSize(120);
    text("Grapple adventure", width/2, 100);
    fill(0);
    text("Grapple adventure", width/2-5, 100-5);

    textSize(25);
    if (!loggedIn) text("Currently NOT logged in", width/2, 450);
    else text("Logged in as: " + mainLogic.username, width/2, 450);

    loginScreenButton.Draw();
    LevelSelectionScreenButton.Draw();
    EditorScreenButton.Draw();
    ControlsScreenButton.Draw();
  }
}
