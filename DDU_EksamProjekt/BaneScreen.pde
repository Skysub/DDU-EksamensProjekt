class BaneScreen extends GameState {  
  //Det er her vi er når der bliver spillet en bane

  Bane bane;
  Keyboard kb;
  Player player;
  Timer timer;

  boolean playing = false, baneStart = false, endZone;

  //int posX, int posY, int w, int h, String t, color c, color cc, int ts, color tc
  Button logoutButton = new Button(1630, 10, 170, 60, "Log out", color(235, 80, 80), color(135, 28, 28), 20, color(0, 0, 0));
  Button mainMenuButton = new Button(1360, 10, 170, 60, "Main menu", color(190, 210, 120), color(115, 135, 45), 20, color(0, 0, 0));
  Button baneMenuButton = new Button(1090, 10, 170, 60, "Baner", color(190, 210, 120), color(115, 135, 45), 20, color(0, 0, 0));

  BaneScreen(PApplet program, Keyboard kb) {
    super(program, kb);
    bane = new Bane();
    this.kb = kb;
    timer = new Timer();
    player = new Player(new PVector(95, 123), bane);
  }

  void Update() {
    bane.Update();
    player.Update(kb.getToggle(72));

    timer.Update(playing, baneStart, endZone);

    logoutButton.Update();
    mainMenuButton.Update();
    baneMenuButton.Update();
  }

  void Draw() {
    bane.Draw(kb.getToggle(84), kb.getToggle(72));
    if (!kb.getToggle(84)) {
      player.Draw(kb.getToggle(72));

      drawBaneUI();
      timer.Draw();
    }
  }

  void drawBaneUI() {
    logoutButton.Draw();
    mainMenuButton.Draw();
    baneMenuButton.Draw();
  }
}