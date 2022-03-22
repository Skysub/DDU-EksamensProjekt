class Player {

  PVector pos, vel, acc, hook, gravity;
  float theta;
  int length, speed;
  boolean grap;

  Player() {
    pos = new PVector(500, 200);
    vel = new PVector(0,0);
    acc = new PVector(0,0);
    gravity = new PVector(0, 0.001);
    length = 30;
    speed = 3;
  }

  void Run(boolean l, boolean r, boolean s) {
    Update(l, r, s);
    Draw();
  }

  void Update(boolean left, boolean right, boolean space) {
    
    // Grappling hooken extendes
    if (space) length += speed;
    
    //Spilleren trækkes op til grappling hooken
    else if (length > 30) {
      pos.x += speed*cos(theta);
      pos.y += speed*sin(theta);
      length -=speed;
    }
    if (left && !space && length == 30) theta-= 0.03;
    if (right && !space && length == 30) theta+= 0.03;
    
    if(length > 30){
      
      acc.add(new PVector(0.01*cos(theta),0));
    }
    
    acc.add(gravity);
    
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
  }

  void Draw() {
    
    pushMatrix();
    translate(pos.x, pos.y);
    rectMode(CENTER);
    fill(50, 200, 50);
    rect(0, 0, 30, 50, 15, 15, 0, 0);
    hook = new PVector(length, 0);
    rotate(theta);
    line(0, 0, hook.x, hook.y);

    triangle(hook.x, hook.y-10, hook.x+15, hook.y, hook.x, hook.y+10); 
    popMatrix();
    
  }
}
