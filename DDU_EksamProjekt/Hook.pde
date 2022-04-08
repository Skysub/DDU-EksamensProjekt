class Hook {

  Vec2 pos, vel = new Vec2(0, 0);
  Box2DProcessing box2d;
  float distanceSit = 3, theta = 0, thetaR = 0, size = 10, aimSpeed = 0.04;
  boolean afsted = false;
  PVector t1 = new PVector(-0.5, -0.5), t2 = new PVector(-0.5, 0.5), t3 = new PVector(0.5, 0);
  float time = 0;

  Hook(Box2DProcessing box2d, Vec2 startPos) {
    pos = startPos;
    this.box2d = box2d;
    MakeTriangleForm();
  }

  void Update(boolean left, boolean right, Vec2 playerPos, float rotation, boolean space) {
    float thetaTrue = theta + rotation;
    if (afsted)pos.add(vel);
    else pos = new Vec2(playerPos.x+width/20+(sin(-rotation))+(distanceSit*cos(thetaTrue)), playerPos.y-height/20+(cos(-rotation))+(distanceSit*sin(thetaTrue)));
    //afsted = true; //testing ting

    if (space) { 
      afsted = true;
      time = millis();
    }
    if (time < millis()-5000) afsted = false;

    //Controls, drejer på graplling hooken
    if (left) thetaR+= aimSpeed;
    if (right) thetaR-= aimSpeed;
    //Clamping
    if (thetaR < -PI*0.15) thetaR = -PI*0.15;
    if (thetaR > 1.15*PI) thetaR = 1.15*PI;

    //Hooken ændrer stadig retning selvom den regentlige retning er "låst" når den er afsted.
    //Så hooken ikke drejer når den er skudt
    if (!afsted) theta = thetaR;
  }

  void Draw(boolean hitboxDebug, Vec2 playerPos, float rotation) {
    float thetaTrue = theta + rotation;
    if (afsted) thetaTrue = theta;

    Vec2 sted = new Vec2(playerPos.x+width/20+(sin(-rotation))+(distanceSit*cos(thetaTrue)), playerPos.y-height/20+(cos(-rotation))+(distanceSit*sin(thetaTrue)));
    Vec2 pSted = new Vec2(playerPos.x+width/20+(sin(-rotation)), playerPos.y-height/20+(cos(-rotation))-8);
    fill(255, 100, 100);
    if (hitboxDebug) {
      pushMatrix();
      resetMatrix();
      fill(100, 100, 255);
      stroke(1);
      line(0, 80, box2d.vectorWorldToPixels(sted).x, box2d.vectorWorldToPixels(sted).y+80);
      noStroke();
      popMatrix();
    }
    if (!hitboxDebug) {
      //Tegner snoren mellem player og hook
      pushMatrix();
      resetMatrix();
      stroke(140, 110, 45);
      strokeWeight(3);
      if (!afsted) line(box2d.vectorWorldToPixels(pSted).x, box2d.vectorWorldToPixels(pSted).y, box2d.vectorWorldToPixels(sted).x, box2d.vectorWorldToPixels(sted).y+80);
      else line(box2d.vectorWorldToPixels(pSted).x, box2d.vectorWorldToPixels(pSted).y, box2d.vectorWorldToPixels(pos).x, box2d.vectorWorldToPixels(pos).y+80);
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
    rotate(-thetaTrue);
    rectMode(CENTER);
    //circle(0, 0, ballSize);
    //square(0,0,ballSize);
    triangle(t1.x, t1.y, t2.x, t2.y, t3.x, t3.y);
    rectMode(CORNER);
    popMatrix();
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
