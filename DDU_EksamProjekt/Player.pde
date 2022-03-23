class Player {

  PVector pos;
  PVector vel = new PVector(0, 0);
  PVector gravity = new PVector(0, 0.1);

  Player(PVector p) {
    pos = p;
  }

  void Update() {
    vel.add(gravity);
    pos.add(vel);
    CheckColissions();
  }

  void Draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(100);
    noStroke();
    circle(0, 0, 40);
    square(-20, 0, 40);
    popMatrix();
  }

  void CheckColissions() {
  }
}
