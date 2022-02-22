class MainLogic {
  Keyboard kb;

  MainLogic() {
    kb = new Keyboard();
  }

  void Update() {
  }

  void HandleInput(int x, boolean y) {
    kb.setKey(x, y);
  }
}
