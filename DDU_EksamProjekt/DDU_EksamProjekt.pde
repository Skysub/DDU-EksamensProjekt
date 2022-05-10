import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import java.util.Random;
import java.util.stream.*;
import java.nio.file.*;
import controlP5.*;
import de.bezier.data.sql.*;
import de.bezier.data.sql.mapper.*;
import java.security.*;
import java.util.Arrays.*;
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
