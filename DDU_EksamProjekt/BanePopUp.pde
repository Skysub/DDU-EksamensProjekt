class BanePopUp {

  BaneScreen baneScreen;
  BaneScoreboard sb;
  float size = 2.5; //inverse of size

  //int posX, int posY, int w, int h, String t, color c, color cc, int ts, color tc
  Button mainMenuButton = new Button(int(width/2-width/(2*size))+82, int(height/2-height/(2*size))+430, 170, 60, "Main menu", color(190, 210, 120), color(115, 135, 45), 20, color(0, 0, 0));
  Button baneMenuButton = new Button(int(width/2-width/(2*size))+522, int(height/2-height/(2*size))+430, 170, 60, "Levels", color(190, 210, 120), color(115, 135, 45), 20, color(0, 0, 0));
  Button nextLevelButton = new Button(int(width/2-width/(2*size))+302, int(height/2-height/(2*size))+430, 170, 60, "Next level", color(200, 200, 255), color(115, 135, 45), 20, color(0, 0, 0));
  boolean hand;
  int levelNr;

  BanePopUp(BaneScreen baneScreen, PApplet program) {
    this.baneScreen = baneScreen;
    sb = new BaneScoreboard(program);
  }

  int Update(boolean done, String un, int lNr, String[] time) {
    levelNr = lNr;

    hand = false;
    if (mainMenuButton.Update()) hand = true;
    if (baneMenuButton.Update()) hand = true;
    if (done && baneScreen.bane.bane[0][0].get(2)+1 < baneScreen.lSelScreen.getTotalLevels() && !baneScreen.lSelScreen.getCustom() && nextLevelButton.Update()) hand = true;
    if (hand)cursor(HAND);
    else cursor(ARROW);

    if (mainMenuButton.MouseReleased()) {
      baneScreen.ChangeScreen("MenuScreen");
      baneScreen.popup = false;
      baneScreen.ToggleTab(false);
    }
    if (baneMenuButton.MouseReleased()) {
      baneScreen.ChangeScreen("LevelSelectionScreen"); 
      baneScreen.popup = false;
      baneScreen.ToggleTab(false);
    }
    if (nextLevelButton.isClicked()) {
      baneScreen.lSelScreen.LoadBaneNr(baneScreen.bane.bane[0][0].get(2)+1, baneScreen.lSelScreen.getCustom()); //<>//
      //levelNr++;
      nextLevelButton.clicked = false;
    }
    
    if (un != null && done) {
      //println(levelNr);
      sb.Update(levelNr, un, time[0], int(time[2]), baneScreen.lSelScreen.getCustom());
    }   
    return 0;
  }

  void Draw(boolean done, String[] time, boolean newRecord, String un) {
    pushMatrix();
    resetMatrix();
    //rectMode(CENTER); //Tegner kassen
    translate(width/2-width/(2*size), (height/2-height/(2*size))-50);
    //tegner indholdet
    fill(230);
    strokeWeight(3);
    rect(0, 0-200/size, width/size, height/size+200, 10);
    if (done) { //Til hvis banen er færdig
      textSize(30);
      fill(25);
      textAlign(CENTER);
      text("Time: "+time[0]+"         Record: "+time[1], width/(2*size), -200/size + 87);
      if (newRecord)text("New Record!", width/(2*size), -200/size + 130);
      textAlign(LEFT, TOP);
      text("Congratulations! Level "+ levelNr +" cleared.", 15, -200/size + 10);
      textSize(22);
      textAlign(CENTER);
      text("Press '  ' to play the level again.", width/(2*size), 460);
      fill(255, 50, 50);
      text("R", width/(2*size) - 92, 460);
      if (un != null) sb.Draw(size);
    } else { //Til hvis menuen blev åbnet manuelt af spilleren, altså hvis spilleren ikke er i mål endnu
      textSize(30);
      fill(25);
      textAlign(LEFT, TOP);
      text("Pause Menu", 15, -200/size + 10);
      textSize(25);
      text("Press '       ' to close the menu.", 15, -200/size + 55);
      fill(255, 50, 50);
      text("TAB", 95, -200/size + 55);
    }
    textAlign(CENTER);
    if (un == null) text("You are not logged in so your score won't be saved", width/(2*size), 430); 
    popMatrix();
    drawButtons(done);
  }

  void drawButtons(boolean done) {
    mainMenuButton.Draw();
    baneMenuButton.Draw();
    if (done && baneScreen.bane.bane[0][0].get(2)+1 < baneScreen.lSelScreen.getTotalLevels() && !baneScreen.lSelScreen.getCustom())nextLevelButton.Draw();
  }
}
