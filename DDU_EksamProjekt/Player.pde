class Player {

  PVector[] hitPoints;

  PVector pos;
  PVector vel = new PVector(0, 0);
  PVector gravity = new PVector(0, 0.01);
  float rot = 0.1;
  Bane bane;

  float startDrej = PI / 4;
  int drejIterationer = 4;

  Player(PVector p, Bane b) {
    pos = p;
    bane = b;

    hitPoints = GetHP();
  }

  void Update(boolean hitboxDebug) {
    vel.add(gravity);
    pos.add(vel);
    HandleColissions(hitboxDebug);
    rot = rot + 0.01;
  }

  void Draw(boolean hitboxDebug) {
    DrawPlayer(hitboxDebug);
    if (hitboxDebug)line(0, 0, pos.x, pos.y);
  }

  void HandleColissions(boolean hitboxDebug) {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rot);
    float drej;
    for (int i = 0; i < hitPoints.length; i++) {
      if (bane.CalcCollision(LocalToWorld(hitPoints[i], pos, rot), hitboxDebug) == 1) {
        int retning = BestemIntersectGrid(LocalToWorld(hitPoints[i], pos, rot));
        //iterativt
        for (int j = 1; j < drejIterationer+1; j++) {
          drej = startDrej/(j^2);
          println(drej);
          if (bane.CalcCollision(LocalToWorld(hitPoints[i], pos, rot), hitboxDebug) == 1) drej = drej * (-1);
          if (retning == 0 || retning == 1) rot += drej;
          else rot -= drej;
        }
      }
    }
    popMatrix();
  }

  void DrawPlayer(boolean hitboxDebug) {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rot);
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
