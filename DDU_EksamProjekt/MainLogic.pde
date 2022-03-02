class MainLogic {
  Keyboard kb;
  GameStateManager gameStateManager;

  MainLogic(PApplet program) {
    kb = new Keyboard();
    gameStateManager = new GameStateManager();
    InitializeScreens(program);
  }

  void Update() {
  }

  void HandleInput(int x, boolean y) {
    kb.setKey(x, y);
  }

  void InitializeScreens(PApplet program) {
  }
}
