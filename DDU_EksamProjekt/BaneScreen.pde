class BaneScreen extends GameState {  
  //Det er her vi er når der bliver spillet en bane

  Bane bane;
  Keyboard kb;
  Player player;
  Timer timer;
  
  boolean playing = false, baneStart = false, endZone;

  //int posX, int posY, int w, int h, String t, color c, color cc, int ts, color tc
  Button logoutButton = new Button(1590, 950, 210, 115, "Log out", color(235, 80, 80), color(135, 28, 28), 30, color(0, 0, 0));
  Button mainMenuButton = new Button(1300, 950, 210, 115, "Main menu", color(190, 210, 120), color(115, 135, 45), 30, color(0, 0, 0));
  Button baneMenuButton = new Button(1010, 950, 210, 115, "Baner", color(190, 210, 120), color(115, 135, 45), 30, color(0, 0, 0));

  BaneScreen(PApplet program, Keyboard kb) {
    super(program, kb);
    bane = new Bane();
    this.kb = kb;
<<<<<<< HEAD
    player = new Player(new PVector(95,96), bane);
=======
    timer = new Timer();
    player = new Player(new PVector(95,96));

>>>>>>> 56cd6b90db3f3a2717f209e8b891fe6da3b06d37
  }

  void Update() {
    bane.Update();
<<<<<<< HEAD
    player.Update(kb.getToggle(72));
=======
    timer.Update(playing, baneStart, endZone);
    player.Update();
    
    logoutButton.Update();
    mainMenuButton.Update();
    baneMenuButton.Update();
>>>>>>> 56cd6b90db3f3a2717f209e8b891fe6da3b06d37
  }

  void Draw() {
    bane.Draw(kb.getToggle(84), kb.getToggle(72));
<<<<<<< HEAD
    player.Draw(kb.getToggle(72));
=======
    drawBaneUI();
    timer.Draw();
  }

  void drawBaneUI() {
    logoutButton.Draw();
    mainMenuButton.Draw();
    baneMenuButton.Draw();
    player.Draw();
>>>>>>> 56cd6b90db3f3a2717f209e8b891fe6da3b06d37
  }
}
