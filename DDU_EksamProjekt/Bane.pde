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
    this.editorMode = editorMode; //Editormode er true hvis bane klassen er instantieret gennem level editoren
    box2d = b;
    this.fileHandler = fileHandler;

    bane = new IntList[1][1];
    bane[0][0] = new IntList();
    bane[0][0].append(-1);

    blok = new Blok(gridSize, box2d);
    blokkeIalt = blok.blokkeIalt;

    LavTileTestBane();
    LavTestBaneTo(); //Laver en default bane som level editoren starter med

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

  int Draw(boolean tileTest, boolean hitboxDebug, boolean coolGFX) {
    rectMode(CORNER);
    pushMatrix();
    if (!tileTest) translate(kamera[0], kamera[1]);
    scale(kamera[2]);
    if (bane[0][0].get(0) != -1) DrawBane(tileTest, hitboxDebug, coolGFX); //Banen tegnes
    popMatrix();
    return 0;
  }

  //Denne metode sørger for at de forskellige objekter i banen bliver instantieret
  void LavBaneIVerden() {

    int[] t = {0, 0};
    String gExtra = 0+","+0;
    blok.MakeWall(GridToWorld(t)); //Væg ved 0,0
    for (int i=0; i<bred; i++) {
      for (int j=0; j<lang; j++) {
        if (bane[i][j] != null && !(i == 0 && j == 0)) {
          if (bane[i][j].get(0) == 0) {
            int[] temp = {i, j};
            String g = i+","+j;
            blok.MakeWall(GridToWorld(temp)); //Væg
          } else if (bane[i][j].get(0) == 4) {
            String g = i+","+j;
            int[] temp = {i, j};
            blok.MakeKasse(g, GridToWorld(temp)); //Kasse
          } else if (bane[i][j].get(0) == 5 ||bane[i][j].get(0) == 6) {
            String g = i+","+j;
            int[] temp = {i, j};
            blok.MakeSav(g, GridToWorld(temp), bane[i][j].get(0)); //Sav
          } else if (bane[i][j].get(0) == 7) {
            String g = i+","+j;
            int[] temp = {i, j};
            blok.MakeKnap(g, GridToWorld(temp), bane[i][j].get(2)); //Knap
          } else if (bane[i][j].get(0) == 8) {
            String g = i+","+j;
            int[] temp = {i, j};
            blok.MakeDoor(g, GridToWorld(temp), bane[i][j].get(2)); //Dør
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
  //Calc collision bliver kun brugt til at tjekke om hooken kolliderer med en væg
  int CalcCollision(PVector p, boolean hitboxDebug) {
    int[] gridP = WorldToGrid(p);
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
          String g = gridP[0]+","+gridP[1];
          if (o) { 
            o = false;
            return blok.GetType(0, null);
          } else return blok.GetType(bane[gridP[0]][gridP[1]].get(0), g);
        }
      }
    }
    return -1;
  }

  void DrawBane(boolean tileTest, boolean hitboxDebug, boolean coolGFX) {
    String g;
    if (!tileTest) { //Banen tegnes
      for (int i=0; i<bred; i++) {
        for (int j=0; j<lang; j++) {
          if (bane[i][j] != null) {
            g = i+","+j;
            pushMatrix();
            //flytter hen til hvor vi skal tegne på griddet
            translate((gridSize*i), (gridSize*j));

            if (i == 0 && j == 0) blok.DrawBlok(0, hitboxDebug, g, kamera, false, editorMode, coolGFX);
            //kalder en funktion der vælger hvilken metode der skal bruges alt efter hvilken blok skal tegnes
            else blok.DrawBlok(bane[i][j].get(0), hitboxDebug, g, kamera, false, editorMode, coolGFX);
            popMatrix();
          }
        }
      }
      //Special pass, hvor de større objekter tegnes
      for (int i=0; i<bred; i++) {
        for (int j=0; j<lang; j++) {
          if (bane[i][j] != null) {
            if (bane[i][j].get(0) == 4 || bane[i][j].get(0) == 5 || bane[i][j].get(0) == 6) {
              g = i+","+j;
              if (i != 0 && j != 0) {
                pushMatrix();
                translate((gridSize*i), (gridSize*j));
                blok.DrawBlok(bane[i][j].get(0), hitboxDebug, g, kamera, true, editorMode, coolGFX);
                popMatrix();
              }
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
          blok.DrawBlok(tileSetTest[i][j].get(0), hitboxDebug, g, kamera, false, editorMode, coolGFX);
          popMatrix();
        }
      }
    }
    if (editorMode) { //Tegner en rød outline ome banen
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

  //Sørger for at loade alle de relevante dele af en bane samt destruere de gamle elementer
  void LoadBane(IntList[][] b) {
    UnLoadBane();

    bred = b[0][0].get(0);
    lang = b[0][0].get(1);
    id   = b[0][0].get(2);
    bane = b;
    LavBaneIVerden(); //Laver de forskellige objekter

    //Bruges til at bestemme hvor spilleren skal starte
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

  //Laver et ordentligt level med fint design og nogle forskellige elementer
  //Blev brugt meget før level editoren blev færdiggjort, bruges dog stadig
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

  //Bruges til at resette kameraet i level editoren
  void ResetKamera() {
    float[] t = {80, 80, 1, 1920, 1000};
    kamera = t;
  }

  //Laver en 1x1 tom bane
  void MakeEmpty() {
    IntList[][] empty = new IntList[1][1];
    empty[0][0] = new IntList();
    empty[0][0].append(1);
    empty[0][0].append(1);
    empty[0][0].append(-1);
    LoadBane(empty);
  }

  //Laver en 15x15 tom bane
  void MakeNew() {
    int emptySize = 15;
    IntList[][] out = new IntList[emptySize][emptySize];
    for (int i = 0; i < emptySize; i++) {
      for (int j = 0; j < emptySize; j++) {
        out[i][j] = new IntList();
        if (i == 0 && j == 0) {
          out[0][0].append(emptySize);
          out[0][0].append(emptySize);
          out[0][0].append(-1);
        } else {
          out[i][j].append(-1);
          out[i][j].append(0);
        }
      }
    }
    LoadBane(out);
  }

  //Bruges til at ændre en blok i banen
  void EditBlok(int id, int rot, int extra, int[] pos) {
    if (pos[0] == 0 && pos[1] == 0) return;

    bane[int(pos[0])][int(pos[1])] = new IntList();
    bane[int(pos[0])][int(pos[1])].append(id);
    bane[int(pos[0])][int(pos[1])].append(rot);
    if (id == 7 || id == 8) {
      bane[int(pos[0])][int(pos[1])].append(extra);
    }
    LoadBane(bane);
  }

  //Ændrer størrelsen af banen
  void EditCanvas(int ekstra, int rot) {
    int t = ekstra;
    if (rot == 0 || rot == 2) lang += t;
    else bred += t;

    if (bred < 1 || lang < 1) { //Er banen allerede den mindste størrelse
      bred = 1; 
      lang = 1; 
      return;
    }

    IntList[][] out = new IntList[bred][lang];

    //Læser informationen fra blokken til nedenunder, til venstre, ovenover eller til højre alt efter hvilken retning der laves/fjernes en række
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
            } //else if (j == 0) RemoveStuff(i, j); 
            else {
              if (ekstra == 1 && j == 1 && i == 0) {              
                out[i][j].append(-1);
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
                out[i][j].append(-1);
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
