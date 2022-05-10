class Knap {
  Vec2 pos;
  boolean on;

  Knap(Vec2 pos, int id) {
    this.pos = pos;
  }

  void Update() {
  }

  void Draw(boolean HitboxDebug) {
    if (on)fill(100, 230, 150);
    else (255, 150, 150);
    noStroke();
    square(0, 0, 42);
    //Text
    textSize(10);
    fill(10);
    text("Knap", 20, 26);
  }
}
