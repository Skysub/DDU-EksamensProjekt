import java.util.Random;
MainLogic mainLogic;

void setup() {
  mainLogic = new MainLogic(this);
  frameRate(60);
  size(1920, 1080);
}

void draw() {
  background(180);
  mainLogic.Update();
  mainLogic.Draw();
}

void keyPressed() {
  mainLogic.HandleInput(keyCode, true);
}

void keyReleased() {
  mainLogic.HandleInput(keyCode, false);
} 
