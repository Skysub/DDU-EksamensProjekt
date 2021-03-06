class LoginScreen extends GameState {
  boolean toggleLogin = true, triedUN, triedPW, triedPWS, passwordSecure, removeText = true;
  String Toggle = "Log in", toggle = "log in", enteredUsername, enteredPassword, hashedPassword, hpw, currentUsername, sql;
  int status, minLengthUN = 3, maxLengthUN = 16, minLengthPW = 6;

  Button logInButton, signUpButton, exitButton, enterButton;
  TextField username, password;
  Keyboard kb;

  LoginScreen(PApplet program, Keyboard kb) {
    super(program, kb);
    this.kb = kb;
    logInButton = new Button(width/2-150, 270, 100, 50, "Log in", color(#253FFF), color(50, 50, 50), 20, color(255));
    signUpButton = new Button(width/2+50, 270, 100, 50, "Sign up", color(#253FFF), color(50, 50, 50), 20, color(255));
    exitButton = new Button(width/2+310, 150, 80, 80, "Back", color(180), color(80, 100, 80), 20, color(0, 0, 0), color(255, 105, 105));
    enterButton = new Button(width/2-100, 767, 200, 30, "", color(200), color(80, 100, 80), 20, color(0, 0, 0));
    username = new TextField(program, "", new PVector(width/2-250, 440), new PVector(500, 50), false);
    password = new TextField(program, "", new PVector(width/2-250, 620), new PVector(500, 50), false);
  }

  void Update() {    
    if (removeText) {
      RemoveText();
      removeText = false;
    }
    
    //Toggler ved shift mellem de to tekstbokse
    if (kb.Shift(9) && username.isActive()) {
      username.ChangeFocus(false);
      password.ChangeFocus(true);
    } else if (kb.Shift(9)) {
      username.ChangeFocus(true);
      password.ChangeFocus(false);
    }

    username.Input(minLengthUN, maxLengthUN);
    password.Input(minLengthPW, 0);

    //Toggler om brugeren er i gang med at signe op eller logge ind
    if (toggleLogin) {
      Toggle = "Log in";
      toggle = "log in";
      logInButton.currentColor = color(80, 100, 80);
      if (signUpButton.isClicked() && toggleLogin) {
        toggleLogin = false;
        status = 0;
      }
      signUpButton.Update();
    } else {
      Toggle = "Sign up";
      toggle = "sign up";
      signUpButton.currentColor = color(80, 100, 80);
      if (logInButton.isClicked() && !toggleLogin) {
        toggleLogin = true;
        status = 0;
        passwordSecure = true;
      }
      textSize(14);
      fill(100, 100, 100);
      text("By creating a user you give consent to storage of your highscores and you username. \nThese are visible for other players.", 960, 900);
      logInButton.Update();
    }

    username.Update();
    password.Update();
    exitButton.Update();
    enterButton.Update();

    if (exitButton.isClicked()) {
      RemoveText();
      removeText = true;
      mainLogic.gameStateManager.SkiftGameState("MenuScreen");
    }

    if (kb.Shift(ENTER) || enterButton.isClicked()) {
      triedUN = true;
      triedPW = true;
      triedPWS = true;

      enteredUsername = username.Input(minLengthUN, maxLengthUN);
      enteredPassword = password.Input(minLengthPW, 0);
      
      //Tjekker om man er ved at signe up, og om passwordet opfylder kravene
      if (toggleLogin) passwordSecure = true;
      if (!toggleLogin && enteredPassword != null && !enteredPassword.equals(enteredPassword.toLowerCase()) && !enteredPassword.equals(enteredPassword.toUpperCase()) && HasNumber(enteredPassword)) passwordSecure = true;                                         
      else if (!toggleLogin) passwordSecure = false;

      if (!username.tooShort && !username.tooLong && !password.tooShort && passwordSecure) { 
        hashedPassword = Hash(enteredPassword);
        status = DoDB(enteredUsername, hashedPassword);
      } 
      
      //status 4 er man succesfuldt logget ind, og kan skifte tilbage til menusk??rm
      if (status == 4) {
        RemoveText();
        removeText = true;
        toggleLogin = true;
        mainLogic.username = currentUsername;
        mainLogic.gameStateManager.SkiftGameState("MenuScreen");
      }
    }
    
    //sikre at fejlbeskederne om brugernavnet og kodens l??ngde, samt kodens sikkerhed fjernes n??r de opfyldes
    if (!username.tooShort && !username.tooLong) triedUN = false;
    if (!password.tooShort) triedPW = false;
    if (password.Input(minLengthPW, 0) != null && IsSecure(password.Input(minLengthPW, 0)) && HasNumber(password.Input(minLengthPW, 0))) triedPWS = false;
  }

  void Draw() {
    rectMode(CENTER);
    strokeWeight(3);
    stroke(0);
    fill(200);
    rect(width/2, height/2, 820, 820, 10);

    logInButton.Draw();
    signUpButton.Draw();
    exitButton.Draw();
    enterButton.Draw();

    fill(0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text(Toggle, width/2, 180);

    textSize(35);
    text("Username", width/2, 410);
    text("Password", width/2, 590);

    fill(50);
    textSize(20);
    text("Change between log in and sign up:", width/2, 245);
    text("ENTER to " + toggle, width/2, 780);

    textSize(20);
    fill(250, 100, 100);
    if (username.tooLong && triedUN) text("Your username must be less than " + maxLengthUN + " characters", width/2, 500);
    if (username.tooShort && triedUN) text("Your username has to be at least " + minLengthUN + " characters", width/2, 500);
    if (password.tooShort && triedPW) text("Your password has to be at least " + minLengthPW + " characters", width/2, 680);
    if (!passwordSecure && triedPWS && !toggleLogin) text("Password must have an uppercase letter, a lowercase letter and a number", width/2, 720);

    if (status == 1 && !toggleLogin) text("Username is taken", width/2, 750);
    if (status == 2 && toggleLogin || status == 3 && toggleLogin) text("Wrong username or password", width/2, 750);
  }

  String Hash(String pw) {
    try {
      MessageDigest md = MessageDigest.getInstance("SHA-256");
      md.update(pw.getBytes());

      byte[] byteList = md.digest();
      
      //hasher koden med SHA-256
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
    //Querier SELECT med det indtastede brugernavn, for at tjekke om brugeren eksisterer
    mainLogic.db.query("SELECT username FROM PW WHERE username='"+un+"';");
    if (!toggleLogin) {
      if (!mainLogic.db.next()) {
        //Inds??tter brugernavnet og koden i db'en hvis man er p?? sign up og de ikke eksisterer
        sql = "INSERT INTO PW VALUES('"+un+"','"+pw+"');";
        mainLogic.db.execute(sql);
        delay(100);
        mainLogic.db.query( "SELECT username FROM PW WHERE username='"+un+"' AND password='"+pw+"';" );
        if (mainLogic.db.next()) {
          currentUsername = un;
          return 4;//Bruger opretet og logget ind
        }
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

  boolean HasNumber(String pw) {
    //Opdeler koden i et array af characters og tjekker for hver individuel om de er et tal
    char[] ch = pw.toCharArray();
    for (char c : ch) {
      if (Character.isDigit(c)) {
        return true;
      }
    }
    return false;
  }

  boolean IsSecure(String pw) {
    //Tjekker om koden i tekstboksen, ikke den indtastede, opfylder sikkerhedskravene, p?? samme m??de som HasNumber()
    char[] ch = pw.toCharArray();
    String pwNoNumbers = "";
    for (char c : ch) {
      if (!Character.isDigit(c)) {
        pwNoNumbers = pwNoNumbers + c;
      }
    }
    if (!pwNoNumbers.equals(pwNoNumbers.toLowerCase()) && !pwNoNumbers.equals(pwNoNumbers.toUpperCase())) {
      return true;
    } else return false;
  }

  void RemoveText() {
    username.RemoveText();
    password.RemoveText();
    triedUN = false;
    triedPW = false;
    triedPWS = false;
    enteredUsername = null;
    enteredPassword = null;
    status = 0;
  }
}
