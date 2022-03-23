class BaneScreen extends GameState {  
  //Det er her vi er når der bliver spillet en bane

  Bane bane;
  Keyboard kb;
  Player player;

  BaneScreen(PApplet program, Keyboard kb) {
    super(program, kb);
    bane = new Bane();
    this.kb = kb;
    player = new Player(new PVector(95,96), bane);
  }

  void Update() {
    bane.Update();
    player.Update(kb.getToggle(72));
  }

  void Draw() {
    bane.Draw(kb.getToggle(84), kb.getToggle(72));
    player.Draw(kb.getToggle(72));
  }
}
