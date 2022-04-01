class Player {

  PVector posP, posH, vel, acc, gravity;
  float theta = PI/2, length, aVel, aAcc, damping, hookInVel, hookInAcc, speed, swingSpeed, playerX, playerY, hookX, hookY;
  boolean aroundPlayer = true, collision;

  Player() {
    length = 30;
    speed = 3;
    swingSpeed = 20;
    aVel =0;
    aAcc = 0;
    damping = 0.99;
    hookInVel = 0;
    hookInAcc = 0;

    posP = new PVector(500, 200);  
    posH = new PVector(posP.x+length, posP.y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    gravity = new PVector(0, 0.01);

    //Skal fjernes når kollision implementeres, og blive true når hooken rammer en væg/whatever
    collision = true;
  }

  void Run(boolean l, boolean r, boolean s) {
    Update(l, r, s);
    Draw(s);
  }

  void Update(boolean left, boolean right, boolean space) {
    if(length < 30) length = 30;
    
    if (left && !space && length == 30) theta+= 0.03;
    if (right && !space && length == 30) theta-= 0.03;

    if (space) length += speed;
    else if (length > 30 && collision) {
      if (aroundPlayer) {
        //Koordinaterne for spilleren og hookens position i det moment spilleren skal begynde at svinge sig gemmes
        playerX = posP.x;
        playerY = posP.y;
        hookX = posH.x;
        hookY = posH.y;
        aAcc = 0;
        aVel = 0;
      }
      aroundPlayer = false;
      acc.setMag(0);
      vel.setMag(0);
    
    } else if (length == 30){
      aroundPlayer = true;
      hookInVel = 0;
    } else if (!collision) length -= speed;

    acc.add(gravity);
    vel.add(acc);
    posP.add(vel);
    acc.setMag(0);
  }

  void Draw(boolean space){

    if (aroundPlayer) {

      pushMatrix();
      translate(posP.x, posP.y);
      rectMode(CENTER);
      fill(50, 200, 50);
      rect(0, 0, 30, 50, 15, 15, 0, 0);
      posH = new PVector(length*sin(theta), length*cos(theta));
      line(0, 0, posH.x, posH.y);

      //triangle();
      circle(posH.x, posH.y, 8);

      popMatrix();
    } else {

      aAcc = (-1 * mag(gravity.x, gravity.y)*swingSpeed/length)*sin(theta);
      aVel += aAcc;
      theta -= aVel;
      aVel *= damping;

      pushMatrix();
      translate(hookX+playerX, hookY+playerY);
      posH.set(-length*sin(theta), -length*cos(theta), 0);
      posP.set(posH.x+playerX+hookX, posH.y+playerY+hookY);

      rectMode(CENTER);
      fill(50, 200, 50);
      rect(posH.x, posH.y, 30, 50, 15, 15, 0, 0);
      line(posH.x, posH.y, 0, 0); 
      circle(0, 0, 8);
      popMatrix();
      
      if(!space){
      hookInAcc += 0.02;
      hookInVel += hookInAcc;
      length -=hookInVel;
      hookInAcc = 0;
      }
    }
  }
}
