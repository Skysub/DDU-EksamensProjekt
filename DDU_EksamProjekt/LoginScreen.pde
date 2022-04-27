class LoginScreen extends GameState {
  TextFieldString username, password;
  boolean toggleLogin = true;
  String Toggle = "Log in", toggle = "log in";
  Button toggleButton = new Button(width/2-150, 700, 300, 80, "Log in/sign up", color(80, 235, 80), color(135, 28, 28), 20, color(0, 0, 0));

  LoginScreen(PApplet program, Keyboard kb) {
    super(program, kb);
  }


  void Update() {
    toggleButton.Update();
    if (toggleButton.isClicked() && toggleLogin) toggleLogin = false;
    //if (toggleButton.isClicked() && !toggleLogin) toggleLogin = true;
    

    if (toggleLogin) {
      Toggle = "Log in";
      toggle = "log in";
    } else {
      Toggle = "Sign up";
      toggle = "sign up";
    }
  }

  void Draw() {
    rectMode(CENTER);

    fill(200);
    rect(width/2, height/2, 820, 820);
    fill(180);
    rect(width/2, height/2, 800, 800);

    fill(0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text(Toggle, width/2, 200);

    toggleButton.Draw();
  }

  void RunLogin() {
  }


  void RunSignup() {
  }
}
