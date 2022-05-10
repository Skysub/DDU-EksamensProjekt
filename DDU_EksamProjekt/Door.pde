class Door {
  Vec2 pos;

  Door(Vec2 pos, int id) {
    this.pos = pos;
  }

  void Update() {
  }

  void Draw(boolean HitboxDebug) {
    noStroke();
    fill(255, 220, 190);
    square(0, 2, 42);
  }
}
