class EditorPopUp { //<>//

  FileHandler fileHandler;
  Bane bane;
  LevelEditorScreen levelEditorScreen;
  float size = 2.5; //inverse of size

  Button exitButton = new Button(width/2+230, 220, 120, 60, "Main menu", color(200), color(80, 100, 80), 20, color(0, 0, 0), color(255, 105, 105));
  boolean hand;

  int timer = -3000, timerTo = -10000, timerTre = -3000;
  TextField username;
  TextField number;
  Button loadCostumLvl = new Button(width/2-300, height/2+170, 200, 50, "Load level", color(#253FFF), color(80, 100, 80), 20, color(230));
  Button saveCostumLvl = new Button(width/2+100, height/2+170, 200, 50, "Save level", color(#253FFF), color(80, 100, 80), 20, color(230));
  Button newLvl = new Button(width/2-300, height/2-200, 200, 50, "New level", color(#253FFF), color(80, 100, 80), 20, color(230));

  EditorPopUp(Bane bane, PApplet program, LevelEditorScreen levelEditorScreen, FileHandler fileHandler) {
    this.fileHandler = fileHandler;
    this.bane = bane;
    this.levelEditorScreen = levelEditorScreen;
    username = new TextField(program, "", new PVector(width/2-275, height/2+110), new PVector(150, 40), true);
    number = new TextField(program, "", new PVector(width/2+125, height/2+110), new PVector(150, 40), true);
  }

  void Update() {
    UpdateButtons();
    costumLvl();

    textSize(25);
    fill(0);
    text("Enter custom level id", width/2-200, height/2+75);
    text("Enter new id to save level", width/2+195, height/2+75);

    if (millis() < timer+3000) {
      text("Could not load level", width/2-200, height/2+250);
    }
    if (millis() < timer+3000) {
      text("Could not save level", width/2+200, height/2+250);
    }

    if (millis() < timerTo+10000) {
      textAlign(CENTER);
      textSize(13);
      text("Level saved to: "+sketchPath()+"\\custom_levels", width/2, height/2+260);
    }
  }

  void Draw() {
    DrawBody();
    DrawButtons();
  }

  void UpdateButtons() {
    hand = false;
    if (exitButton.Update()) hand = true;
    if (loadCostumLvl.Update()) hand = true;
    if (saveCostumLvl.Update()) hand = true;
    if (newLvl.Update()) hand = true;
    if (hand)cursor(HAND);
    else cursor(ARROW);

    if (exitButton.MouseReleased()) levelEditorScreen.ChangeScreen("MenuScreen");
    if (newLvl.MouseReleased()) bane.MakeEmpty();
  }

  void DrawBody() {
    pushMatrix();
    resetMatrix();
    stroke(0);
    translate(width/2-width/(2*size), (height/2-height/(2*size))-50);
    fill(230);
    strokeWeight(3);
    rect(0, 0-200/size, width/size, height/size+200, 10);

    //Til hvis menuen blev åbnet manuelt af spilleren, altså hvis spilleren ikke er i mål endnu
    textSize(30);
    fill(25);
    textAlign(LEFT, TOP);
    text("Editor Menu", 15, -200/size + 10);
    textSize(25);
    text("Press '       ' to close the menu.", 15, -200/size + 55);
    fill(255, 50, 50);
    text("TAB", 95, -200/size + 55);
    popMatrix();
  }

  void DrawButtons() {
    exitButton.Draw();
    loadCostumLvl.Draw();
    saveCostumLvl.Draw();
    newLvl.Draw();
  }

  void costumLvl() {
    username.Input(0, 10);
    username.Update();
    if (loadCostumLvl.isClicked() && username.Input(0, 10) != null) {
      if (LoadBaneNr(int(username.Input(0, 10)), true) != 0) {
        timer = millis();
      }
    }

    number.Input(0, 10);
    number.Update();
    if (saveCostumLvl.isClicked() && number.Input(0, 10) != null) {
      if (SaveBaneNr(int(number.Input(0, 10))) == 0) {
        timerTo = millis();
      } else {
        timerTre = millis();
      }
    }
  }

  int LoadBaneNr(int baneId, boolean custom) {
    IntList[][] b;
    if (custom) b = fileHandler.LoadLevelFile("\\custom_levels\\level_"+baneId+".csv");
    else b = fileHandler.LoadLevelFile("\\data\\levels\\level_"+baneId+".csv");
    if (b != null) {
      levelEditorScreen.LoadBane(b);
      return 0;
    } else return -1;
  }

  int SaveBaneNr(int baneId) {
    bane.bane[0][0].set(2, baneId);
    return fileHandler.MakeLevelFile(bane.bane);
  }
}
