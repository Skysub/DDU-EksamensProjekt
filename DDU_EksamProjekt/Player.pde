class Player { //<>//
  Bane bane;
  Box2DProcessing box2d;
  BodyDef bd = new BodyDef();
  Body body;
  PolygonShape ps = new PolygonShape();
  FixtureDef fd = new FixtureDef();

  Player(Bane ba, Box2DProcessing b, Vec2 startPos) {
    bane = ba;
    box2d = b;

    makeBody(startPos);
  }


  void Update() {
  }

  void Draw(boolean hitboxDebug) {
    DrawPlayer(hitboxDebug);
  }

  void DrawPlayer(boolean hitboxDebug) {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    if (hitboxDebug) line(0, 0, pos.x, pos.y);
    pushMatrix();
    translate(pos.x, pos.y);
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
      strokeWeight(2);
      stroke(0);
      for (int i = 0; i < ps.getVertexCount(); i++) {
        //Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));      
        //point(v.x, v.y);
      }
      strokeWeight(1);
    } else {
      strokeWeight(1);
      fill(255, 150, 200);
      circle(0, -10, 40);
      noStroke();
      square(-20, -10, 40);
      stroke(1);
      line(-20, -10, -20, 30);
      line(20, -10, 20, 30);
      line(-20, 30, 20, 30);
    }
    popMatrix();
  }

  //Its Alive!!!
  void makeBody(Vec2 startPos) {
    Vec2[] vertices = new Vec2[5];
    vertices[0] = new Vec2(0, 3);
    vertices[1] = new Vec2(-2, 1);
    vertices[2] = new Vec2(2, 1);
    vertices[3] = new Vec2(-2, -3);
    vertices[4] = new Vec2(2, -3);
    ps.set(vertices, 5);

    bd.position.set(startPos);
    bd.type = BodyType.DYNAMIC;
    //bd.bullet = true; Hold denne her commented

    body = box2d.createBody(bd);

    fd.shape = ps;
    fd.friction = 0.3;
    fd.restitution = 0.5;
    fd.density = 1.0;

    body.createFixture(fd);
  }
}
