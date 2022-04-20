class Player {
  Bane bane;
  Box2DProcessing box2d;
  BodyDef bd = new BodyDef();
  Body body;
  PolygonShape ps = new PolygonShape();
  FixtureDef fd = new FixtureDef();
  Hook hook;
  float wobble = 0.05; //OG value = 0,05

  Player(Bane ba, Box2DProcessing b, Vec2 startPos) {
    bane = ba;
    box2d = b;
    hook = new Hook(box2d, new Vec2(0, 0), bane);
    makeBody(startPos);
  }

  void Update(boolean left, boolean right, boolean space, boolean hitboxDebug) {
    Vec2 retning = hook.Update(left, right, body.getPosition(), body.getAngle(), space, hitboxDebug);

    //En kraftvektor, og punktet hvor hooken sidder på spilleren
    body.applyForce(retning, new Vec2(body.getPosition().x+(sin(-body.getAngle())*wobble), body.getPosition().y+(cos(-body.getAngle())*wobble)));
  }

  void Draw(boolean hitboxDebug) {
    DrawPlayer(hitboxDebug);
  }

  boolean InGoalZone(boolean hitboxDebug) {
    Vec2 playerPos = body.getPosition();
    Vec2 pSted = new Vec2((playerPos.x+width/20)*10, (playerPos.y-height/20)*10);
    if (bane.CalcCollision(new PVector(pSted.x, -pSted.y), hitboxDebug) == 2) return true;
    return false;
  }

  void DrawPlayer(boolean hitboxDebug) {
    Vec2 pos = box2d.getBodyPixelCoord(body); //Får positionen af spilleren på skærmen i pixels
    float a = body.getAngle();

    //Tegner hooken, det er vigtigt at det sker her, så snoren ikke overlapper spilleren
    hook.Draw(hitboxDebug, body.getPosition(), body.getAngle());

    //Spilleren tegnes
    stroke(1);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);

    if (hitboxDebug) {
      //Tegner spillerens hitbox, altså hvordan physics enginenen ser spilleren
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

    //Tegner en linje til spillerens position, altså centrum
    if (hitboxDebug) line(0, 0, pos.x, pos.y);
  }

  //Its Alive!!!
  void makeBody(Vec2 startPos) {
    //De punkter spillerens hitbox består af
    Vec2[] vertices = new Vec2[5];
    vertices[0] = new Vec2(0, 3);
    vertices[1] = new Vec2(-2, 1);
    vertices[2] = new Vec2(2, 1);
    vertices[3] = new Vec2(-2, -3);
    vertices[4] = new Vec2(2, -3);
    ps.set(vertices, 5);

    bd.position.set(startPos);
    bd.type = BodyType.DYNAMIC;
    //bd.bullet = true; //Uncomment denne linje hvis spilleren ikke kolliderer ordentligt da den er for hurtig

    body = box2d.createBody(bd);

    //Sætter nogle vigtige karakteristika
    fd.shape = ps;
    fd.friction = 0.6; //OG value 0,6
    fd.restitution = 0.1; //OG value 0,1
    fd.density = 1.0; //OG value 1,0

    body.createFixture(fd);
  }

  protected void finalize()  
  {  
    box2d.destroyBody(body);
  }
}
