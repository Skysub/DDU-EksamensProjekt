class Hook {

  Vec2 pos, vel = new Vec2(0, 0);
  Box2DProcessing box2d;
  float distanceSit = 3, theta = 0, size = 10, aimSpeed = 0.04;
  boolean afsted = false;
  PVector t1 = new PVector(-0.5, -0.5), t2 = new PVector(-0.5, 0.5), t3 = new PVector(0.5, 0);

  Hook(Box2DProcessing box2d, Vec2 startPos) {
    pos = startPos;
    this.box2d = box2d;
    MakeTriangleForm();
  }

  void Update(boolean left, boolean right) {
    if (afsted)pos.add(vel);

    //Controls, drejer på graplling hooken
    if (!afsted) {
      if (left) theta+= aimSpeed;
      if (right) theta-= aimSpeed;
    }

    //Clamping
    if (theta < -PI*0.15) theta = -PI*0.15;
    if (theta > 1.15*PI) theta = 1.15*PI;
    //println(theta);
  }

  void Draw(boolean hitboxDebug, Vec2 playerPos, float rotation) {
    Vec2 sted = new Vec2(playerPos.x+width/20+(sin(rotation))+(distanceSit*cos(theta)), playerPos.y-height/20+(cos(rotation))+(distanceSit*sin(theta)));
    fill(255, 100, 100);
    if (hitboxDebug) {
      pushMatrix();
      resetMatrix();
      noStroke();
      fill(100, 100, 255);
      line(0, 80, box2d.vectorWorldToPixels(sted).x, box2d.vectorWorldToPixels(sted).y+80);
      popMatrix();
    }
    pushMatrix();
    if (afsted) {
      resetMatrix();
      translate(box2d.vectorWorldToPixels(pos).x, box2d.vectorWorldToPixels(pos).y+80);
    } else {
      translate(box2d.vectorWorldToPixels(sted).x, box2d.vectorWorldToPixels(sted).y);
    }
    //noStroke();
    rotate(-theta);
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
