class MainLogic {
  Keyboard kb;
  GameStateManager gameStateManager;
  Player player;
  BaneHandler baneHandler;
  String username;

  MainLogic(PApplet program) {
    kb = new Keyboard();
    gameStateManager = new GameStateManager();
    baneHandler = new BaneHandler();
    InitializeScreens(program);
    gameStateManager.SkiftGameState("MenuScreen");
  }

  void Update() {

    gameStateManager.Update();

    kb.Update();
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
    BaneScreen bs = new BaneScreen(program, kb);
    LevelSelectionScreen lss = new LevelSelectionScreen(program, kb, bs, baneHandler);
    bs.lSelScreen = lss;

    gameStateManager.AddGameState("MenuScreen", new MenuScreen(program, kb));
    gameStateManager.AddGameState("BaneScreen", bs);
    gameStateManager.AddGameState("LogInScreen", new LoginScreen(program, kb));
    gameStateManager.AddGameState("LevelSelectionScreen", lss);
  }
}
