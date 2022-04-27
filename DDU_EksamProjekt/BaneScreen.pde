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
    if (!done)popup = kb.getToggle(9);
    if (kb.Shift(82)) reset();
    if (player.InGoalZone(kb.getToggle(72)) && playing) { //Er spilleren nået til målzonen så er dette true
      endZone = true;
      playing = false;
      done = true;
      popup = true;
    }
    timer.Update(playing, baneStart, endZone);
    if (popup) popUp.Update();
    else {

      if (playing) {
        bane.Update();
        player.Update(kb.getKey(37), kb.getKey(39), kb.Shift(32), kb.getToggle(72));
        box2d.step();
      }
      handleStart();
    }
  }

  void Draw() {
    if (!kb.getToggle(84)) {
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

    if (popup) popUp.Draw(done, timer.getText(), timer.getNewRecord());
  }

  void reset() {
    endZone = false;
    playing = false;
    done = false;
    popup = false;

    player.finalize(); //Spilleren destrueres
    player = new Player(bane, box2d, startPos); //Spilleren bliver genskabt
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
}
