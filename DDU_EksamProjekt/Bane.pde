class Bane { //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
  //grids bredde og højde i pixels
  int gridSize = 40;

  Blok blok;
  Box2DProcessing box2d;

  IntList[][] bane, tileSetTest;
  int bred = -1, lang = -1, id = -1;
  float[] kamera = {0, 0, 1, 1920, 1000};

  int blokkeIalt;

  Bane(Box2DProcessing b) {
    box2d = b;

    bane = new IntList[1][1];
    bane[0][0] = new IntList();
    bane[0][0].append(-1);

    blok = new Blok(gridSize, box2d);
    blokkeIalt = blok.blokkeIalt;

    LavTileTestBane();
    LavTestBane();

    LavBaneIVerden();
  }

  void Update() {
    //kamera[2] -= 0.001;
  }

  int Draw(boolean tileTest, boolean hitboxDebug) {
    rectMode(CORNER);
    pushMatrix();
    if (!tileTest) translate(kamera[0], kamera[1]);
    scale(kamera[2]);
    //Kald funktioner her der tegner ting
    if (bane[0][0].get(0) != -1) DrawBane(tileTest, hitboxDebug);
    popMatrix();
    return 0;
  }

  void LavBaneIVerden() {
    for (int i=0; i<bred; i++) {
      for (int j=0; j<lang; j++) {
        if (bane[i][j] != null) {
          if (bane[i][j].get(0) == 0) {
            int[] temp = {i, j};
            blok.MakeWall(GridToWorld(temp));
          }
        }
      }
    }
  }

  //Beregner om et punkt p i worldspace kolliderer med en hitbox og returner hitboxens type som int
  int CalcCollision(PVector p, boolean hitboxDebug) {
    int[] gridP = WorldToGrid(p);
    /*pushMatrix();
     resetMatrix();
     stroke(1);
     line(0, 0+80, p.x, p.y+80);
     popMatrix();*/
    PVector[][] hitBoxes;

    try {
      hitBoxes = blok.GetHitboxes(bane[gridP[0]][gridP[1]].get(0), bane[gridP[0]][gridP[1]].get(1));
    }
    catch(ArrayIndexOutOfBoundsException e) {
      println("Could not load hitboxes; probably out of bounds. Time: " + millis());
      return -1;
    }

    //Visualiserer hvilke hitboses der tjekkes over
    if (hitboxDebug) {
      for (int i = 0; i<hitBoxes.length; i++) {
        pushMatrix();
        resetMatrix();
        fill(0, 255, 0);
        translate(kamera[0], kamera[1]+80);
        scale(kamera[2]);
        translate(gridP[0]*gridSize, gridP[1]*gridSize);


        rect(hitBoxes[i][0].x, hitBoxes[i][0].y, hitBoxes[i][1].x, hitBoxes[i][1].y);
        popMatrix();
      }
    }

    //Tjekker for hver hitbox i en blok
    for (int i = 0; i<hitBoxes.length; i++) {
      //Tjekker om p er inden for x boundet af kassen
      if (gridP[0]*gridSize+hitBoxes[i][0].x < p.x
        && gridP[0]*gridSize+hitBoxes[i][0].x+hitBoxes[i][1].x >= p.x) {

        //Tjekker om p er inden for y boundet af kassen
        if (gridP[1]*gridSize+hitBoxes[i][0].y < p.y
          && gridP[1]*gridSize+hitBoxes[i][0].y+hitBoxes[i][1].y >= p.y) {
          return blok.GetType(bane[gridP[0]][gridP[1]].get(0));
        }
      }
    }
    return -1;
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

  float[] getKamera() {
    return kamera;
  }

  void LoadBane(IntList[][] b) {
    bred = b[0][0].get(0);
    lang = b[0][0].get(1);
    id   = b[0][0].get(2);
    bane = b;
    LavBaneIVerden();
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
  int[] WorldToGrid(PVector p) {
    int[] out = {floor(p.x/gridSize), floor((p.y)/gridSize)};
    return out;
  }

  //Konverterer grid koordinater til world koordinater
  Vec2 GridToWorld(int[] p) {
    return new Vec2((p[0]*gridSize-(width/2))/10f, ((height/2)-p[1]*gridSize)/10f);
  }

  //Til test og debugging
  void LavTestBane() {
    IntList[][] test = new IntList[70][20];
    for (int i = 0; i < 70; i++) {
      for (int j = 0; j < 20; j++) {
        test[i][j] = new IntList();
        if (i == 0 && j == 0) {
          test[0][0].append(70);
          test[0][0].append(20);
          test[0][0].append(-1);
        } else {
          if ((j > 1 && j < 6) && (i > 31 && i < 35)) test[i][j].append(2);
          else if (j==19 || i == 60 || i == 1 || j == 1) test[i][j].append(0);
          else test[i][j].append(1);
          test[i][j].append(0);
        }
      }
    }
    LoadBane(test);
  }

  //Til visning af tileSettet
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

  //For changing all possible kamera attributes
  void setKamera(float[] k) {
    kamera = k;
  }

  //For setting the kamera offset
  void setKamera(Vec2 p) {
    kamera[0] = p.x;
    kamera[1] = p.y;
  }

  //For setting the scale
  void setKamera(float s) {
    kamera[2] = s;
  }
}
