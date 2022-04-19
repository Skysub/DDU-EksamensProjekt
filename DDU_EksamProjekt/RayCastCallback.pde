import org.jbox2d.callbacks.RayCastCallback;

class RcCallback implements RayCastCallback {

  Hook p;
  RcCallback(Hook p) {
    this.p = p;
  }

  public float reportFixture(Fixture fixture, Vec2 point, Vec2 normal, float fraction) {
    p.setSigtePos(point);
    return fraction;
  };
}
