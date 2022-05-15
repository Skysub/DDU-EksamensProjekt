class Timer {

  int record = 0, time = 0, baneTimeStart = 0;
  int recordMin, recordSec, min, sec;
  String lir;

  Timer() {
  }

  void Update(boolean playing, boolean baneStart, boolean endZone) {
    HandleTimer(playing, baneStart, endZone);
  }

  void Draw(String loggedInrecord) {
    lir= loggedInrecord;
    fill(180);
    rect(0, 0, width, 80);
    rectMode(CORNER);

    fill(0, 0, 0);
    textSize(50);
    textAlign(LEFT, CENTER);
    //konverterer tiden til læsbar format for racetime
    min = floor(time/60000f);
    sec = floor(time/1000f)-floor(time/60000f)*60;
    text("Time: "+min+":"+sec+"."+(time - floor(time/1000f)*1000), 10, 30);

    //samme som overstående men blot for rekord tiden
    recordMin = floor(record/60000f);
    recordSec = floor(record/1000f)-floor(record/60000f)*60;
    if(mainLogic.username == null)text("Record: "+recordMin+":"+recordSec+"."+(record - floor(record/1000f)*1000), 420, 30);
    else text("Record: " + lir, 420, 30);
    
    textSize(30);
    text("'TAB' for menu", 980, 35);
    text("'R' to reset", 1300, 35);
    text("'L' to center camera", 1540, 35);
   
    stroke(0);
    strokeWeight(2);
    line(410, 0, 410, 80);
    line(900, 0, 900, 80);
  }

  void HandleTimer(boolean playing, boolean baneStart, boolean endZone) {
    if (baneStart) {
      playing = true;
      time = 0;
      baneTimeStart = millis();
      baneStart = false;
    }
    //måler tiden fra starten af race
    if (playing) {
      time = millis() - baneTimeStart;
    }

    //logic for når bane er ovre
    if (endZone) {
      playing = false;
      if (time < record || (record == 0 && time != 0)) record = time;
    }
  }

  String[] getText() {
    String decimal = str((time - floor(time/1000f)*1000));
    if (decimal.length() == 1) decimal = decimal + "00"; 
    if (decimal.length() == 2) decimal = decimal + "0"; 
    String[] out = {min+":"+sec+"."+(time - floor(time/1000f)*1000), recordMin+":"+recordSec+"."+(record - floor(record/1000f)*1000), str(min)+str(sec)+decimal};
    return out;
  }

  boolean getNewRecord() {
    return record >= time;
  }
  
  void ResetRecord(){
    record = 0;
  }
  
  void ResetTimer(){
    time = 0;
  }
}
