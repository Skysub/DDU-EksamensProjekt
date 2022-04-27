class LoginScreen extends GameState {
  boolean toggleLogin = true;
  String Toggle = "Log in", toggle = "log in", enteredUsername, enteredPassword;
  String[] logInData = new String[3];
  
  Button logInButton = new Button(width/2+50, 290, 100, 50, "Log in", color(80, 235, 80), color(80, 100, 80), 20, color(0, 0, 0));
  Button signUpButton = new Button(width/2-150, 290, 100, 50, "Sign up", color(80, 235, 80), color(80, 100, 80), 20, color(0, 0, 0));
  TextField username, password;
  Keyboard kb;
  SQLite db;

  LoginScreen(PApplet program, Keyboard kb) {
    super(program, kb);
    this.kb = kb;
    username = new TextField(program, "", new PVector(width/2-250, 440));
    password = new TextField(program, "", new PVector(width/2-250, 620));
    
    //db = new SQLite(program "");
  }


  void Update() {  
    username.input(false);
    password.input(false);

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

    if (kb.getKey(13)) {
      enteredUsername = username.input(false);
      enteredPassword = password.input(false);

      try {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(enteredPassword.getBytes());

        byte[] byteList = md.digest();

        StringBuffer hashedValueBuffer = new StringBuffer();
        for (byte b : byteList)hashedValueBuffer.append(hex(b));

        logInData[0] = toggle;
        logInData[1] = enteredUsername;
        logInData[2] = hashedValueBuffer.toString();
      } 
      catch (Exception e) {
        System.out.println("Exception: "+e);
      }

      db.query( "SELECT username FROM PW WHERE username='"+a[1]+"';" );
      if (a[0] != "Log in") {
        if (!db.next()) {
          sql = "INSERT INTO PW VALUES('"+a[1]+"','"+a[2]+"');";
          db.execute(sql);
          currentUsername = a[1];
          return 0;//Bruger succesfult oprettet og logget ind samtidig
        } else return 1; //Hvis brugernavnet allerede findes
      } else {
        if (db.next()) {
          db.query( "SELECT username FROM PW WHERE username='"+a[1]+"' AND password='"+a[2]+"';" );
          if (db.next()) { 
            currentUsername = a[1];
            return 3; //Bruger succesfult logget ind
          }
        } else return 2; //Ingen bruger med dette brugernavn
      }
      return -1; //Forkert password eller brugernavn

      print("enter");
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

    textSize(20);
    fill(250, 100, 100);
    if (username.tooLong) text("Your username must be less than 16 characters", width/2, 500);
    if (username.tooShort) text("Your username has to be at least 3 characters", width/2, 500);
    if (password.tooLong) text("Your password must be less than 16 characters", width/2, 680);
    if (password.tooShort) text("Your password has to be at least 3 characters", width/2, 680);


    logInButton.Draw();
    signUpButton.Draw();
  }
}
