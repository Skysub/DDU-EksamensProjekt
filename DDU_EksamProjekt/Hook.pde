class Hook {
  Vec2 pos, vel = new Vec2(0, 0);
  Box2DProcessing box2d;

  //Hvor langt hooken er fra spilleren når den sidder, hookens vinkel, en gemt vinkel af hooken 
  float distanceSit = 3, theta = 0, thetaR = 0, thetaT = 0;

  //størrelsen af hooken visuelt, hvor hurtigt man drejer med hooken, hookens hastighed i luften, kraften hooken trækker spilleren med, hvor tæt på spilleren skal være for at hooken bliver reset
  float size = 10, aimSpeed = 0.04, hookSpeed = 35, hookStrength = 15, doneLength = 6;

  boolean afsted = false, hit = false; //Afsted er når hooken er skudt afsted, hit er når hooken sidder i en væg

  PVector t1 = new PVector(-0.5, -0.5), t2 = new PVector(-0.5, 0.5), t3 = new PVector(1, 0); //Koordinater til de tre punkter af hookens trekantede form
  Bane bane;

  RcCallback rcCallback;
  Vec2 crosshairPos = new Vec2(0, 0);
  float search = 1000; //How far the game looks for a wall the crosshair could point to

  Hook(Box2DProcessing box2d, Vec2 startPos, Bane bane) {
    pos = startPos;
    this.box2d = box2d;
    MakeTriangleForm(); //Sætter størrelsen af hooken
    this.bane = bane;

    rcCallback = new RcCallback(this);
  }

  Vec2 Update(boolean left, boolean right, Vec2 playerPos, float rotation, boolean space, boolean hitboxDebug) {
    float thetaTrue = theta + rotation; //Tager hensyn til hookens og spillerens rotation

    //Sted er hvor hooken er, pSted er hvor hooken sidder fast på playeren (1 over spillerens centrum i worldspace)
    Vec2 sted = new Vec2(playerPos.x+width/20+(sin(-rotation))+(distanceSit*cos(thetaTrue)), playerPos.y-height/20+(cos(-rotation))+(distanceSit*sin(thetaTrue)));
    Vec2 pSted = new Vec2(playerPos.x+width/20+(sin(-rotation)), playerPos.y-height/20+(cos(-rotation)));

    //Opdaterer hookens lokation
    if (afsted && !hit) pos.addLocal(vel);
    else if (!afsted) pos = sted; //afsted = true; //testing ting

    if (space) SpaceGotClicked(sted, pSted, rotation); //Giver lidt sig selv
    if (afsted && !hit) hit = CheckCollisions(hitboxDebug); //Tjekker om hooken har ramt en væg

    HandleControls(left, right);

    //Hooken ændrer stadig retning selvom den regentlige retning er "låst" når den er afsted.
    //Så hooken ikke drejer når den er skudt
    if (!afsted) theta = thetaR;

    if (hit) { //Er hooken i en væg
      //Laver en vektor fra spilleren til hooken
      Vec2 t = pos.sub(new Vec2(playerPos.x+96, playerPos.y-54));
      if (t.length() < doneLength) { //Hvis spilleren er tæt nok på hooken bliver hooken reset
        hit = false;
        afsted = false;
      }
      t.normalize();
      t = new Vec2(t.x * hookStrength*100, t.y * hookStrength*100); //For at kontrollere hvor stærkt hooken trækker
      return t;
    }
    return new Vec2(0, 0);
  }

  void Draw(boolean hitboxDebug, Vec2 playerPos, float rotation, float[] kamera) {
    float thetaTrue = theta + rotation; //Tager hensyn til hookens og spillerens rotation
    if (afsted) thetaTrue = thetaT; //bruger den gemte vinkel

    Vec2 sted = new Vec2(playerPos.x+width/20+(sin(-rotation))+(distanceSit*cos(thetaTrue)), playerPos.y-height/20+(cos(-rotation))+(distanceSit*sin(thetaTrue))); //Er forklaret under update
    Vec2 pSted = new Vec2(playerPos.x+width/20+(sin(-rotation)), playerPos.y-height/20+(cos(-rotation)));

    fill(255, 100, 100);
    pushMatrix();
    resetMatrix();
    translate(kamera[0], kamera[1]+80);
    scale(kamera[2]);
    if (hitboxDebug) {
      //Tegner en linje til hookens position
      fill(100, 100, 255);
      stroke(1);
      line(0, 0, box2d.vectorWorldToPixels(pos).x, box2d.vectorWorldToPixels(pos).y);
      noStroke();
    }
    if (!hitboxDebug) {
      //Tegner snoren mellem player og hook
      stroke(140, 110, 45); //Farven af snoren mellem hook og spiller
      strokeWeight(3);
      if (!afsted) line(box2d.vectorWorldToPixels(pSted).x, box2d.vectorWorldToPixels(pSted).y, box2d.vectorWorldToPixels(sted).x, box2d.vectorWorldToPixels(sted).y);
      else line(box2d.vectorWorldToPixels(pSted).x, box2d.vectorWorldToPixels(pSted).y, box2d.vectorWorldToPixels(pos).x, box2d.vectorWorldToPixels(pos).y);
      strokeWeight(1);
      noStroke();
    }
    popMatrix();
    pushMatrix();
    //Flytter hooken til det korrekte sted alt efter om den sidder på spilleren
    if (afsted) {
      resetMatrix();
      translate(kamera[0], kamera[1]+80);
      scale(kamera[2]);
      translate(box2d.vectorWorldToPixels(pos).x, box2d.vectorWorldToPixels(pos).y);
    } else {
      translate(box2d.vectorWorldToPixels(sted).x, box2d.vectorWorldToPixels(sted).y);
    }
    if (!hitboxDebug) stroke(0); //Fjerner outline hvis hitboxDebug
    rotate(-thetaTrue);
    rectMode(CENTER);
    triangle(t1.x, t1.y, t2.x, t2.y, t3.x, t3.y); //Tegner hooken
    rectMode(CORNER);
    popMatrix();

    pushMatrix(); //Tegner crosshair
    resetMatrix();
    translate(kamera[0], kamera[1]+80);
    scale(kamera[2]);
    Vec2 searchPoint = new Vec2(playerPos.x+(sin(-rotation))+(search*cos(thetaTrue)), playerPos.y+(cos(-rotation))+(search*sin(thetaTrue)));
    Vec2 start = new Vec2(playerPos.x+(sin(-rotation)), playerPos.y+(cos(-rotation)));
    box2d.world.raycast(rcCallback, start, searchPoint);
    if (hitboxDebug) {
      stroke(1);
        line(box2d.vectorWorldToPixels(sted).x, box2d.vectorWorldToPixels(sted).y, box2d.vectorWorldToPixels(searchPoint).x+width/2, box2d.vectorWorldToPixels(searchPoint).y+height/2);
    }
    noStroke();
    fill(255, 100, 100);
    if (!afsted)circle(box2d.vectorWorldToPixels(crosshairPos).x+width/2, box2d.vectorWorldToPixels(crosshairPos).y+height/2, 12);
    popMatrix();
}

void SpaceGotClicked(Vec2 sted, Vec2 pSted, float rotation) {
  if (afsted) {
    if (hit) {
      //Hvis hooken sidder i en væg og der trykkes mellemrum bliver den reset
      hit = false;
      afsted = false;
    }
  } else {
    //sidder hooken hos spilleren skydes den afsted
    thetaT = theta + rotation; //Gemmer hookens rotation
    afsted = true;

    //Sætter hookens hastighed og i den rigtige retning
    vel = sted.sub(pSted);
    vel.normalize();
    vel = new Vec2(vel.x * 0.1 * hookSpeed, vel.y * 0.1 * hookSpeed);
  }
}

boolean InGoalZone(boolean hitboxDebug) {
  //Bruger CalcCollision til at beregne om hooken kolliderer med en væg.
  //CalcCollision er fra før vi skiftede til at bruge Box2d, det kan ses ved at der stadig bruges PVector her
  //Funktionen virker dog meget fint selvom der lige skal oversættet til det gamle system, det er trods alt mig der har skrevet det :p
  if (bane.CalcCollision(new PVector(pos.x*10, -pos.y*10), hitboxDebug) == 1) return true;
  return false;
}

boolean CheckCollisions(boolean hitboxDebug) {
  //Bruger CalcCollision til at beregne om hooken kolliderer med en væg.
  //CalcCollision er fra før vi skiftede til at bruge Box2d, det kan ses ved at der stadig bruges PVector her
  //Funktionen virker dog meget fint selvom der lige skal oversættet til det gamle system, det er trods alt mig der har skrevet det :p
  if (bane.CalcCollision(new PVector(pos.x*10, -pos.y*10), hitboxDebug) == 1) return true;
  return false;
}

void HandleControls(boolean left, boolean right) { //Controls, drejer på graplling hooken
  if (left) thetaR+= aimSpeed;
  if (right) thetaR-= aimSpeed;
  //Clamping
  if (thetaR < -PI*0.15) thetaR = -PI*0.15;
  if (thetaR > 1.15*PI) thetaR = 1.15*PI;
}

void MakeTriangleForm() { //Skalerer trekanten hooken består af
  t1.mult(size);
  t2.mult(size);
  t3.mult(size);
}

void setSigtePos(Vec2 p) {
  crosshairPos = p;
}
}