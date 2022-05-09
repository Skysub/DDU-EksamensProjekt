class Kasse {
  float size = 40;
  Box2DProcessing box2d;
  Body body;
  PolygonShape ps;

  Kasse(Vec2 pos, Box2DProcessing box2d) {
    this.box2d = box2d;

    BodyDef bd = new BodyDef();
    ps = new PolygonShape();
    pos.addLocal(new Vec2(size/20, -size/20));
    bd.position.set(pos);
    bd.type = BodyType.DYNAMIC;
    body = box2d.createBody(bd);
    ps.setAsBox(size/20, size/20);
    body.createFixture(ps, 1);
  }

  void Update() {
  }

  void Draw(float[] kamera, boolean hitboxDebug) {
    Vec2 pos = box2d.getBodyPixelCoord(body); //Får positionen af kassen på skærmen i pixels
    float a = body.getAngle();
    translate(kamera[0], kamera[1]);
    scale(kamera[2]);

    //Kassen tegnes
    stroke(1);
    pushMatrix();
    translate(pos.x, pos.y+80);
    rotate(-a);

    if (hitboxDebug) {
      fill(255, 100, 100);
      noStroke();
      beginShape();
      for (int i = 0; i < ps.getVertexCount(); i++) {
        Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
        vertex(v.x, v.y);
      }
      endShape(CLOSE);
      stroke(0);
      strokeWeight(1);
    } else {
      strokeWeight(2);
      fill(220);
      square(-20, -20, 40);
      fill(0);
      text("Kasse", 0, 0);
    }
    popMatrix();

    //Tegner en linje til kassens position, altså centrum
    if (hitboxDebug) line(0, 80, pos.x, pos.y+80);
  }

  protected void finalize() {
    box2d.destroyBody(body);
  }
}
