class Player {

  PVector pos;
  PVector vel = new PVector(0, 0);
  PVector gravity = new PVector(0, 0.1);
  float rot = 0;
  Bane bane;

  Player(PVector p, Bane b) {
    pos = p;
    bane = b;
  }

  void Update(boolean hitboxDebug) {
    //vel.add(gravity);
    pos.add(vel);
    HandleColissions(hitboxDebug);
  }

  void Draw(boolean hitboxDebug) {
    DrawPlayer(hitboxDebug);
    if (hitboxDebug)line(0, 0, pos.x, pos.y);
  }

  void HandleColissions(boolean hitboxDebug) {
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
      point(0, -30);
      point(-20, -10);
      point(20, -10);
      point(-20, 30);
      point(20, 30);
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
}
