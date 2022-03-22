class Blok {

  int blokkeIalt = 1;

  Blok() {
  }

  //tegner blokken, al translation og rotation gøres ikke her men i metoden der kalder denne metode
  //Vælger hvilken blok draw metode der skal bruges ud fra blok id'et
  void DrawBlok(int id, boolean HitboxDebug) {

    switch (id) {
    case 0:
      DrawB0();
      break;

    default:
      DrawB0();
    }
  }

  void DrawB0() {
    println("0");
    fill(255);
    stroke(20);
    square(0, 0, 40);
    line(0, 0, 40, 40);
    line(0, 40, 40, 0);
  }
}
