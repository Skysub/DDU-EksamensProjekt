class BanePopUp {

  BaneScreen baneScreen;
  float size = 2.5; //inverse of size

  BanePopUp(BaneScreen baneScreen) {
    this.baneScreen = baneScreen;
  }

  int Update() {
    return 0;
  }

  void Draw(boolean done) {
    pushMatrix();
    resetMatrix();
    rectMode(CENTER); //Tegner kassen
    fill(230);
    strokeWeight(3);
    rect(width/2, height/2-50, width/size, height/size, 10);

    //tegner indholdet
    if (done) {
    } else {
    }


    popMatrix();
  }
}
