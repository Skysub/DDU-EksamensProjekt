class Hook {

  Vec2 pos, vel = new Vec2(0, 0);
  Box2DProcessing box2d;
  float distanceSit = 3, theta = 0, thetaR = 0, thetaT = 0, size = 10, aimSpeed = 0.04, hookSpeed = 35, hookStrength = 15, doneLength = 5;
  boolean afsted = false, hit = false;
  PVector t1 = new PVector(-0.5, -0.5), t2 = new PVector(-0.5, 0.5), t3 = new PVector(1, 0);
  Bane bane;

  Hook(Box2DProcessing box2d, Vec2 startPos, Bane bane) {
    pos = startPos;
    this.box2d = box2d;
    MakeTriangleForm();
    this.bane = bane;
  }

  Vec2 Update(boolean left, boolean right, Vec2 playerPos, float rotation, boolean space, boolean hitboxDebug) {
    float thetaTrue = theta + rotation;
    Vec2 sted = new Vec2(playerPos.x+width/20+(sin(-rotation))+(distanceSit*cos(thetaTrue)), playerPos.y-height/20+(cos(-rotation))+(distanceSit*sin(thetaTrue)));
    Vec2 pSted = new Vec2(playerPos.x+width/20+(sin(-rotation)), playerPos.y-height/20+(cos(-rotation)));

    if (afsted && !hit) pos.addLocal(vel);
    else if (!afsted) pos = sted; //afsted = true; //testing ting

    if (space) SpaceGotClicked(sted, pSted, rotation);
    if (afsted && !hit) hit = CheckCollisions(hitboxDebug);

    HandleControls(left, right);

    //Hooken ændrer stadig retning selvom den regentlige retning er "låst" når den er afsted.
    //Så hooken ikke drejer når den er skudt
    if (!afsted) theta = thetaR;

    if (hit) {
      Vec2 t = pos.sub(new Vec2(playerPos.x+96, playerPos.y-54));
      if (t.length() < doneLength) {
        hit = false;
        afsted = false;
      }
      t.normalize();
      t = new Vec2(t.x * hookStrength*100, t.y * hookStrength*100);
      return t;
    }
    return new Vec2(0, 0);
  }

  void Draw(boolean hitboxDebug, Vec2 playerPos, float rotation) {
    float thetaTrue = theta + rotation;
    if (afsted) thetaTrue = thetaT;

    Vec2 sted = new Vec2(playerPos.x+width/20+(sin(-rotation))+(distanceSit*cos(thetaTrue)), playerPos.y-height/20+(cos(-rotation))+(distanceSit*sin(thetaTrue)));
    Vec2 pSted = new Vec2(playerPos.x+width/20+(sin(-rotation)), playerPos.y-height/20+(cos(-rotation)));
    fill(255, 100, 100);
    if (hitboxDebug) {
      pushMatrix();
      resetMatrix();
      fill(100, 100, 255);
      stroke(1);
      line(0, 80, box2d.vectorWorldToPixels(pos).x, box2d.vectorWorldToPixels(pos).y+80);
      noStroke();
      popMatrix();
    }
    if (!hitboxDebug) {
      //Tegner snoren mellem player og hook
      pushMatrix();
      resetMatrix();
      stroke(140, 110, 45);
      strokeWeight(3);
      if (!afsted) line(box2d.vectorWorldToPixels(pSted).x, box2d.vectorWorldToPixels(pSted).y+80, box2d.vectorWorldToPixels(sted).x, box2d.vectorWorldToPixels(sted).y+80);
      else line(box2d.vectorWorldToPixels(pSted).x, box2d.vectorWorldToPixels(pSted).y+80, box2d.vectorWorldToPixels(pos).x, box2d.vectorWorldToPixels(pos).y+80);
      strokeWeight(1);
      noStroke();
      popMatrix();
    }

    pushMatrix();
    if (afsted) {
      resetMatrix();
      translate(box2d.vectorWorldToPixels(pos).x, box2d.vectorWorldToPixels(pos).y+80);
    } else {
      translate(box2d.vectorWorldToPixels(sted).x, box2d.vectorWorldToPixels(sted).y);
    }
    if (!hitboxDebug) stroke(0);
    ;
    if(!afsted) rotate(-thetaTrue);
    else rotate(-thetaTrue);
    rectMode(CENTER);
    //circle(0, 0, ballSize);
    //square(0,0,ballSize);
    triangle(t1.x, t1.y, t2.x, t2.y, t3.x, t3.y);
    rectMode(CORNER);
    popMatrix();
  }

  void SpaceGotClicked(Vec2 sted, Vec2 pSted, float rotation) {
    if (afsted) {
      if (hit) {
        hit = false;
        afsted = false;
      }
    } else {
      thetaT = theta + rotation;
      afsted = true;
      vel = sted.sub(pSted);
      vel.normalize();
      vel = new Vec2(vel.x * 0.1 * hookSpeed, vel.y * 0.1 * hookSpeed);
    }
  }

  boolean CheckCollisions(boolean hitboxDebug) {
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

  void MakeTriangleForm() {
    t1.mult(size);
    t2.mult(size);
    t3.mult(size);
  }

  void setVel(Vec2 ny) {
    vel = ny;
  }

  void setPos(Vec2 ny) {
    pos = ny;
  }

  Vec2 getPos() {
    return pos;
  }
}
