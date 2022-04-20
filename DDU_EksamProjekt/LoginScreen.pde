class LoginScreen extends GameState {
  TextFieldString username, password;

  LoginScreen(PApplet program, Keyboard kb) {
    super(program, kb);
  }

  void Draw() {
  }


  void Update() {
    rectMode(CENTER);

    fill(200);
    rect(width/2, height/2, 820, 820);
    fill(180);
    rect(width/2, height/2, 800, 800);

    fill(0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("Log in", width/2, 200);
  }
}
