class MainLogic {
  Keyboard kb;
  GameStateManager gameStateManager;
  Timer timer;
  
  boolean playing = false, baneStart = false, loginScreenOpen = true, endZone;


  MainLogic(PApplet program) {
    kb = new Keyboard();
    gameStateManager = new GameStateManager();
    InitializeScreens(program);
    gameStateManager.SkiftGameState("BaneScreen");
    timer = new Timer();
  }

  void Update() {
    gameStateManager.Update();
    timer.Update(playing, baneStart, loginScreenOpen, endZone);
  }

  void Draw() {
    gameStateManager.Draw();
    timer.Draw();
  }

  void HandleInput(int x, boolean y) {
    kb.setKey(x, y);
    
    //Uncomment nedenunder for at bestemme en keycode, husk at comment igen bagefter
    //println(x);
  }

  void InitializeScreens(PApplet program) {
    gameStateManager.AddGameState("MenuScreen", new MenuScreen(program, kb));
    gameStateManager.AddGameState("BaneScreen", new BaneScreen(program, kb));
  }
}
