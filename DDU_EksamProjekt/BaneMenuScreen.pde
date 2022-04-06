class BaneMenuScreen extends GameState {

  Button baneButton = new Button(width/2-150, 300, 300, 80, "Bane 1", color(80, 235, 80), color(135, 28, 28), 20, color(0, 0, 0));

  BaneMenuScreen(PApplet program, Keyboard kb) {
    super(program, kb);
  }

  void Update() {
    baneButton.Update();
    
    //I know we ikke skal gøre det sådan, er bare midlertidig
    if(baneButton.isClicked()) mainLogic.gameStateManager.SkiftGameState("BaneScreen");
  }

  void Draw() {
   
    baneButton.Draw();

    fill(0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("Vælg bane", width/2, 200);
  }
}
