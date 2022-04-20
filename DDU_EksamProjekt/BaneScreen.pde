class BaneScreen extends GameState {  
  //Det er her vi er når der bliver spillet en bane

  Bane bane;
  Keyboard kb;
  Player player;
  Timer timer;

  Box2DProcessing box2d;

  boolean playing = false, baneStart = false, endZone = false, hand = false, done = false;
  int shadow = 3;
  Vec2 startPos = new Vec2(0, 0);

  boolean popup = false;
  BanePopUp popUp;

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
    player = new Player(bane, box2d, startPos);

    popUp = new BanePopUp(this);
  }

  void Update() {
    if (player.InGoalZone(kb.getToggle(72)) && playing) { //Er spilleren nået til målzonen så er dette true
      endZone = true;
      playing = false;
      done = true;
      popup = true;
    }
    if (popup) popUp.Update();
    timer.Update(playing, baneStart, endZone);

    if (playing) {
      bane.Update();
      player.Update(kb.getKey(37), kb.getKey(39), kb.Shift(32), kb.getToggle(72));
      box2d.step();
    }
    handleStart();

    hand = false;
    //if (logoutButton.Update()) hand = true;
    if (mainMenuButton.Update()) hand = true;
    if (baneMenuButton.Update()) hand = true;
    if (hand)cursor(HAND);
    else cursor(ARROW);
  }

  void Draw() {
    if (!kb.getToggle(84)) {
      drawBaneUI();
      timer.Draw();
    }
    pushMatrix();
    translate(0, 80);
    bane.Draw(kb.getToggle(84), kb.getToggle(72));
    player.Draw(kb.getToggle(72));
    popMatrix();

    if (!playing && !done) {
      textSize(100);
      textAlign(CENTER);
      fill(0, 0, 65);
      text("Press SPACE to start", width/2+shadow, height/2+shadow);       
      text("Press SPACE to start", width/2+shadow, height/2-shadow);       
      text("Press SPACE to start", width/2-shadow, height/2+shadow); 
      text("Press SPACE to start", width/2-shadow, height/2-shadow); 
      fill(237, 223, 197);
      text("Press SPACE to start", width/2, height/2);
    }

    if (popup) popUp.Draw(done);
  }

  void handleStart() {
    baneStart = false;
    if (!playing && kb.Shift(32) && !done) {
      endZone = false;
      playing = true;
      baneStart = true;
      player.finalize(); //Spilleren destrueres
      player = new Player(bane, box2d, startPos); //Spilleren bliver genskabt
    }
  }

  void drawBaneUI() {
    //logoutButton.Draw();
    mainMenuButton.Draw();
    baneMenuButton.Draw();
  }
}
