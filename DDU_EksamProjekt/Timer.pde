class Timer {

  int record, time = 0, baneTimeStart, waitTimer = 0;

  Timer() {
  }

  void Update(boolean playing, boolean baneStart, boolean endZone) {
    handleTimer(playing, baneStart, endZone);
  }

  void Draw() {
    int min, sec;
    int recordMin, recordSec;
    fill(0, 0, 0);
    textSize(50);
    textAlign(LEFT, CENTER);
    //konverterer tiden til læsbar format for racetime
    min = floor(time/60000f);
    time = time - floor(time/60000f)*60000;
    sec = floor(time/1000f);
    time = time - floor(time/1000f)*1000;
    text("Time: "+min+":"+sec+"."+time, 10, 30);

    //samme som overstående men blot for rekord tiden
    recordMin = floor(record/60000f);
    record = record - floor(record/60000f)*60000;
    recordSec = floor(record/1000f);
    record = record - floor(record/1000f)*1000;
    text("Record: "+recordMin+":"+recordSec+"."+record, 420, 30);

    stroke(0);
    strokeWeight(2);
    line(410, 0, 410, 80);
    line(900, 0, 900, 80);
  }

  void handleTimer(boolean playing, boolean baneStart, boolean endZone) {
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
    if (playing && endZone) {
      playing = false;
      //her havde vi ordenBil i racing game, vi kan evt. have lignende metode til at ordne spiller
      waitTimer = millis();
      if (time < record) record = time;
      else if (record == 0 && time != 0) record = time;
    }
  }
}
