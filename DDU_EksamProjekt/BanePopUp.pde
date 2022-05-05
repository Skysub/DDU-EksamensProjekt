class BanePopUp {

  BaneScreen baneScreen;
  float size = 2.5; //inverse of size


  //int posX, int posY, int w, int h, String t, color c, color cc, int ts, color tc
  Button mainMenuButton = new Button(int(width/2-width/(2*size))+82, int(height/2-height/(2*size))+280, 170, 60, "Main menu", color(190, 210, 120), color(115, 135, 45), 20, color(0, 0, 0));
  Button baneMenuButton = new Button(int(width/2-width/(2*size))+522, int(height/2-height/(2*size))+280, 170, 60, "Levels", color(190, 210, 120), color(115, 135, 45), 20, color(0, 0, 0));
  Button nextLevelButton = new Button(int(width/2-width/(2*size))+302, int(height/2-height/(2*size))+280, 170, 60, "Next level", color(200, 200, 255), color(115, 135, 45), 20, color(0, 0, 0));
  boolean hand;

  BanePopUp(BaneScreen baneScreen) {
    this.baneScreen = baneScreen;
  }

  int Update(boolean done) {
    hand = false;
    if (mainMenuButton.Update()) hand = true;
    if (baneMenuButton.Update()) hand = true;
    if (done && nextLevelButton.Update()) hand = true;
    if (hand)cursor(HAND);
    else cursor(ARROW);

    if (mainMenuButton.MouseReleased()) baneScreen.ChangeScreen("MenuScreen");
    if (baneMenuButton.MouseReleased()) baneScreen.ChangeScreen("LevelSelectionScreen");
    //if (nextLevelButton.MouseReleased()) baneScreen.lSelScreen.LoadBaneNr(baneScreen.bane.bane[0][0].get(2)+1);

    return 0;
  }

  void Draw(boolean done, String[] time, boolean newRecord) {
    pushMatrix();
    resetMatrix();
    //rectMode(CENTER); //Tegner kassen
    translate(width/2-width/(2*size), (height/2-height/(2*size))-50);
    fill(230);
    strokeWeight(3);
    rect(0, 0, width/size, height/size, 10);

    //tegner indholdet
    if (done) { //Til hvis banen er færdig
      textSize(30);
      fill(25);
      textAlign(CENTER);
      text("Time: "+time[0]+"         Record: "+time[1], width/(2*size), 180);
      if (newRecord)text("New Record!", width/(2*size), 230);
      textAlign(LEFT, TOP);
      text("Congratulations! Level cleared.", 15, 10);
      textSize(22);
      textAlign(CENTER);
      text("Press '  ' to play the level again.", width/(2*size), 300);
      fill(255, 50, 50);
      text("R", width/(2*size) - 92, 300);
    } else { //Til hvis menuen blev åbnet manuelt af spilleren, altså hvis spilleren ikke er i mål endnu
      textSize(30);
      fill(25);
      textAlign(LEFT, TOP);
      text("Pause Menu", 15, 10);
      textSize(25);
      text("Press '       ' to close the menu.", 15, 55);
      fill(255, 50, 50);
      text("TAB", 95, 55);
    }
    popMatrix();
    drawButtons(done);
  }

  void drawButtons(boolean done) {
    mainMenuButton.Draw();
    baneMenuButton.Draw();
    if (done)nextLevelButton.Draw();
  }
}
