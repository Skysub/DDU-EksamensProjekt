class BaneButton extends Button {
  float realX, realY, realW, realH;

  BaneButton(int posX, int posY, int w, int h, String t, color c, color cc, int ts, color tc, Vec2 mod) {
    super( int(posX+mod.x), int(posY+mod.y), w, h, t, c, cc, ts, tc);
  }

  boolean Update(float[] kamera) {
    MakeReal(kamera);

    clickedPrev = clicked;
    if (mouseX >= realX && mouseX <= realX + realW && mouseY >= realY && mouseY <= realY + realH) {
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

  void MakeReal(float[] kamera) {
    realX = x*kamera[2];
    realY = y*kamera[2];
    realX += kamera[0];
    realY += kamera[1]+80;
    realH = heightB*kamera[2];
    realW = widthB*kamera[2];
  }

  void Draw(float[] kamera) {
    pushMatrix();

    translate(kamera[0], kamera[1]+80);
    scale(kamera[2]);
    translate(x, y);
    rectMode(CORNER);
    fill(currentColor);
    if (mouseOver && mouseOverColor == -1)fill(color(red(currentColor)*0.8f, green(currentColor)*0.8f, blue(currentColor)*0.8f)); 
    else if (mouseOver) fill(mouseOverColor);

    noStroke();
    rectMode(CORNER);
    rect(0, 0, widthB, heightB, 5);

    fill(textColor);
    textSize(textSize);
    textAlign(CENTER, CENTER);
    text(buttonText, (widthB/2), (heightB/2)-3);
    popMatrix();
  }
}
