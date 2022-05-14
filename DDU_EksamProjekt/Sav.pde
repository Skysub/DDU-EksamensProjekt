class Sav {
  float size, ekstra = 3, theta, sawSpeed = 0.025;
  Vec2 pos;

  Sav(Vec2 pos, float size, float sawSpeed) {
    this.pos = pos.add(new Vec2(2, -2));
    this.size = size;
    this.sawSpeed = sawSpeed;
  }

  void Update() {
    RotateSaw();
  }

  void Draw(boolean HitboxDebug, boolean coolGFX) {
    DrawSaw(HitboxDebug);
  }

  void DrawSaw(boolean HitboxDebug) {
    pushMatrix();
    translate(20, 20);
    //rotate((frameCount)/10f);
    noStroke();
    if (!HitboxDebug) {

      fill(255, 100, 100);
      Saw(0, 0, size*3.5, size*4.5, 10);
      fill(255);
      circle(0, 0, size*5);
    } else {
      fill(100, 255, 100);
      circle(0, 0, (ekstra+size)*10);
      fill(100, 100, 255);
      circle(0, 0, size*10);
    }
    popMatrix();
  }

  boolean SavCollision(Vec2 player) {
    if (pos.sub(player).length() < (size + ekstra)/2) return true;    
    return false;
  }

  void Saw(float x, float y, float radius1, float radius2, int npoints) {
    pushMatrix();
    rotate(theta);
    float angle = TWO_PI / npoints;
    float halfAngle = angle/2.0;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius2;
      float sy = y + sin(a) * radius2;
      vertex(sx, sy);
      sx = x + cos(a+halfAngle) * radius1;
      sy = y + sin(a+halfAngle) * radius1;
      vertex(sx, sy);
    }
    endShape(CLOSE);
    popMatrix();
  }

  void RotateSaw() {
    theta += sawSpeed;
  }
}
