class LevelSelectionScreen extends GameState {
  Button MenuScreenButton = new Button(width/2-150, 600, 300, 100, "Main Menu", color(#253FFF), color(80, 100, 80), 20, color(230));
  Button baneScreenButton = new Button(width/2-150, 450, 300, 100, "BaneScreen (debug)", color(#253FFF), color(80, 100, 80), 20, color(230));
  Button loadCostumLvl = new Button(150, height-190, 200, 50, "Load level", color(#253FFF), color(80, 100, 80), 20, color(230));
  boolean hand;
  BaneScreen baneScreen;
  FileHandler fileHandler;
  int timer = -3000;

  //ArrayList<Button> levelButtons = new ArrayList<Button>();
  TextField username;

  LevelSelectionScreen(PApplet program, Keyboard kb, BaneScreen baneScreen, FileHandler fileHandler) {
    super(program, kb);
    this.baneScreen = baneScreen;
    this.fileHandler = fileHandler;
    username = new TextField(program, "", new PVector(175, height-265), new PVector(150, 40), true);
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
    textAlign(LEFT);
    textSize(25);
    text("Enter costum level id", 130, height-300);

    if (millis() < timer+3000) {
      text("Could not load level", 130, height-100);
    }
  }

  void handleButton() {
    hand = false;
    if (MenuScreenButton.Update()) hand = true;
    if (baneScreenButton.Update()) hand = true;
    if (loadCostumLvl.Update()) hand = true;
    if (hand)cursor(HAND);
    else cursor(ARROW);

    if (MenuScreenButton.isClicked()) ChangeScreen("MenuScreen");
    if (baneScreenButton.isClicked()) ChangeScreen("BaneScreen");
  }

  int LoadBaneNr(int baneId) {
    IntList[][] b = fileHandler.LoadLevelFile("\\levels\\level_"+baneId+".csv");
    if (b != null) {
      baneScreen.bane.LoadBane(b);
      ChangeScreen("BaneScreen");
      return 0;
    } else return -1;
  }

  void costumLvl() {
    username.input(0, 10);
    username.Update();
    if (loadCostumLvl.isClicked() && username.input(0, 10) != null) {
      if (LoadBaneNr(int(username.input(0, 10))) != 0) {

        timer = millis();
      }
    }
  }
}
