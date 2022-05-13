class EditorButton extends Button {
  int id;
  int idt;
  boolean rightClicked = false;
  boolean rightClickedPrev = false;

  EditorButton(int posX, int posY, int w, int h, String t, color c, color cc, int ts, color tc, int id, int idt) {
    super( posX, posY, w, h, t, c, cc, ts, tc);
    this.id = id;
    this.idt = idt;
  }

  boolean Update() {
    clickedPrev = clicked;
    rightClickedPrev = rightClicked;
    if (mouseX >= x && mouseX <= x + widthB && mouseY >= y && mouseY <= y + heightB) {
      hand = true;
      mouseOver = true;
      if (mousePressed && pressed == false && clicked == false) {
        if (mouseButton == LEFT) {
          clicked = true;
          currentColor = clickColor;
        } else if (mouseButton == RIGHT) {
          rightClicked = true;
          currentColor = clickColor;
        }
      } else {
        currentColor = buttonColor;
        clicked = false;
        rightClicked = false;
      }
    } else { 
      hand = false;
      mouseOver = false;
      clicked = false;
      rightClicked = false;
      currentColor = buttonColor;
    }
    pressed = mousePressed;
    return hand;
  }

  void Draw(int id, int idt) {
    rectMode(CORNER);
    fill(currentColor);
    if ((mouseOver && mouseOverColor == -1) || this.id == id || this.idt == idt)fill(color(red(currentColor)*0.6f, green(currentColor)*0.6f, blue(currentColor)*0.6f)); 
    else if (mouseOver) fill(mouseOverColor);

    noStroke();
    rectMode(CORNER);
    if(this.id == id || this.idt == idt) rect(x, y-4, widthB, heightB+4, 2);
    else rect(x, y, widthB, heightB, 2);

    fill(textColor);
    textSize(textSize);
    textAlign(CENTER, CENTER);
    text(buttonText, x+(widthB/2), y+(heightB/2));
  }

  boolean rightIsClicked() {
    return rightClicked;
  }

  boolean rightMouseReleased() {
    return (!rightClicked && rightClickedPrev);
  }
}
