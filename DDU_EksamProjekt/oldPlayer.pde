class oldPlayer {
  PVector[] hitPoints;
  Bane bane;


  PVector posP, posH, vel = new PVector(0, 0), acc = new PVector(0, 0), rotationSpeed = new PVector(0, 0), rotationForce, 
    gravity = new PVector(0, 0.02);

  float playerX, playerY, hookX, hookY, 
    theta = PI/2, aVel=0, aAcc=0, hookInVel=0, hookInAcc=0, 
    length=30, damping=0.99, speed=3, swingSpeed=10;

  boolean aroundPlayer = true, 
    collision = true; //Skal fjernes når kollision implementeres, og blive true når hooken rammer en væg/whatever

  oldPlayer(PVector p, Bane b) {
    hitPoints = GetHP();
    bane = b;

    //P = player (karakteren)
    posP = p;  
    //H = hooken
    posH = new PVector(posP.x+length, posP.y);
  }


  void Update(boolean h, boolean left, boolean right, boolean space) {
    if (length < 30) length = 30;

    //Controls, drejer på graplling hooken
    if (left && !space && length == 30) theta+= 0.03;
    if (right && !space && length == 30) theta-= 0.03;

    if (theta < PI/3) theta = PI/3;
    if (theta > 5*PI/3) theta = 5*PI/3;

    //Graplling hooken extendes
    if (space && aroundPlayer) length += speed + mag(vel.x, vel.y);

    //Hvis den kolliderer med et soldit objekt
    else if (length > 30 && collision) {
      if (aroundPlayer) {
        //Koordinaterne for spilleren og hookens position i det moment spilleren skal begynde at svinge sig gemmes
        playerX = posP.x;
        playerY = posP.y;
        hookX = posH.x;
        hookY = posH.y;
        aAcc = 0;
        aVel = 0;
      }
      aroundPlayer = false;
      acc.setMag(0);
      vel.setMag(0);

      //Når spilleren er trukket op til grappling hooken igen
    } else if (length == 30) {
      aroundPlayer = true;
      hookInVel = 0;

      //Hvis graplling hooken ikke kollidere, og trækkes tilbage
    } else if (!collision) length -= speed;

    //Tilføjer den lille rotationshastighed der stadig kan være når hooken har trukket sig sammen igen til accelerationen
    rotationForce = new PVector(rotationSpeed.x, rotationSpeed.y);
    if (mag(rotationForce.x, rotationForce.y) < 0) rotationForce.setMag(0);
    posP.add(rotationForce);
    rotationForce.setMag(mag(rotationForce.x, rotationForce.y) - 0.5);

    //Tilføjer kræfterne til accelerationen
    acc.add(gravity);
    vel.add(acc);
    posP.add(vel);
    acc.setMag(0);

    //Når hooken er hos spilleren
    if (aroundPlayer) DrawPlayerHook();
    //Når spilleren skal svinges om hooken
    else {

      //Vinkelacceleration og vinkelhastighed beregnes
      aAcc = (-0.5 * mag(gravity.x, gravity.y)*swingSpeed/length)*sin(theta);
      aVel += aAcc;
      theta -= aVel;
      aVel *= damping;

      //Spilleren trækkes op til hooken. Hvis de trykker space kan denne optrækken pauses. 
      if (!space) {
        hookInAcc += 0.02;
        hookInVel += hookInAcc;
        length -=hookInVel;
        hookInAcc = 0;
      } else hookInVel = 0;
    }
    
    Draw(h);
    DrawPlayer(h);
    
  }

  void Draw(boolean hitboxDebug) {
    if (hitboxDebug)line(0, 0, posP.x, posP.y);
  }


  void DrawPlayerHook() {
    //Koordinatesystemets origo sættes i karakteren
    pushMatrix();
    translate(posP.x, posP.y);
    rectMode(CENTER);
    fill(50, 200, 50);
    rect(0, 0, 30, 50, 15, 15, 0, 0);
    posH = new PVector(length*sin(theta), length*cos(theta));
    line(0, 0, posH.x, posH.y);
    circle(posH.x, posH.y, 8);
    popMatrix();
  }


  void DrawHookPlayer() {
    //Koordinatsystemets origo sættes i hookens endepunkt
    pushMatrix();
    translate(hookX+playerX, hookY+playerY);
    posH.set(-length*sin(theta), -length*cos(theta), 0);
    //Positionen af karakteren der afhænger af spilleren og hookens position ved udsendelse samt hooken der roterer spilleren
    posP.set(posH.x+playerX+hookX, posH.y+playerY+hookY);
    rotationSpeed = new PVector(sin(theta)*speed/2, 0);

    rectMode(CENTER);
    fill(50, 200, 50);
    rect(posH.x, posH.y, 30, 50, 15, 15, 0, 0);
    line(posH.x, posH.y, 0, 0); 
    circle(0, 0, 8);
    popMatrix();
  }

  //Gammel kode fra player klassen frederik skrev
  //=======================================================
  void DrawPlayer(boolean hitboxDebug) {
    pushMatrix();
    translate(posP.x, posP.y);
    rotate(theta-PI);

    if (hitboxDebug) {
      fill(255, 100, 100);
      noStroke();
      square(-20, -10, 40);
      triangle(-20, -10, 0, -30, 20, -10);
      strokeWeight(5);
      stroke(0);
      for (int i = 0; i < hitPoints.length; i++) {
        point(hitPoints[i].x, hitPoints[i].y);
      }
      strokeWeight(1);
    } else {
      strokeWeight(1);
      fill(255, 150, 200);
      circle(0, -10, 40);
      noStroke();
      square(-20, -10, 40);
      stroke(1);
      line(-20, -10, -20, 30);
      line(20, -10, 20, 30);
      line(-20, 30, 20, 30);
    }
    popMatrix();
  }

  PVector LocalToWorld(PVector p, PVector origin, float turn) {
    PVector out = new PVector(p.x, p.y);
    out.rotate(turn);
    out.add(origin);
    return out;
  }

  PVector[] GetHP() {
    PVector[] t = new PVector[7];
    t[0] = new PVector(0, -30);
    t[1] = new PVector(-20, -10);
    t[2] = new PVector(20, 10);
    t[3] = new PVector(-20, 10);
    t[4] = new PVector(20, -10);
    t[5] = new PVector(-20, 30);
    t[6] = new PVector(20, 30);
    return t;
  }

  int BestemIntersectGrid(PVector p) {
    int gridSize = 40;
    PVector t = new PVector(p.x % gridSize, p.y % gridSize);
    float a = tan(p.heading()-HALF_PI);
    if (t.x > 20) {
      if (t.y > 20) {
        if (t.x > t.y * a) return 1;
        else return 2;
      } else {
        if (t.y > (40 - t.x) * a) return 1;
        else return 0;
      }
    } else {
      if (t.y > 20) {
        if (t.x > (40 - t.y) * a) return 2;
        else return 3;
      } else {
        if (t.x > t.y * a) return 0;
        else return 3;
      }
    }
  }
}
