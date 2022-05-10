class Timer {

  int record = 0, time = 0, baneTimeStart = 0, pauseTimeStart = 0, pauseTime = 0;
  int recordMin, recordSec, min, sec;
  String pauseTimeDisplay;

  Timer() {
  }

  void Update(boolean playing, boolean baneStart, boolean endZone, boolean pause) {
    HandleTimer(playing, baneStart, endZone, pause);
  }

  void Draw(boolean popup) {
    fill(180);
    rect(0, 0, width, 80);
    rectMode(CORNER);

    fill(0, 0, 0);
    textSize(50);
    textAlign(LEFT, CENTER);
    //konverterer tiden til læsbar format for racetime
    min = floor(time/60000f);
    sec = floor(time/1000f)-floor(time/60000f)*60;
    if (!popup) text("Time: "+min+":"+sec+"."+(time - floor(time/1000f)*1000), 10, 30);
    else text(pauseTimeDisplay, 10, 30);

    //samme som overstående men blot for rekord tiden
    recordMin = floor(record/60000f);
    recordSec = floor(record/1000f)-floor(record/60000f)*60;
    text("Record: "+recordMin+":"+recordSec+"."+(record - floor(record/1000f)*1000), 420, 30);


    stroke(0);
    strokeWeight(2);
    line(410, 0, 410, 80);
    line(900, 0, 900, 80);
  }

  void HandleTimer(boolean playing, boolean baneStart, boolean endZone, boolean pause) {
    if (baneStart) {
      playing = true;
      time = 0;
      baneTimeStart = millis();
      baneStart = false;
    }
    //måler tiden fra starten af race
    if (playing) {
      time = millis() - baneTimeStart - pauseTime;
    }
    if (pause) pauseTimeDisplay = "Time: "+min+":"+sec+"."+(time - floor(time/1000f)*1000);
    else pauseTimeDisplay = "Time: "+min+":"+sec+"."+(time - floor(time/1000f)*1000);

    //logic for når bane er ovre
    if (endZone) {
      playing = false;
      if (time < record || (record == 0 && time != 0)) record = time;
    }
  }

  void HandlePauseTime(boolean pauseStop) {
    if (pauseStop) {
      pauseTimeStart = millis() - pauseTime;
      pauseTime = 0;
    }
    pauseTime = millis() - pauseTimeStart;
  }

  String[] getText() {
    String[] out = {min+":"+sec+"."+(time - floor(time/1000f)*1000), recordMin+":"+recordSec+"."+(record - floor(record/1000f)*1000), str(min)+str(sec)+str(time - floor(time/1000f)*1000)};
    return out;
  }

  boolean getNewRecord() {
    return record >= time;
  }
}
