class TextField {
  ControlP5 cp5;
  String enteredString, stringTextfield, seedTextfieldOld;
  boolean tooLong, tooShort;
  Textfield textfield;

  //konstruktør hvor tesktfeltet sættes op. Se http://www.sojamo.de/libraries/controlP5/reference/controlP5/Textfield.html for dokumentation
  //PApplet er en reference til selve sketchen og fåes helt tilbage fra RacerSpil ved at blive trukket igennem konstruktører hertil
  TextField(PApplet program, String s, PVector pos, PVector size) {
    stringTextfield = "StringTextField";
    enteredString = s;
    cp5 = new ControlP5(program);
    cp5.setAutoDraw(false);
    PFont p = createFont("Verdana", 20);
    ControlFont font = new ControlFont(p);
    cp5.setFont(font);
    textfield = cp5.addTextfield("StringTextField").setPosition(pos.x, pos.y).setSize(int(size.x), int(size.y)).setAutoClear(false).setText(s).setCaptionLabel("").keepFocus(false);
  }

  void Update() {
    Draw();
    enteredString = cp5.get(Textfield.class, stringTextfield).getText();
  }

  void Draw() {
    cp5.draw();
  }  

  String input(int minL, int maxL) {

    if (enteredString.length() > maxL && maxL != 0) tooLong = true;
    else tooLong = false;
    if (enteredString.length() < minL) tooShort = true;
    else tooShort = false;

    if (enteredString.length()==0) return null;
    return enteredString;
  }

  void RemoveText() {
    cp5.get(Textfield.class, stringTextfield).setText("");
  }
}
