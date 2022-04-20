class Button {
  Boolean pressed = false, clicked = false, mouseOver = false, hand = false; //pressed er om selve mussen klikkes på, clicked er om knappen klikkes på
  int x, y, widthB, heightB, textSize;
  String buttonText;
  color currentColor, buttonColor, clickColor, textColor;

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

  void Run() {
    Draw();
    Update();
  }

  boolean Update() {
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
    if (mouseOver)fill(color(red(currentColor)*0.8f, green(currentColor)*0.8f, blue(currentColor)*0.8f)); 

    noStroke();
    rect(x, y, widthB, heightB, 15);

    fill(textColor);
    textSize(textSize);
    textAlign(CENTER, CENTER);
    text(buttonText, x+(widthB/2), y+(heightB/2));
  }

  boolean isClicked() {
    return clicked;
  }
}
/* 
 Når en knap skal instantieres:
 Button btn1;
 
 btn1 = new Button(xPos, yPos, længde, højde, "evt. tekst", farven af selv knappen (eks color(200, 50, 50), farven når knappen klikkes, teksstørelsen, farven af teksten);
 
 Når knappen skal bruges (i update-funktion i en klasse for eksempel:
 btn1.run();
 if(btn1.isClicked()){
 //Det der skal ske når man trykke på knappen 
 }
 
 */
