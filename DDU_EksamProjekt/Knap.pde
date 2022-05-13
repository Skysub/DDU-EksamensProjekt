class Knap {
  Vec2 pos;
  boolean on;
  boolean invert = false;
  int id;
  ArrayList<Door> doors = new ArrayList<Door>();

  Knap(Vec2 pos, int id) {
    this.pos = pos.add(new Vec2(2, 2));
    this.id = id;
  }

  void Update(HashMap<String, Kasse> kasser) {
    on = KnapCollision(kasser);
    if (on) {
      for (int i = 0; i < doors.size(); i++) {
        doors.get(i).on = on;
      }
    }
  }

  void Draw(boolean HitboxDebug, boolean coolGFX) {
    if ((on && !invert) || (!on && invert)) fill(100, 230, 150);
    else fill(255, 150, 150);
    noStroke();
    square(0, 0, 42);
    //Text
    textSize(10);
    fill(10);
    text("Button", 20, 26);
  }

  boolean KnapCollision(HashMap<String, Kasse> kasser) {
    for (String x : kasser.keySet()) {
      if (kasser.get(x).body.getPosition().add(new Vec2(0, 0)).sub(pos).length() < kasser.get(x).size/10) return true;
    }
    return false;
  }
}
