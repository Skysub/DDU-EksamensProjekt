class LoginScreen extends GameState {
  boolean toggleLogin = true, triedUN, triedPW, triedPWS, passwordSecure;
  String Toggle = "Log in", toggle = "log in", enteredUsername, enteredPassword, hashedPassword, hpw, currentUsername, sql;
  int status, minLengthUN = 3, maxLengthUN = 16, minLengthPW = 6;

  Button logInButton, signUpButton, exitButton, enterButton;
  TextField username, password;
  Keyboard kb;

  LoginScreen(PApplet program, Keyboard kb) {
    super(program, kb);
    this.kb = kb;
    logInButton = new Button(width/2-150, 290, 100, 50, "Log in", color(80, 235, 80), color(80, 100, 80), 20, color(0, 0, 0));
    signUpButton = new Button(width/2+50, 290, 100, 50, "Sign up", color(80, 235, 80), color(80, 100, 80), 20, color(0, 0, 0));
    exitButton = new Button(width/2+310, 150, 80, 80, "Back", color(200), color(80, 100, 80), 20, color(0, 0, 0));
    enterButton = new Button(width/2-100, 760, 200, 40, "", color(180), color(80, 100, 80), 20, color(0, 0, 0));
    username = new TextField(program, "", new PVector(width/2-250, 440), new PVector(500, 50), false);
    password = new TextField(program, "", new PVector(width/2-250, 620), new PVector(500, 50), false);
  }


  void Update() {      
    username.Input(minLengthUN, maxLengthUN);
    password.Input(minLengthPW, 0);

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
    exitButton.Update();
    enterButton.Update();

    if (exitButton.isClicked()) {
      RemoveText();
      mainLogic.gameStateManager.SkiftGameState("MenuScreen");
    }

    if (kb.Shift(ENTER) || enterButton.isClicked()) {
      triedUN = true;
      triedPW = true;
      triedPWS = true;

      enteredUsername = username.Input(minLengthUN, maxLengthUN);
      enteredPassword = password.Input(minLengthPW, 0);

      if (toggleLogin) passwordSecure = true;
      if (!toggleLogin && enteredPassword != null && !enteredPassword.equals(enteredPassword.toLowerCase()) && !enteredPassword.equals(enteredPassword.toUpperCase())) passwordSecure = true;                                         
      else if (!toggleLogin) passwordSecure = false;

      if (!username.tooShort && !username.tooLong && !password.tooShort && passwordSecure) { 
        hashedPassword = Hash(enteredPassword);
        status = DoDB(enteredUsername, hashedPassword);
      } 

      if (status == 4) {
        RemoveText();
        status = 0;
        toggleLogin = true;
        mainLogic.username = currentUsername;

        mainLogic.gameStateManager.SkiftGameState("MenuScreen");
      }
    }

    if (username.isActive() && kb.Shift(ENTER)) {
      username.ChangeFocus(false);
      password.ChangeFocus(true);
      triedPW = false;
      triedPWS = false;
    }

    if (!username.tooShort && !username.tooLong) triedUN = false;
    if (!password.tooShort) triedPW = false;
    if (password.Input(minLengthPW, 0) != null && password.Input(minLengthPW, 0).equals(password.Input(minLengthPW, 0).toLowerCase()) && password.Input(minLengthPW, 0).equals(password.Input(minLengthPW, 0).toUpperCase())) triedPWS = false;
  }

  void Draw() {
    rectMode(CENTER);

    fill(200);
    rect(width/2, height/2, 820, 820);
    fill(180);
    rect(width/2, height/2, 800, 800);

    logInButton.Draw();
    signUpButton.Draw();
    exitButton.Draw();
    enterButton.Draw();

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
    if (!passwordSecure && triedPWS) text("Password must have an uppercase letter, a lowercase letter and a number", width/2, 750);

    if (status == 1 && !toggleLogin) text("Username is taken", width/2, 750);
    if (status == 2 && toggleLogin) text("No user with this name exists", width/2, 750);
    if (status == 3 && toggleLogin) text("Wrong password", width/2, 750);
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
    mainLogic.db.query("SELECT username FROM PW WHERE username='"+un+"';");
    if (!toggleLogin) {
      if (!mainLogic.db.next()) {
        sql = "INSERT INTO PW VALUES('"+un+"','"+pw+"');";
        mainLogic.db.execute(sql);
        currentUsername = un;
        return 4;//Bruger opretet og logget ind
      } else return 1; //Brugernavnet findes allerede
    } else {
      if (mainLogic.db.next()) {
        mainLogic.db.query( "SELECT username FROM PW WHERE username='"+un+"' AND password='"+pw+"';" ); 
        if (mainLogic.db.next()) { 
          currentUsername = un;
          return 4; //Bruger logget ind
        }
      } else return 2; //Ingen bruger med dette brugernavn
    }
    return 3; //Forkert password eller brugernavn
  }

  void RemoveText() {
    username.RemoveText();
    password.RemoveText();
    triedUN = false;
    triedPW = false;
    triedPWS = false;
    enteredUsername = null;
    enteredPassword = null;
  }
}
