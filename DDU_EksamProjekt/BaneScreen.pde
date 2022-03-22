class BaneScreen extends GameState {  
  //Det er her vi er når der bliver spillet en bane

  Bane bane;
  Keyboard kb;

  BaneScreen(PApplet program, Keyboard kb) {
    super(program, kb);
    bane = new Bane();
    this.kb = kb;
  }

  void Update() {
    bane.Update();
  }

  void Draw() {
    bane.Draw(kb.getToggle(84), kb.getToggle(72));
  }
}
