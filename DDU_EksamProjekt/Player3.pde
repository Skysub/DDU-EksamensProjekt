class Player3 {

  PVector posP, posH, vel, acc, hook, gravity;
  float theta;
  int length, speed;
  boolean grap;

  Player3() {
    length = 30;
    speed = 3;

    posH = new PVector(500, 200);    
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    gravity = new PVector(0, 0.001);
  }

  void Run(boolean l, boolean r, boolean s) {
    Update(l, r, s);
    Draw();
  }

  void Update(boolean left, boolean right, boolean space) {
    posP = new PVector(posH.x - length*cos(theta), posH.y-length*sin(theta));


    if (left && !space && length == 30) theta-= 0.03;
    if (right && !space && length == 30) theta+= 0.03;


    //acc.add(gravity);
    vel.add(acc);
    posP.add(vel);
    acc.mult(0);
  }

  void Draw() {

    pushMatrix();
    translate(posP.x, posP.y);
    rectMode(CENTER);
    fill(50, 200, 50);
    rect(0, 0, 30, 50, 15, 15, 0, 0);

    //rotate(theta);
    pushMatrix();
    translate(length*cos(theta), length*sin(theta));
    rectMode(CENTER);
    fill(50, 200, 50);
    triangle(0, -10, 15, 0, 0, 10);
    popMatrix();
    
    popMatrix();


    line(posP.x, posP.y, posH.x, posH.y);
  }
}
