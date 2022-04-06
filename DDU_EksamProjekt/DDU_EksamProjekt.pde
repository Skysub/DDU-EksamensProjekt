import de.bezier.data.sql.*;
import de.bezier.data.sql.mapper.*;
import controlP5.*;
import java.security.*;
import java.util.Random;
MainLogic mainLogic;

void setup() {
  mainLogic = new MainLogic(this);
  frameRate(60);
  size(1920, 1080);
}

void draw() {
  background(180);
  mainLogic.Draw();
  mainLogic.Update();
}

void keyPressed() {
  mainLogic.HandleInput(keyCode, true);
}

void keyReleased() {
  mainLogic.HandleInput(keyCode, false);
} 
