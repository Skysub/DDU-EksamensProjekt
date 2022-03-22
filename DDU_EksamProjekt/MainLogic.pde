class MainLogic {
  Keyboard kb;
  GameStateManager gameStateManager;

  MainLogic(PApplet program) {
    kb = new Keyboard();
    gameStateManager = new GameStateManager();
    InitializeScreens(program);
    gameStateManager.SkiftGameState("MenuScreen");
  }

  void Update() {
    gameStateManager.Update();
  }

  void Draw() {
    gameStateManager.Draw();
  }

  void HandleInput(int x, boolean y) {
    kb.setKey(x, y);
  }

  void InitializeScreens(PApplet program) {
    gameStateManager.AddGameState("MenuScreen", new MenuScreen(program));
    gameStateManager.AddGameState("BaneScreen", new BaneScreen(program));
  }
}
