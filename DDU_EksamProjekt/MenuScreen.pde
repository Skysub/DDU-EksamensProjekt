class MenuScreen extends GameState {
  Button loginScreenButton, baneButton; //BANEBUTTON ER MIDLERTIDIG (bare så jeg kan tjekke logins samarbejde med scoreboard)
  boolean loggedIn = false;

  MenuScreen(PApplet program, Keyboard kb) {
    super(program, kb);
    
    loginScreenButton = new Button(width/2-150, 500, 300, 100, "Log in", color(80, 235, 80), color(80, 100, 80), 20, color(0, 0, 0));
    
    baneButton = new Button(width/2-150, 300, 300, 100, "Bane (midlertidig)", color(80, 235, 80), color(80, 100, 80), 20, color(0, 0, 0));
  }

  void Update() {
    loginScreenButton.Update();
    baneButton.Update();

    if (loginScreenButton.isClicked()) mainLogic.gameStateManager.SkiftGameState("LogInScreen");
    
    if(baneButton.isClicked()) mainLogic.gameStateManager.SkiftGameState("BaneScreen");
    
    if(mainLogic.username != null) loggedIn = true;
  }

  void Draw() {
    loginScreenButton.Draw();
    baneButton.Draw();
    
    textAlign(CENTER, CENTER);
    textSize(50);
    text("Grapple adventure", width/2, 100);
    
    textSize(25);
    if(!loggedIn) text("Currently NOT logged in", width/2, 620);
    else text("Logged in as: " + mainLogic.username, width/2, 620);
  }
}
