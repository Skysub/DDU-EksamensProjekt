class MainLogic {
  Keyboard kb;
  GameStateManager gameStateManager;
  Player player;
  
  boolean left, right, space;

  MainLogic(PApplet program) {
    kb = new Keyboard();
    gameStateManager = new GameStateManager();
    InitializeScreens(program);
    player = new Player();
  }

  void Update() {
    player.Update(left, right, space);
  }

  void HandleInput(int x, boolean y) {
    kb.setKey(x, y);
    
    if(x == 32) space = y;
    if(x == 37) left = y;
    if(x == 39) right = y;
  }

  void InitializeScreens(PApplet program) {
  }
}
