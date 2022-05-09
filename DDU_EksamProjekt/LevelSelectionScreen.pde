class LevelSelectionScreen extends GameState {
  Button MenuScreenButton = new Button(width/2-150, 600, 300, 100, "Main Menu", color(#253FFF), color(80, 100, 80), 20, color(230));
  Button baneScreenButton = new Button(width/2-150, 450, 300, 100, "BaneScreen (debug)", color(#253FFF), color(80, 100, 80), 20, color(230));
  Button loadCostumLvl = new Button(150, height-190, 200, 50, "Load level", color(#253FFF), color(80, 100, 80), 20, color(230));
  boolean hand, lastCustom = true;
  BaneScreen baneScreen;
  FileHandler fileHandler;
  int timer = -3000, totalLevels = 1;
  IntList[][] b;

  ArrayList<Button> levelButtons = new ArrayList<Button>();
  TextField username;

  LevelSelectionScreen(PApplet program, Keyboard kb, BaneScreen baneScreen, FileHandler fileHandler) {
    super(program, kb);
    this.baneScreen = baneScreen;
    this.fileHandler = fileHandler;
    username = new TextField(program, "", new PVector(175, height-265), new PVector(150, 40), true);

    MakeLevelButtons();
  }

  void Update() {
    handleButton();
    costumLvl();
  }

  void Draw() {
    fill(20);
    textSize(40);
    text("Level selection", 400, 200);
    MenuScreenButton.Draw();
    baneScreenButton.Draw();
    loadCostumLvl.Draw();
    for (Button x : levelButtons) {
      x.Draw();
    }
    textAlign(LEFT);
    textSize(25);
    fill(255);
    text("Enter costum level id", 130, height-300);

    if (millis() < timer+3000) {
      text("Could not load level", 130, height-100);
    }
  }

  void handleButton() {
    hand = false;

    for (Button x : levelButtons) {
      if (x.Update()) hand = true;
    }

    if (MenuScreenButton.Update()) hand = true;
    if (baneScreenButton.Update()) hand = true;
    if (loadCostumLvl.Update()) hand = true;
    if (hand)cursor(HAND);
    else cursor(ARROW);

    if (MenuScreenButton.isClicked()) ChangeScreen("MenuScreen");
    if (baneScreenButton.isClicked()) ChangeScreen("BaneScreen");

    for (int i = 0; i < totalLevels; i++) {
      if (levelButtons.get(i).isClicked()) LoadBaneNr(i, false);
    }
  }

  int LoadBaneNr(int baneId, boolean custom) {
    //IntList[][] b;                                                                                HER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    lastCustom = custom;
    if (custom) b = fileHandler.LoadLevelFile("\\custom_levels\\level_"+baneId+".csv");
    else b = fileHandler.LoadLevelFile("\\data\\levels\\level_"+baneId+".csv");
    if (b != null) {
      baneScreen.bane.LoadBane(b);
      ChangeScreen("BaneScreen");
      return 0;
    } else return -1;
  }

  void MakeLevelButtons() {
    for (int i = 1; i < totalLevels+1; i++) {
      levelButtons.add(new Button(width-300, (i*((height-200)/(totalLevels+1))), 220, 65, "Level "+i, color(#253FFF), color(80, 100, 80), 20, color(230)));
    }
  }

  void costumLvl() {
    username.Input(0, 10);
    username.Update();
    if (loadCostumLvl.isClicked() && username.Input(0, 10) != null) {
      if (LoadBaneNr(int(username.Input(0, 10)), true) != 0) {

        timer = millis();
      }
    }
  }

  boolean getCustom() {
    return lastCustom;
  }

  int getTotalLevels() {
    return totalLevels;
  }
}
