class Key { //<>//
  private boolean state = false;
  private boolean old_state = false;
  private boolean toggle = false;

  //Key repræsenterer én tast
  public Key() {
  }

  //Interrupts der fortæller om en tast er blevet trykket kalder denne metode for at ændre tastens state
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

  //Toggler en tast
  public void Toggle() {
    toggle = !toggle;
  }

  //Bestemmer hvad tastens toggle state skal være
  public void setToggle(boolean x) {
    toggle = x;
  }

  public boolean getToggle() {
    return toggle;
  }
}
