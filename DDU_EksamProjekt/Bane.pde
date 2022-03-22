class Bane {
  //grids bredde og højde i pixels
  float gridSize = 40;

  Blok blok;

  IntList[][] bane, tileSetTest;
  int bred = -1, lang = -1, id = -1;
  float[] kamera = {0, 0, 1, 1920, 1000};

  int blokkeIalt;

  Bane() {
    bane = new IntList[1][1];
    bane[0][0] = new IntList();
    bane[0][0].append(-1);

    blok = new Blok();
    blokkeIalt = blok.blokkeIalt;

    LavTileTestBane();
    LavTestBane();
  }

  void Update() {
    //ting der skal opdateres hver frame
  }

  int Draw(boolean tileTest, boolean hitboxDebug) {
    pushMatrix();
    translate(0, 80);
    scale(kamera[2]);
    //Kald funktioner her der tegner ting
    if (bane[0][0].get(0) != -1) DrawBane(tileTest, hitboxDebug);

    popMatrix();
    return 0;
  }

  void DrawBane(boolean tileTest, boolean hitboxDebug) {
    if (!tileTest) { //Banen tegnes
      for (int i=0; i<bred; i++) {
        for (int j=0; j<lang; j++) {
          if (bane[i][j] != null) {
            pushMatrix();
            //flytter hen til hvor vi skal tegne på griddet
            translate((gridSize*i), (gridSize*j));

            //kalder en funktion der vælger hvilken metode der skal bruges alt efter hvilken blok skal tegnes
            blok.DrawBlok(bane[i][j].get(0), hitboxDebug);
            popMatrix();
          }
        }
      }
    } else { //Displayer tileSettet
      for (int i=0; i<tileSetTest[0][0].get(0); i++) {
        for (int j=0; j<tileSetTest[0][0].get(1); j++) {
          pushMatrix();
          //flytter hen til hvor vi skal tegne på griddet
          translate((gridSize*i), (gridSize*j));

          //tilføjer et lille mellemrum hvis vi debugger så man kan skelne mellem blokkene
          translate(2*i, 2*j);

          //kalder en funktion der vælger hvilken metode der skal bruges alt efter hvilken blok skal tegnes
          blok.DrawBlok(tileSetTest[i][j].get(0), hitboxDebug);
          popMatrix();
        }
      }
    }
  }

  //Til test og debugging
  void LavTestBane() {
    IntList[][] test = new IntList[45][20];
    for (int i = 0; i < 45; i++) {
      for (int j = 0; j < 20; j++) {
        test[i][j] = new IntList();
        if (i == 0 && j == 0) {
          test[0][0].append(45);
          test[0][0].append(20);
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
    return new PVector((p.x/kamera[2])+kamera[0], (p.y/kamera[2])+kamera[1]);
  }

  //Konverterer world koordinater til screen koordinater
  PVector WorldToScreen(PVector p) {
    return new PVector((p.x-kamera[0])*kamera[2], (p.y-kamera[1])*kamera[2]);
  }

  //Konverterer world koordinater til grid koordinater
  PVector WorldToGrid(PVector p) {
    return new PVector(floor(p.x/gridSize), floor(p.y/gridSize));
  }

  //Til test af tileSettet
  void LavTileTestBane() {
    IntList[][] test = new IntList[40][20];
    for (int i = 0; i < 40; i++) {
      for (int j = 0; j < 20; j++) {
        test[i][j] = new IntList();
        if (i == 0 && j == 0) {
          test[0][0].append(40);
          test[0][0].append(20);
          test[0][0].append(-2);
        } else {
          if (i+(j*40-1)<blokkeIalt) {    
            test[i][j].append(i+(j*40-1));
          }
          test[i][j].append(-1);
          test[i][j].append(0);
        }
      }
    }
    tileSetTest = test;
  }
}
