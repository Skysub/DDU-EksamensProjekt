class MenuScreen extends GameState {
  Button loginScreenButton = new Button(width/2-150, 300, 300, 100, "Log in", color(#253FFF), color(80, 100, 80), 20, color(230));
  Button baneScreenButton = new Button(width/2-150, 500, 300, 100, "BaneScreen (debug)", color(#253FFF), color(80, 100, 80), 20, color(230));
  Button LevelSelectionScreenButton = new Button(width/2-150, 650, 300, 100, "LevelSelectionScreen", color(#253FFF), color(80, 100, 80), 20, color(230));
  Button EditorScreenButton = new Button(width/2-150, 800, 300, 100, "Level Editor", color(#253FFF), color(80, 100, 80), 20, color(230));
  boolean loggedIn = false, hand = false;

  MenuScreen(PApplet program, Keyboard kb) {
    super(program, kb);
  }

  void Update() {
    hand = false;
    if (loginScreenButton.Update()) hand = true;
    if (baneScreenButton.Update()) hand = true; //Til debugging, så man kan komme til bane screen hurtigt
    if (LevelSelectionScreenButton.Update()) hand = true;
    if (EditorScreenButton.Update()) hand = true;
    if (hand)cursor(HAND);
    else cursor(ARROW);

    if (loginScreenButton.isClicked()) ChangeScreen("LogInScreen");
    if (baneScreenButton.isClicked()) ChangeScreen("BaneScreen");
    if (LevelSelectionScreenButton.isClicked()) ChangeScreen("LevelSelectionScreen");
    if (EditorScreenButton.isClicked()) ChangeScreen("LevelEditorScreen");
    if (mainLogic.username != null) loggedIn = true;
  }

  void Draw() {
    loginScreenButton.Draw();
    baneScreenButton.Draw();
    LevelSelectionScreenButton.Draw();
    EditorScreenButton.Draw();

    textAlign(CENTER, CENTER);
    textSize(50);
    text("Grapple adventure", width/2, 100);

    textSize(25);
    if (!loggedIn) text("Currently NOT logged in", width/2, 420);
    else text("Logged in as: " + mainLogic.username, width/2, 420);
  }
}
