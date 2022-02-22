class Keyboard {
  private Key[] keys;

  public Keyboard() {
    keys = new Key[256];
    for (int i = 0; i < 256; i++) {
      keys[i] = new Key();
    }
  }

  public void Update() {
    for (Key x : keys) {
      x.Update();
    }
  }

  public void setKey(int x, boolean y) {
    keys[x].setState(y);
  }

  public boolean getKey(int x) {
    return keys[x].getState();
  }

  public boolean getOldKey(int x) {
    return keys[x].getOldState();
  }

  public boolean Shift(int x) {
    if (getKey(x) && !getOldKey(x)) return true;
    return false;
  }

  public void toggle(int x) {
    if (getKey(x) && !getOldKey(x)) {
      keys[x].Toggle();
    }
  }

  public boolean getToggle(int x) {
    return keys[x].getToggle();
  }
}
