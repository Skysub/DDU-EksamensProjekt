class LoginScreen extends GameState {
  boolean toggleLogin = true, triedUN, triedPW;
  String Toggle = "Log in", toggle = "log in", enteredUsername, enteredPassword, hashedPassword, hpw, currentUsername, sql;
  int status, minLengthUN = 3, maxLengthUN = 16, minLengthPW = 6;

  Button logInButton, signUpButton, MenuScreenButton;
  TextField username, password;
  Keyboard kb;
  SQLite db;

  LoginScreen(PApplet program, Keyboard kb) {
    super(program, kb);
    this.kb = kb;
    logInButton = new Button(width/2-150, 290, 100, 50, "Log in", color(80, 235, 80), color(80, 100, 80), 20, color(0, 0, 0));
    signUpButton = new Button(width/2+50, 290, 100, 50, "Sign up", color(80, 235, 80), color(80, 100, 80), 20, color(0, 0, 0));
    MenuScreenButton = new Button(50, 50, 150, 50, "Main Menu", color(235, 80, 80), color(80, 100, 80), 20, color(230));
    username = new TextField(program, "", new PVector(width/2-250, 440), new PVector(500, 50), false);
    password = new TextField(program, "", new PVector(width/2-250, 620), new PVector(500, 50), false);

    db = new SQLite(program, sketchPath()+"\\data\\hookdb.sqlite");
    db.connect();
  }


  void Update() {  
    MenuScreenButton.Update();
    if (MenuScreenButton.isClicked()) ChangeScreen("MenuScreen");
    username.input(minLengthUN, maxLengthUN);
    password.input(minLengthPW, 0);

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

    if (kb.Shift(ENTER)) {
      triedUN = true;
      triedPW = true;

      enteredUsername = username.input(minLengthUN, maxLengthUN);
      enteredPassword = password.input(minLengthPW, 0);

      if (!username.tooShort && !username.tooLong && !password.tooShort) {
        hashedPassword = Hash(enteredPassword);
        status = DoDB(enteredUsername, hashedPassword);
      } 

      if (status == 4) {
        username.RemoveText();
        password.RemoveText();
        enteredUsername = null;
        enteredPassword = null;
        status = 0;
        toggleLogin = true;
        mainLogic.username = currentUsername;

        mainLogic.gameStateManager.SkiftGameState("MenuScreen");
      }
    }

    if (!username.tooShort && !username.tooLong) triedUN = false;
    if (!password.tooShort) triedPW = false;
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
    if (username.tooLong && triedUN) text("Your username must be less than " + maxLengthUN + " characters", width/2, 500);
    if (username.tooShort && triedUN) text("Your username has to be at least " + minLengthUN + " characters", width/2, 500);
    if (password.tooShort && triedPW) text("Your password has to be at least " + minLengthPW + " characters", width/2, 680);

    if (status == 1 && !toggleLogin) text("Username is taken", width/2, 750);
    if (status == 2 && toggleLogin) text("No user with this name exists", width/2, 750);
    if (status == 3 && toggleLogin) text("Wrong username or password", width/2, 750);

    logInButton.Draw();
    signUpButton.Draw();
    MenuScreenButton.Draw();
  }

  String Hash(String pw) {
    try {
      MessageDigest md = MessageDigest.getInstance("SHA-256");
      md.update(pw.getBytes());

      byte[] byteList = md.digest();

      StringBuffer hashedValueBuffer = new StringBuffer();
      for (byte b : byteList)hashedValueBuffer.append(hex(b));

      hpw = hashedValueBuffer.toString();
    } 
    catch (Exception e) {
      System.out.println("Exception: "+e);
    }
    return hpw;
  }

  int DoDB(String un, String pw) {
    db.query("SELECT username FROM PW WHERE username='"+un+"';");
    if (!toggleLogin) {
      if (!db.next()) {
        sql = "INSERT INTO PW VALUES('"+un+"','"+pw+"');";
        db.execute(sql);
        currentUsername = un;
        return 4;//Bruger opretet og logget ind
      } else return 1; //Brugernavnet findes allerede
    } else {
      if (db.next()) {
        db.query( "SELECT username FROM PW WHERE username='"+un+"' AND password='"+pw+"';" ); 
        if (db.next()) { 
          currentUsername = un;
          return 4; //Bruger logget ind
        }
      } else return 2; //Ingen bruger med dette brugernavn
    }
    return 3; //Forkert password eller brugernavn
  }
}
