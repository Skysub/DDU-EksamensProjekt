class MainLogic {
  Keyboard kb;
  GameStateManager gameStateManager;
  //Player player;
  FileHandler fileHandler;
  LevelEditorScreen les;
  String username;
  SQLite db;

  MainLogic(PApplet program) {
    kb = new Keyboard();
    gameStateManager = new GameStateManager();
    fileHandler = new FileHandler(program);
    InitializeScreens(program);
    gameStateManager.SkiftGameState("MenuScreen");

    db = new SQLite(program, sketchPath()+"\\data\\hookdb.SQLite");
    db.connect();
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

  //Instantierer de forskellige skærme og sætter dem ind i gameStateManageren
  void InitializeScreens(PApplet program) {
    BaneScreen bs = new BaneScreen(program, kb, fileHandler);
    LevelSelectionScreen lss = new LevelSelectionScreen(program, kb, bs, fileHandler);
    bs.lSelScreen = lss;

    les = new LevelEditorScreen(program, kb, fileHandler);

    gameStateManager.AddGameState("MenuScreen", new MenuScreen(program, kb));
    gameStateManager.AddGameState("BaneScreen", bs);
    gameStateManager.AddGameState("LogInScreen", new LoginScreen(program, kb));
    gameStateManager.AddGameState("LevelSelectionScreen", lss);
    gameStateManager.AddGameState("LevelEditorScreen", les);
    gameStateManager.AddGameState("ControlsScreen", new ControlsScreen(program, kb));
  }
}
