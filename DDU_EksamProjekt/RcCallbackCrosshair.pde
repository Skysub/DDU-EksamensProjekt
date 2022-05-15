import org.jbox2d.callbacks.RayCastCallback;

//Dette interface implementeres så raycasting fungerer og så vi får den ønskede effekt
class RcCallbackCrosshair implements RayCastCallback {

  Hook p;
  RcCallbackCrosshair(Hook p) {
    this.p = p;
  }

  public float reportFixture(Fixture fixture, Vec2 point, Vec2 normal, float fraction) {
    p.setSigtePos(point);
    return fraction;
  };
}
