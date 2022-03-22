class Bane {
  //grids bredde og højde i pixels
  float gridSize = 40;

  Blok blok;

  IntList[][] bane;
  int bred = -1, lang = -1, id = -1;
  float[] kamera = {0, 0, 1, 1920, 1000};

  int blokkeIalt;

  Bane() {
    bane = new IntList[1][1];
    bane[0][0] = new IntList();
    bane[0][0].append(-1);

    blok = new Blok();
    blokkeIalt = blok.blokkeIalt;

    LavTestBane();
  }

  void Update() {
    //ting der skal opdateres hver frame
  }

  int Draw(boolean tileTest, boolean hitboxDebug) {
    pushMatrix();
    translate(0, 80);
    scale(kamera[3]);
    //Kald funktioner her der tegner ting
    if (bane[0][0].get(0) != -1) DrawBane(tileTest, hitboxDebug);

    popMatrix();
    return 0;
  }

  void DrawBane(boolean tileTest, boolean hitboxDebug) {
    for (int i=0; i<bred; i++) {
      for (int j=0; j<lang; j++) {
        if (bane[i][j] != null) {
          pushMatrix();
          //flytter hen til hvor vi skal tegne på griddet
          translate((gridSize*i), (gridSize*j));

          //tilføjer et lille mellemrum hvis vi debugger så man kan skelne mellem blokkene
          if (tileTest) translate(2*i, 2*j);

          //kalder en funktion der vælger hvilken metode der skal bruges alt efter hvilken blok skal tegnes
          blok.DrawBlok(bane[i][j].get(0), hitboxDebug);
          popMatrix();
        }
      }
    }
  }

  void LavTestBane() {
    IntList[][] test = new IntList[10][10];
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        test[i][j] = new IntList();
        if (i == 0 && j == 0) {
          test[0][0].append(10);
          test[0][0].append(10);
          test[0][0].append(-1);
        } else {
          test[i][j].append(0);
          test[i][j].append(0);
        }
      }
    }
    LoadBane(test);
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
