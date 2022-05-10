class Sav {
  float size = 10;
  float ekstra = 3;
  Vec2 pos;

  Sav(Vec2 pos, float size) {
    this.pos = pos;
    this.size = size;
  }

  void Update() {
  }

  void Draw(boolean HitboxDebug) {
    DrawSaw(HitboxDebug);
  }

  void DrawSaw(boolean HitboxDebug) {
    //rotate((frameCount)/10f);
    noStroke();
    if (!HitboxDebug) {
      fill(255, 100, 100);
      circle(20, 20, size*10);
    } else {
      fill(100, 255, 100);
      circle(20, 20, (ekstra+size)*10);
      fill(100, 100, 255);
      circle(20, 20, size*10);
    }
  }

  boolean SavCollision(Vec2 player) {
    if (pos.sub(player).length() < (size + ekstra)/2) return true;    
    return false;
  }
}
