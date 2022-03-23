class Player {

  PVector posP, posH, vel, acc, gravity;
  float theta;
  int length, speed;
  boolean grap;

  Player() {
    length = 30;
    speed = 3;

    posH = new PVector(500, 200);  
    posP = new PVector(posH.x - length*cos(theta), posH.y-length*sin(theta));
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    gravity = new PVector(0, 0.001);
  }

  void Run(boolean l, boolean r, boolean s) {
    Update(l, r, s);
    Draw();
  }

  void Update(boolean left, boolean right, boolean space) {
    
    
    if (left && !space && length == 30) theta-= 0.03;
    if (right && !space && length == 30) theta+= 0.03;
    
    //if(space) posH.add(new PVector(speed*cos(theta), speed*sin(theta)));
    if(space) length += speed;


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
    rotate(theta);
    triangle(posH.x-posP.x, posH.y-posP.y-8, posH.x-posP.x+20, posH.y-posP.y, posH.x-posP.x, posH.y-posP.y+8); 
    line(0, 0, posH.x-posP.x, posH.y-posP.y);
    popMatrix();
  }
}