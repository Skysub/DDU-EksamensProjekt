class MenuScreen extends GameState {
  Button loginScreenButton = new Button(width/2-250, 500, 300, 100, "Log in", color(80, 235, 80), color(80, 100, 80), 20, color(0, 0, 0));

  MenuScreen(PApplet program, Keyboard kb) {
    super(program, kb);
  }

  void Update() {
    loginScreenButton.Update();
    
    if(loginScreenButton.isClicked()) mainLogic.gameStateManager.SkiftGameState("LogInScreen");
  }

  void Draw() {
    rect(100, 100, 100, 100);
    loginScreenButton.Draw();
  }
}
