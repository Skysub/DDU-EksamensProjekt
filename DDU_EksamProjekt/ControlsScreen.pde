class ControlsScreen extends GameState {
  Button exitButton = new Button(width/2-80, 150, 120, 60, "Main menu", color(200), color(80, 100, 80), 20, color(0, 0, 0), color(255, 105, 105));
  boolean hand;

  ControlsScreen(PApplet program, Keyboard kb) {
    super(program, kb);
  }

  void Update() {
    hand = false;
    if (exitButton.Update()) hand = true;
    if (hand)cursor(HAND);
    else cursor(ARROW);

    if (exitButton.isClicked()) ChangeScreen("MenuScreen");
  }

  void Draw() {
    background(235);
    exitButton.Draw();
    fill(0);
    textSize(50);
    textAlign(LEFT);
    text("Controls for playing:", 1130, 200);
    text("Controls for level editor:", 70, 200);

    textSize(30);
    text("Use left/right arrow or A/D to aim the grapplehook", 1130, 300);
    text("Hold 'shift' to aim slower", 1130, 360);
    text("Use 'R' to restart the level", 1130, 420);
    text("Use 'TAB' to open the menu", 1130, 480);
    text("Use 'L' to lock the view to the player", 1130, 540);
    text("You have to be logged in to save your time", 1130, 600);

    text("Use shift+drag or the arrow keys to pan around", 70, 300);
    text("Zoom using the scroll wheel", 70, 360);
    text("Use 'R' to reset the view", 70, 420);
    text("Use 'C' to toggle between the editor view and final view", 70, 480);
    text("Use the buttons on the side of the level to change the level size", 70, 540);
    text("Left/Right click a tile in the top bar to select it", 70, 600);
    text("Left/Right click in the level to place blocks of the chosen type", 70, 660);
    text("Use the 'New Level' button in the menu to clear the level", 70, 720);
    text("Type a number into a text field and press the assosciated button", 70, 780);
    text("in order to save or load a level file", 70, 820);
    text("Use the load button in the 'Levels' screen to play the custom map", 70, 880);
    //text("", 70, 940);
  }
}
