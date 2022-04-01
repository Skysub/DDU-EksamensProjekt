class MainLogic {
  Keyboard kb;
  GameStateManager gameStateManager;
  Player player;
  
  boolean left, right, space;

  MainLogic(PApplet program) {
    kb = new Keyboard();
    gameStateManager = new GameStateManager();
    InitializeScreens(program);
  }

  void Update() {
    gameStateManager.Update();
  }

  void Draw() {
    gameStateManager.Draw();
  }

  void HandleInput(int x, boolean y) {
    kb.setKey(x, y);
    

    if(x == 32) space = y;
    if(x == 37) left = y;
    if(x == 39) right = y;

    //Uncomment nedenunder for at bestemme en keycode, husk at comment igen bagefter
    //println(x);

  }

  void InitializeScreens(PApplet program) {
    gameStateManager.AddGameState("MenuScreen", new MenuScreen(program, kb));
    gameStateManager.AddGameState("BaneScreen", new BaneScreen(program, kb));
  }
}
