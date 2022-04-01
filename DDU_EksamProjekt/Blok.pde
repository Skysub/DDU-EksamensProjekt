class Blok {

  int blokkeIalt = 2;
  int gridSize;

  Blok(int g) {
    gridSize = g;
  }

  //tegner blokken, al translation og rotation gøres ikke her men i metoden der kalder denne metode
  //Vælger hvilken blok draw metode der skal bruges ud fra blok id'et
  void DrawBlok(int id, boolean HitboxDebug) {
    switch (id) {
    case 0:
      DrawB0();
      break;

    case 1:
      DrawB1();
      break;

    default:
      break;
    }
  }

  //returnerer typen af hitbox som blokken har, skal genlaves hvis en blok skal have mere end 1 type hitbox
  int GetType(int id) {
    switch (id) {
    case 0: //Start blok
      return 1;
    case 1:
      return 0;

    default:
      return -1;
    }
  }

  //returnerer alle hitboxes fra blokken med relativt shift i forhold til blokken bilen er i
  PVector[][] GetHitboxes(int id, int blokTurn) {
    PVector[][] temp = new PVector[0][0];
    switch (id) {
    case 0: //Start blok
      temp = BoxesB0();
      break;
    case 1:
      temp = BoxesB1();
      break;

    default:
      break;
    }
    for (int i = 0; i<temp.length; i++) {
      temp[i][0].sub(new PVector(gridSize/2, gridSize/2));
      temp[i][0].rotate(blokTurn*PI/2f);
      temp[i][0].add(new PVector(gridSize/2, gridSize/2));

      //Old code, maybe oboslete?
      //temp[i][1].rotate(blokTurn*PI/2f);
      //temp[i][0].add(new PVector(shift.x*gridSize, shift.y*gridSize));
    }
    return temp;
  }

  //Wall hitboxes
  PVector[][] BoxesB0() {
    PVector[][] boxes = new PVector[1][2];

    boxes[0][0] = new PVector(0, 0);
    boxes[0][1] = new PVector(40, 40);

    return boxes;
  }

  //Wall hitboxes
  PVector[][] BoxesB1() {
    PVector[][] boxes = new PVector[0][0];

    return boxes;
  }

  //Wall tile
  void DrawB0() {
    //square
    SetSquareSettings();
    strokeWeight(2);
    square(0, 0, gridSize);

    //For the lines
    stroke(100);
    strokeWeight(1);
    //line(0, 0, 40, 40);
    //line(0, 40, 40, 0);

    //Text
    textSize(10);
    fill(10);
    text("Wall", 20, 26);
  }

  //Background tile
  void DrawB1() {
    //square
    SetSquareSettings();
    square(0, 0, gridSize);
  }

  //Helps standardize the way the square part of a block looks, easier to make quick changes to all blocks
  void SetSquareSettings() {
    fill(250);
    stroke(20);
    strokeWeight(1);
  }
}
