class Door {
  Vec2 pos;
  int id;
  Body body;
  Box2DProcessing box2d;
  //ArrayList<Knap> knapper = new ArrayList<Knap>();
  boolean on;
  boolean oldOn;

  Door(Vec2 pos, int id, Box2DProcessing box2d) {
    this.pos = pos;
    this.id = id;
    this.box2d = box2d;
    MakeBody();
  }

  void Update() {
    body.setActive(!on);
  }

  void StartUpdate() {
    oldOn = on;
    on = false;
  }

  void Draw(boolean HitboxDebug) {
    noStroke();
    if (HitboxDebug) {
      fill(255);
      square(0, 2, 42);
      if (on) fill(200, 255, 190);
      else fill(255, 220, 220);
      square(4, 6, 35);
    } else if (!on) {
      fill(255, 220, 190);
      square(0, 2, 42);
    } else {
      fill(255);
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
