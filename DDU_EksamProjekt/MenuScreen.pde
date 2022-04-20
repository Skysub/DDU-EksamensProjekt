class MenuScreen extends GameState {

  Button baneMenuButton = new Button(width/2-150, 500, 300, 80, "Baner", color(80, 235, 80), color(135, 28, 28), 20, color(0, 0, 0));
  Button logInButton = new Button(width/2-150, 700, 300, 80, "Log in/sign up", color(80, 235, 80), color(135, 28, 28), 20, color(0, 0, 0));

  MenuScreen(PApplet program, Keyboard kb) {
    super(program, kb);
  }

  void Update() {
    baneMenuButton.Update();
    logInButton.Update();
    if(baneMenuButton.isClicked()) mainLogic.gameStateManager.SkiftGameState("BaneMenuScreen");
    if(logInButton.isClicked()) mainLogic.gameStateManager.SkiftGameState("LogInScreen");
  }

  void Draw() {
   
    baneMenuButton.Draw();
    logInButton.Draw();

    fill(0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("Grapple Adventure", width/2, 200);
  }
}
