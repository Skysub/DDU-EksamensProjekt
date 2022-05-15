import org.jbox2d.callbacks.RayCastCallback;

//Dette interface implementeres så raycasting fungerer og så vi får den ønskede effekt
class RcCallbackKasse implements RayCastCallback {

  Hook p;
  RcCallbackKasse(Hook p) {
    this.p = p;
  }

  public float reportFixture(Fixture fixture, Vec2 point, Vec2 normal, float fraction) {
    p.kasseHit(fixture);
    return fraction;
  };
}
