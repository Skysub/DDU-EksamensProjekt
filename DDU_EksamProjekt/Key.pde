class Key { //<>// //<>//
  private boolean state = false;
  private boolean old_state = false;
  private boolean toggle = false;

  public Key() {
  }

  public void setState(boolean x) {
    state = x;
  }

  public void Update() {
    old_state = state;
  }

  public boolean getState() {
    return state;
  }

  public boolean getOldState() {
    return old_state;
  }

  public void Toggle() {
    toggle = !toggle;
  }

  public boolean getToggle() {
    return toggle;
  }
}
