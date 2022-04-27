class LoginScreen extends GameState {
  boolean toggleLogin = true;
  String Toggle = "Log in", toggle = "log in";
  Button logInButton = new Button(width/2+50, 290, 100, 50, "Log in", color(80, 235, 80), color(80, 100, 80), 20, color(0, 0, 0));
  Button signUpButton = new Button(width/2-150, 290, 100, 50, "Sign up", color(80, 235, 80), color(80, 100, 80), 20, color(0, 0, 0));
  TextField username, password;
  Keyboard kb;

  LoginScreen(PApplet program, Keyboard kb) {
    super(program, kb);
    this.kb = kb;
    username = new TextField(program, "", new PVector(width/2-250, 440));
    password = new TextField(program, "", new PVector(width/2-250, 620));
    
  }


  void Update() {  
    
    //Toggler om brugeren er i gang med at signe op eller logge ind
    if (toggleLogin) {
      Toggle = "Log in";
      toggle = "log in";
      logInButton.currentColor = color(80, 100, 80);
      if (signUpButton.isClicked() && toggleLogin) toggleLogin = false;
      signUpButton.Update();
    } else {
      Toggle = "Sign up";
      toggle = "sign up";
      signUpButton.currentColor = color(80, 100, 80);
      if (logInButton.isClicked() && !toggleLogin) toggleLogin = true;  
      logInButton.Update();
    }
    
    username.Update();
    password.Update();
    
    if (kb.getKey(13)){
      
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
    
    textSize(35);
    text("Username", width/2, 410);
    text("Password", width/2, 590);
    
    fill(50);
    textSize(20);
    text("Change between log in and sign up:", width/2, 270);
    text("ENTER to " + toggle, width/2, 780);
    
    

    logInButton.Draw();
    signUpButton.Draw();
  }

  void RunLogin() {
  }


  void RunSignup() {
  }
}
