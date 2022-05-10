class EditorPopUp {

  Bane bane;
  LevelEditorScreen levelEditorScreen;
  float size = 2.5; //inverse of size

  Button exitButton = new Button(width/2+230, 220, 120, 60, "Main menu", color(200), color(80, 100, 80), 20, color(0, 0, 0), color(255, 105, 105));
  boolean hand;


  EditorPopUp(Bane bane, PApplet program, LevelEditorScreen levelEditorScreen) {
    this.bane = bane;
    this.levelEditorScreen = levelEditorScreen;
  }

  void Update() {
    UpdateButtons();
  }

  void Draw() {
    DrawBody();
    DrawButtons();
  }

  void UpdateButtons() {
    hand = false;
    if (exitButton.Update()) hand = true;
    if (hand)cursor(HAND);
    else cursor(ARROW);

    if (exitButton.MouseReleased()) levelEditorScreen.ChangeScreen("MenuScreen");
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
  }
}
