class Bane {
  //grids bredde og højde i pixels
  float gridSize = 40;

  IntList[][] bane;
  int bred = -1, lang = -1, id = -1;
  float[] kamera = {0, 0, 1, 1920, 1000};

  Bane() {
    bane = new IntList[1][1];
    bane[0][0] = new IntList();
    bane[0][0].append(-1);
  }

  void Update() {
  }

  void Draw() {
  }





  float[] getKamera() {
    return kamera;
  }

  void LoadBane(IntList[][] b) {
    bred = b[0][0].get(0);
    lang = b[0][0].get(1);
    id   = b[0][0].get(2);
    bane = b;
  }

  //Konverterer screen koordinater til world koordinater
  PVector ScreenToWorld(PVector p) {
    return new PVector((p.x/kamera[3])+kamera[0], (p.y/kamera[3])+kamera[1]);
  }

  //Konverterer world koordinater til screen koordinater
  PVector WorldToScreen(PVector p) {
    return new PVector((p.x-kamera[0])*kamera[3], (p.y-kamera[1])*kamera[3]);
  }

  //Konverterer world koordinater til grid koordinater
  PVector WorldToGrid(PVector p) {
    return new PVector(floor(p.x/gridSize), floor(p.y/gridSize));
  }
}
