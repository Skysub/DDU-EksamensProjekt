class Button {
  Boolean pressed = false, clicked = false, mouseOver = false, hand = false, clickedPrev = false; //pressed er om selve mussen klikkes på, clicked er om knappen klikkes på
  int x, y, widthB, heightB, textSize;
  String buttonText;
  color currentColor, buttonColor, clickColor, textColor, mouseOverColor = -1;

  Button(int posX, int posY, int w, int h, String t, color c, color cc, int ts, color tc) {
    x = posX;
    y = posY;
    widthB = w;
    heightB = h;
    buttonText = t;
    buttonColor = c;
    currentColor = c;
    clickColor = cc;
    textSize = ts;
    textColor = tc;
  }

  //Alternativ constructor hvis man gerne vil have en speciel mouseover farve
  Button(int posX, int posY, int w, int h, String t, color c, color cc, int ts, color tc, color mouseOverColor) {
    x = posX;
    y = posY;
    widthB = w;
    heightB = h;
    buttonText = t;
    buttonColor = c;
    currentColor = c;
    clickColor = cc;
    textSize = ts;
    textColor = tc;
    this.mouseOverColor = mouseOverColor;
  }

  boolean Update() {
    clickedPrev = clicked;
    if (mouseX >= x && mouseX <= x + widthB && mouseY >= y && mouseY <= y + heightB) {
      hand = true;
      mouseOver = true;
      if (mousePressed && mouseButton == LEFT && pressed == false && clicked == false) {
        clicked = true;
        currentColor = clickColor;
      } else {
        currentColor = buttonColor;
        clicked = false;
      }
    } else { 
      hand = false;
      mouseOver = false;
      clicked = false;
      currentColor = buttonColor;
    }
    pressed = mousePressed;
    return hand;
  }

  void Draw() {
    rectMode(CORNER);
    fill(currentColor);
    if (mouseOver && mouseOverColor == -1)fill(color(red(currentColor)*0.8f, green(currentColor)*0.8f, blue(currentColor)*0.8f)); 
    else if (mouseOver) fill(mouseOverColor);

    noStroke();
    rectMode(CORNER);
    rect(x, y, widthB, heightB, 15);

    fill(textColor);
    textSize(textSize);
    textAlign(CENTER, CENTER);
    text(buttonText, x+(widthB/2), y+(heightB/2));
  }

  boolean isClicked() {
    return clicked;
  }

  boolean MouseReleased() {
    return (!clicked && clickedPrev);
  }
}
