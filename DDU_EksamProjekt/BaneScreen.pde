class BaneScreen extends GameState {  
  //Det er her vi er når der bliver spillet en bane

  Bane bane;
  Keyboard kb;
  Player player;
  Timer timer;

  Box2DProcessing box2d;

  boolean playing = false, baneStart = false, endZone;

  //int posX, int posY, int w, int h, String t, color c, color cc, int ts, color tc
  Button logoutButton = new Button(1630, 10, 170, 60, "Log out", color(235, 80, 80), color(135, 28, 28), 20, color(0, 0, 0));
  Button mainMenuButton = new Button(1360, 10, 170, 60, "Main menu", color(190, 210, 120), color(115, 135, 45), 20, color(0, 0, 0));
  Button baneMenuButton = new Button(1090, 10, 170, 60, "Baner", color(190, 210, 120), color(115, 135, 45), 20, color(0, 0, 0));

  BaneScreen(PApplet program, Keyboard kb) {
    super(program, kb);

    box2d = new Box2DProcessing(program);  
    box2d.createWorld();
    box2d.setGravity(0, -15);

    bane = new Bane(box2d);
    this.kb = kb;
    timer = new Timer();
    player = new Player(bane, box2d, new Vec2(0, 0));
  }

  void Update() {

    bane.Update();
    player.Update(kb.getKey(37), kb.getKey(39), kb.Shift(32), kb.getToggle(72));

    box2d.step();


    timer.Update(playing, baneStart, endZone);

    logoutButton.Update();
    mainMenuButton.Update();
    baneMenuButton.Update();
  }

  void Draw() {
    pushMatrix();
    translate(0, 80);
    bane.Draw(kb.getToggle(84), kb.getToggle(72));
    if (!kb.getToggle(84)) {
      player.Draw(kb.getToggle(72));
      popMatrix();

      drawBaneUI();
      timer.Draw();
    } else popMatrix();
  }

  void drawBaneUI() {
    logoutButton.Draw();
    mainMenuButton.Draw();
    baneMenuButton.Draw();
  }
}
