class EditorButton extends Button {
  int id;
  int idt;

  EditorButton(int posX, int posY, int w, int h, String t, color c, color cc, int ts, color tc, int id, int idt) {
    super( posX, posY, w, h, t, c, cc, ts, tc);
    this.id = id;
    this.idt = idt;
  }

  void Draw(int id, int idt) {
    rectMode(CORNER);
    fill(currentColor);
    if ((mouseOver && mouseOverColor == -1) || this.id == id || this.idt == idt)fill(color(red(currentColor)*0.7f, green(currentColor)*0.7f, blue(currentColor)*0.7f)); 
    else if (mouseOver) fill(mouseOverColor);

    noStroke();
    rectMode(CORNER);
    rect(x, y, widthB, heightB, 2);

    fill(textColor);
    textSize(textSize);
    textAlign(CENTER, CENTER);
    text(buttonText, x+(widthB/2), y+(heightB/2));
  }
}
