class Bane { //<>// //<>// //<>// //<>// //<>// //<>//
  //grids bredde og højde i pixels
  int gridSize = 40;
  Vec2 startPos = new Vec2(0, 0);

  Blok blok;
  Box2DProcessing box2d;
  FileHandler fileHandler;

  IntList[][] bane, tileSetTest;
  int bred = -1, lang = -1, id = -1;
  float[] kamera = {0, 0, 1, 1920, 1000};

  int blokkeIalt;
  boolean o = false, editorMode = false;

  Bane(Box2DProcessing b, FileHandler fileHandler, boolean editorMode) {
    this.editorMode = editorMode;
    box2d = b;
    this.fileHandler = fileHandler;

    bane = new IntList[1][1];
    bane[0][0] = new IntList();
    bane[0][0].append(-1);

    blok = new Blok(gridSize, box2d);
    blokkeIalt = blok.blokkeIalt;

    LavTileTestBane();
    LavTestBaneTo();

    if (editorMode) {
      kamera[0] = 80;
      kamera[1] = 80;
    }
  }

  void Update() {
    //kamera[2] -= 0.001;
    if (!editorMode) {
      kamera[0] = 0;
      kamera[1] = 0;
    }

    blok.Update();
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
    int[] t = {0, 0};
    blok.MakeWall(GridToWorld(t));
    for (int i=0; i<bred; i++) {
      for (int j=0; j<lang; j++) {
        if (bane[i][j] != null) {
          if (bane[i][j].get(0) == 0) {
            int[] temp = {i, j};
            blok.MakeWall(GridToWorld(temp));
          } else if (bane[i][j].get(0) == 4) {
            String g = i+","+j;
            int[] temp = {i, j};
            blok.MakeKasse(g, GridToWorld(temp));
          } else if (bane[i][j].get(0) == 5 ||bane[i][j].get(0) == 6) {
            String g = i+","+j;
            int[] temp = {i, j};
            blok.MakeSav(g, GridToWorld(temp), bane[i][j].get(0));
          } else if (bane[i][j].get(0) == 7) {
            String g = i+","+j;
            int[] temp = {i, j};
            blok.MakeKnap(g, GridToWorld(temp), bane[i][j].get(2));
          } else if (bane[i][j].get(0) == 8) {
            String g = i+","+j;
            int[] temp = {i, j};
            blok.MakeDoor(g, GridToWorld(temp), bane[i][j].get(2));
          }
        }
      }
    }

    //Link knapper og døre
    for (String x : blok.knapper.keySet()) {
      for (String y : blok.doors.keySet()) {
        if (blok.doors.get(y).id == blok.knapper.get(x).id) { 
          //blok.doors.get(y).knap = blok.knapper.get(x);
          blok.knapper.get(x).doors.add(blok.doors.get(y));
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
      if (gridP[0] == 0 && gridP[1] == 0) {
        hitBoxes = blok.GetHitboxes(0, 0);
        o = true; //Det er 0,0 der er subject
      } else {
        hitBoxes = blok.GetHitboxes(bane[gridP[0]][gridP[1]].get(0), bane[gridP[0]][gridP[1]].get(1));
      }
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
          if (o) { 
            o = false;
            return blok.GetType(0);
          } else return blok.GetType(bane[gridP[0]][gridP[1]].get(0));
        }
      }
    }
    return -1;
  }

  void DrawBane(boolean tileTest, boolean hitboxDebug) {
    String g;
    if (!tileTest) { //Banen tegnes
      for (int i=0; i<bred; i++) {
        for (int j=0; j<lang; j++) {
          if (bane[i][j] != null) {
            g = i+","+j;
            pushMatrix();
            //flytter hen til hvor vi skal tegne på griddet
            translate((gridSize*i), (gridSize*j));

            if (i == 0 && j == 0) blok.DrawBlok(0, hitboxDebug, g, kamera, false, editorMode);
            //kalder en funktion der vælger hvilken metode der skal bruges alt efter hvilken blok skal tegnes
            else blok.DrawBlok(bane[i][j].get(0), hitboxDebug, g, kamera, false, editorMode);
            popMatrix();
          }
        }
      }
      //Special pass
      for (int i=0; i<bred; i++) {
        for (int j=0; j<lang; j++) {
          if (bane[i][j] != null) {
            if (bane[i][j].get(0) == 4 || bane[i][j].get(0) == 5 || bane[i][j].get(0) == 6) {
              g = i+","+j;
              pushMatrix();
              translate((gridSize*i), (gridSize*j));
              blok.DrawBlok(bane[i][j].get(0), hitboxDebug, g, kamera, true, editorMode);
              popMatrix();
            }
          }
        }
      }
    } else { //Displayer tileSettet
      for (int i=0; i<tileSetTest[0][0].get(0); i++) {
        for (int j=0; j<tileSetTest[0][0].get(1); j++) {
          g = i+","+j;
          pushMatrix();
          //flytter hen til hvor vi skal tegne på griddet
          translate((gridSize*i), (gridSize*j));

          //tilføjer et lille mellemrum hvis vi debugger så man kan skelne mellem blokkene
          translate(2*i, 2*j);

          //kalder en funktion der vælger hvilken metode der skal bruges alt efter hvilken blok skal tegnes
          blok.DrawBlok(tileSetTest[i][j].get(0), hitboxDebug, g, kamera, false, editorMode);
          popMatrix();
        }
      }
    }
    if (editorMode) {
      stroke(255, 50, 50);
      strokeWeight(2);
      line(0, 0, bred*40, 0);
      line(0, 0, 0, lang*40);
      line(bred*40, 0, bred*40, lang*40);
      line(0, lang*40, bred*40, lang*40);
    }
  }

  float[] getKamera() {
    return kamera;
  }

  void LoadBane(IntList[][] b) {
    UnLoadBane();

    bred = b[0][0].get(0);
    lang = b[0][0].get(1);
    id   = b[0][0].get(2);
    bane = b;
    LavBaneIVerden();

    for (int i = 0; i < bred; i++) {
      for (int j = 0; j < lang; j++) {
        if (b[i][j].get(0) == 3) {
          int[] t = new int[2];
          t[0] = i;
          t[1] = j;
          startPos = GridToWorld(t);
          startPos.addLocal(new Vec2(2, -1));
          return;
        }
      }
    }
  }

  void UnLoadBane() {
    blok.DestroyStuff();
  }

  void ReloadBane() {
    LoadBane(bane);
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
    //Til test af file handler
    //fileHandler.MakeLevelFile(test);
    LoadBane(test);
  }

  //Et kinda ordentligt level
  void LavTestBaneTo() {
    IntList[][] test = new IntList[35][18];
    for (int i = 0; i < 35; i++) {
      for (int j = 0; j < 18; j++) {
        test[i][j] = new IntList();
        if (i == 0 && j == 0) {
          test[0][0].append(35);
          test[0][0].append(18);
          test[0][0].append(0);
        } else {
          if (j > 12 && i > 15) test[i][j].append(-1); //Empty
          else if (j > 6 && i > 24) test[i][j].append(-1); //Empty
          else if (j == 5 && i == 7) test[i][j].append(3); //Start
          //else if (j == 10 && i == 8) test[i][j].append(6); //Sav
          //else if (j == 8 && i == 16) test[i][j].append(5); //Sav
          else if (j == 9 && i == 15) test[i][j].append(4); //Kasse
          //else if (j == 16 && i > 0 && i < 10) test[i][j].append(7); //Knap
          else if (j == 16 && i == 8) test[i][j].append(7); //Knap
          else if ((j > 0 && j < 6) && (i == 28)) test[i][j].append(8); //Døre
          else if ((j > 0 && j < 6) && (i > 30 && i < 34)) test[i][j].append(2); //Mål
          else if (j == 17 || i == 34 || i == 0 || j == 0) test[i][j].append(0); //Wall
          else if (((j == 6 || j == 7) && i < 12 && i > 4) || ((i == 10 || i == 11) && j < 7)) test[i][j].append(0); //Wall
          else if (j == 6 && i > 23) test[i][j].append(0); //wall
          else if (j > 6 && i == 24) test[i][j].append(0); //wall
          else if (j == 12 && i > 15) test[i][j].append(0); //wall
          else if (j > 11 && i == 15) test[i][j].append(0); //wall

          else test[i][j].append(1); //Luft hvor der ikke er sat en blok endnu

          test[i][j].append(0); //Rotation of 0

          if (((j > 0 && j < 6) && (i == 28)) || (j == 16 && i == 8)) test[i][j].append(1);
        }
      }
    }
    //fileHandler.MakeLevelFile(test);
    LoadBane(test);
  }

  Vec2 getStartPos() {
    return startPos;
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

  void ResetKamera() {
    float[] t = {80, 80, 1, 1920, 1000};
    kamera = t;
  }

  void MakeEmpty() {
    IntList[][] empty = new IntList[1][1];
    empty[0][0] = new IntList();
    empty[0][0].append(1);
    empty[0][0].append(1);
    empty[0][0].append(-1);
    LoadBane(empty);
  }

  void EditCanvas(int ekstra, int rot) {
    int t;
    //if (ekstra == 0) t = -1;
    //else
    t = ekstra;

    if (rot == 0 || rot == 2) lang += t;
    else bred += t;

    if (bred < 1 || lang < 1) {
      bred = 1; 
      lang = 1; 
      return;
    }

    IntList[][] out = new IntList[bred][lang];

    for (int i = 0; i < bred; i++) {
      for (int j = 0; j < lang; j++) {
        out[i][j] = new IntList();
        if (i == 0 && j == 0) {
          out[0][0].append(bred);
          out[0][0].append(lang);
          out[0][0].append(-1);
        } else {
          if (rot == 0) {
            if (ekstra == 1 && j == 0) {
              out[i][j].append(-1);
              out[i][j].append(0);
            } else {
              if (ekstra == 1 && j == 1 && i == 0) {              
                out[i][j].append(0);
                out[i][j].append(0);
              } else {
                out[i][j].append(bane[i][j-ekstra].get(0));
                out[i][j].append(bane[i][j-ekstra].get(1));
                if (bane[i][j-ekstra].get(0) == 7 || bane[i][j-ekstra].get(0) == 8) {
                  out[i][j].append(bane[i][j-ekstra].get(2));
                }
              }
            }
          } else if (rot == 1) {
            if (ekstra == 1 && i == bred-1) {
              out[i][j].append(-1);
              out[i][j].append(0);
            } else {
              out[i][j].append(bane[i][j].get(0));
              out[i][j].append(bane[i][j].get(1));
              if (bane[i][j].get(0) == 7 || bane[i][j].get(0) == 8) {
                out[i][j].append(bane[i][j].get(2));
              }
            }
          } else if (rot == 2) {
            if (ekstra == 1 && j == lang-1) {
              out[i][j].append(-1);
              out[i][j].append(0);
            } else {
              out[i][j].append(bane[i][j].get(0));
              out[i][j].append(bane[i][j].get(1));
              if (bane[i][j].get(0) == 7 || bane[i][j].get(0) == 8) {
                out[i][j].append(bane[i][j].get(2));
              }
            }
          } else {
            if (ekstra == 1 && i == 0) {
              out[i][j].append(-1);
              out[i][j].append(0);
            } else {
              if (ekstra == 1 && j == 0 && i == 1) {              
                out[i][j].append(0);
                out[i][j].append(0);
              } else {
                out[i][j].append(bane[i-ekstra][j].get(0));
                out[i][j].append(bane[i-ekstra][j].get(1));
                if (bane[i-ekstra][j].get(0) == 7 || bane[i-ekstra][j].get(0) == 8) {
                  out[i][j].append(bane[i-ekstra][j].get(2));
                }
              }
            }
          }
        }
      }
    }
    LoadBane(out);
  }
}
