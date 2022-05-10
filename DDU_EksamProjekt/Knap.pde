class Knap {
  Vec2 pos;
  boolean on;
  boolean invert = false;
  Door door;
  int id;

  Knap(Vec2 pos, int id) {
    this.pos = pos;
    this.id = id;
  }

  void Update(HashMap<String, Kasse> kasser) {
  }

  void Draw(boolean HitboxDebug) {
    if ((on && !invert) || (!on && invert)) fill(100, 230, 150);
    else fill(255, 150, 150);
    noStroke();
    square(0, 0, 42);
    //Text
    textSize(10);
    fill(10);
    text("Knap", 20, 26);
  }
}
