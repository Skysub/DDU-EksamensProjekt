class MainLogic {
  Keyboard kb;
  GameStateManager gameStateManager;
  Player player;
  
  MainLogic(PApplet program) {
    kb = new Keyboard();
    gameStateManager = new GameStateManager();
    InitializeScreens(program);
    gameStateManager.SkiftGameState("BaneScreen");
  }

  void Update() {
    gameStateManager.Update();
  }

  void Draw() {
    gameStateManager.Draw();
  }

  void HandleInput(int x, boolean y) {
    kb.setKey(x, y);
    
    //Der skal ikke skrives mere her, brug KeyBoard klassen til controls
    
    //Uncomment nedenunder for at bestemme en keycode, husk at comment igen bagefter
    //println(x);
  }

  void InitializeScreens(PApplet program) {
    gameStateManager.AddGameState("MenuScreen", new MenuScreen(program, kb));
    gameStateManager.AddGameState("BaneScreen", new BaneScreen(program, kb));
    gameStateManager.AddGameState("BaneMenuScreen", new BaneMenuScreen(program, kb));
  }
}
