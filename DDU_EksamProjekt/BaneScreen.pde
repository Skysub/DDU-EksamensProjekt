class BaneScreen extends GameState {   //<>//
  //Det er her vi er når der bliver spillet en bane

  Bane bane;
  LevelSelectionScreen lSelScreen;
  FileHandler fileHandler;
  Keyboard kb;
  Player player;
  Timer timer;

  Box2DProcessing box2d;

  boolean playing = false, baneStart = false, endZone = false, hand = false, done = false, getRecord = true;
  int shadow = 3, levelNr, recordValue;
  IntList[][] b;
  String possibleRecord, record;
  String[] times;

  boolean popup = false;
  BanePopUp popUp;

  BaneScreen(PApplet program, Keyboard kb, FileHandler fileHandler) {
    super(program, kb);
    this.fileHandler = fileHandler;

    box2d = new Box2DProcessing(program);  
    box2d.createWorld();
    box2d.setGravity(0, -35);

    bane = new Bane(box2d, fileHandler, false);
    this.kb = kb;
    timer = new Timer();

    player = new Player(bane, box2d, bane.getStartPos());

    popUp = new BanePopUp(this, program);
  }

  void Update() {
    if (!done)popup = kb.getToggle(9);
    if (kb.Shift(82)) {
      reset();
      bane.ReloadBane();
    }
    if (player.InGoalZone(kb.getToggle(72)) && playing) { //Er spilleren nået til målzonen så er dette true
      endZone = true;
      playing = false;
      done = true;
      popup = true;
    }

    timer.Update(playing, baneStart, endZone);
    levelNr = bane.bane[0][0].get(2) + 1;

    if (getRecord) {
      times = timer.getText();
      possibleRecord = times[0];
      recordValue = int(times[2]);

      if (mainLogic.username != null)record = popUp.sb.getRecord(possibleRecord, recordValue, mainLogic.username, levelNr, lSelScreen.getCustom());
      if (record == null) record = "";
      getRecord = false;
    }


    if (popup) {
      popUp.Update(done, mainLogic.username, levelNr, timer.getText());    
      //levelNr = bane.bane[0][0].get(2) + 1;
      if (bane.bane[0][0].get(2) + 1 != levelNr) {
        reset();
      }
    } else {
      if (playing) {
        bane.Update();
        if (player.Update(kb.getKey(37) || kb.getKey(65), kb.getKey(39) || kb.getKey(68), kb.Shift(32), kb.getToggle(72), kb.getToggle(76), kb.getKey(16))) PlayerDied();
        box2d.step();
      }
      handleStart();
    }
  }

  void Draw() {
    background(95, 90, 100);
    pushMatrix();
    translate(0, 80);
    bane.Draw(kb.getToggle(84), kb.getToggle(72), kb.getToggle(67));
    player.Draw(kb.getToggle(72), bane.getKamera());
    popMatrix();
    if (!kb.getToggle(84)) {
      timer.Draw(record);
    }
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

    if (popup && mainLogic.username == null) popUp.Draw(done, timer.getText(), timer.getNewRecord(), mainLogic.username);
    if (popup && mainLogic.username != null) popUp.Draw(done, timer.getText(), popUp.sb.newRecord, mainLogic.username);
    }

  void reset() {
    endZone = false;
    playing = false;
    done = false;
    popUp.sb.first = true;
    popup = false;
    getRecord = true;

    player.finalize(); //Spilleren destrueres
    player = new Player(bane, box2d, bane.getStartPos()); //Spilleren bliver genskabt
    player.Update(kb.getKey(37) || kb.getKey(65), kb.getKey(39) || kb.getKey(68), kb.Shift(32), kb.getToggle(72), kb.getToggle(76), kb.getKey(16));
  }


  void LoadBane(IntList[][] a) {
    b = a;
    bane.LoadBane(a);
    timer.ResetRecord();
    timer.ResetTimer();
    reset();
  }

  void handleStart() {
    baneStart = false;
    if (!playing && kb.Shift(32) && !done) {
      endZone = false;
      playing = true;
      baneStart = true;
      player.finalize(); //Spilleren destrueres
      player = new Player(bane, box2d, bane.getStartPos()); //Spilleren bliver genskabt
    }
  }

  void WorldSetup(PApplet program) {
    box2d = new Box2DProcessing(program);  
    box2d.createWorld();
    box2d.setGravity(0, -35);
    bane = new Bane(box2d, fileHandler, false);
    player = new Player(bane, box2d, bane.getStartPos());
  }

  void ToggleTab(boolean x) {
    kb.setToggle(9, x);
  }

  //Denne funktion skal køres når spilleren dør
  void PlayerDied() {
    reset();
    bane.ReloadBane();
    //Yderligere kode, måske spil en sound effekt. En eksplosion måske???
    //Vær kreativ
  }

  void OnEnter() {
    kb.setToggle(67, true);
    reset();
    bane.ReloadBane();
  }
}
