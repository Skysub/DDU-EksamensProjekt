class Timer {

  int record = 0, time = 0, baneTimeStart = 0, waitTimer = 0;

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
    sec = floor(time/1000f);
    text("Time: "+min+":"+sec+"."+(time - floor(time/1000f)*1000), 10, 30);

    //samme som overstående men blot for rekord tiden
    recordMin = floor(record/60000f);
    recordSec = floor(record/1000f);
    text("Record: "+recordMin+":"+recordSec+"."+(record - floor(record/1000f)*1000), 420, 30);

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
    if (endZone) {
      playing = false;
      //her havde vi ordenBil i racing game, vi kan evt. have lignende metode til at ordne spiller
      waitTimer = millis();
      if (time < record || (record == 0 && time != 0)) record = time;
    }
  }
}
