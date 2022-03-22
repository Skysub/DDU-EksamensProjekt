class Bane {

  IntList[][] bane;
  int bred, lang, id;

  Bane() {
  }

  void LoadBane(IntList[][] b) {
    bred = b[0][0].get(0);
    lang = b[0][0].get(1);
    id   = b[0][0].get(2);
    bane = b;
  }

  //Konverterer screen koordinater til world koordinater
  PVector ScreenToWorld(PVector p) {
    return new PVector();
  }

  //Konverterer world koordinater til screen koordinater
  PVector WorldToScreen(PVector p) {
    return new PVector();
  }
}
