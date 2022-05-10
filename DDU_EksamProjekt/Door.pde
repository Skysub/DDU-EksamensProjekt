class Door {
  Vec2 pos;
  Knap knap;
  int id;
  Body body;
  Box2DProcessing box2d;

  Door(Vec2 pos, int id, Box2DProcessing box2d) {
    this.pos = pos;
    this.id = id;
    this.box2d = box2d;
  }

  void Update() {
  }

  void Draw(boolean HitboxDebug) {
    noStroke();
    if (HitboxDebug) {
      fill(255);
      square(0, 2, 42);
      fill(255, 220, 190);
      square(4, 6, 35);
    } else if (!knap.on) {
      fill(255, 220, 190);
      square(0, 2, 42);
    }
  }

  void MakeBody() {    
    BodyDef bd = new BodyDef();
    PolygonShape ps = new PolygonShape();
    pos.addLocal(new Vec2(40/20, -40/20));
    bd.position.set(pos);
    bd.type = BodyType.STATIC;
    body = box2d.createBody(bd);
    ps.setAsBox(40/20, 40/20);
    body.createFixture(ps, 1);
  }
}
