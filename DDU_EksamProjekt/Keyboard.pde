class Keyboard {
  private Key[] keys;

  //Holder styr på alle taster (Keys) og hjælper programmet med at bestemme de forskellige scenarier der kunne hænde med en tast
  public Keyboard() {
    keys = new Key[1024];
    for (int i = 0; i < 1024; i++) {
      keys[i] = new Key();
    }
  }

  public void Update() {
    for (Key x : keys) {
      x.Update();
    }
  }

  public void setKey(int x, boolean y) {
    if (x == 84 || x == 72) return; //Disabler t og h, da de er debug taster
    keys[x].setState(y);
    if (Shift(x)) toggle(x); //Hvis tasten lige er blevet trykket på skal dens toggle værdi ændres
  }

  public boolean getKey(int x) {
    return keys[x].getState();
  }

  public boolean getOldKey(int x) {
    return keys[x].getOldState();
  }

//Tjekker om tasten netop lige er blevet trykket på
  public boolean Shift(int x) {
    if (getKey(x) && !getOldKey(x)) return true;
    return false;
  }

  public void toggle(int x) {
    if (getKey(x) && !getOldKey(x)) {
      keys[x].Toggle();
    }
  }

  public void setToggle(int x, boolean y) {
    keys[x].setToggle(y);
  }

  public boolean getToggle(int x) {
    return keys[x].getToggle();
  }
}
