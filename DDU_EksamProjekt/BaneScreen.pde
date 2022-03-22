class BaneScreen extends GameState {  
  //Det er her vi er når der bliver spillet en bane

  Bane bane;

  BaneScreen(PApplet program) {
    super(program);
    bane = new Bane();
  }

  void Update() {
    bane.Update();
  }

  void Draw() {
    bane.Draw();
  }
}
