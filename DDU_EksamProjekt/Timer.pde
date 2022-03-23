class Timer {

  int record, time = 0, baneTimeStart, waitTimer = 0;

  Timer() {
  }

  void Update(boolean playing, boolean baneStart, boolean loginScreenOpen, boolean endZone) {
    handleTimer(playing, baneStart, loginScreenOpen, endZone);
  }

  void Draw() {
    int min, sec;
    int recordMin, recordSec;
    fill(0, 0, 0);
    textSize(50);

    //konverterer tiden til læsbar format for racetime
    min = floor(time/60000f);
    time = time - floor(time/60000f)*60000;
    sec = floor(time/1000f);
    time = time - floor(time/1000f)*1000;
    text("Time: "+min+":"+sec+"."+time, 340, 65);

    //samme som overstående men blot for rekord tiden
    recordMin = floor(record/60000f);
    record = record - floor(record/60000f)*60000;
    recordSec = floor(record/1000f);
    record = record - floor(record/1000f)*1000;
    text("record: "+recordMin+":"+recordSec+"."+record, 775, 65);
  }

  void handleTimer(boolean playing, boolean baneStart, boolean loginScreenOpen, boolean endZone) {
    if (baneStart) {
      playing = true;
      time = 0;
      baneTimeStart = millis();
      baneStart = false;
    }
    //måler tiden fra starten af race
    if (playing && !loginScreenOpen) {
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
