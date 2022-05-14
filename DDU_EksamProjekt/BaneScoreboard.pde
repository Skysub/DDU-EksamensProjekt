class BaneScoreboard {
  String sql, baneName, textTime, textUN, outside10Time, outside10UN;
  boolean first = true;
  int tableSize, currentPosition, opacity;
  String[][] sbInfoSorted;
  int[] timeInfo, timeInfoSorted;

  BaneScoreboard(PApplet program) {
  }

  void Update(int lNr, String un, String time, int timeNr, boolean customLevel) {
    if (first) {
      currentPosition = 0;
      opacity = 255;

      if (!customLevel) baneName = "bane" + lNr;
      else baneName = "cbane" + lNr;

      //Laver en tabel med banen hvis der ikke eksisterer en
      //sql = "DROP TABLE bane1";
      //mainLogic.db.execute(sql);
      sql = "CREATE TABLE IF NOT EXISTS ["+baneName+"] (ID integer PRIMARY KEY AUTOINCREMENT, username text, ftime time, nrTime integer)";
      mainLogic.db.execute(sql);
      delay(100);
      //Indsætter tiden i tabellen
      sql = "INSERT INTO "+baneName+" VALUES(null,'"+un+"','"+time+"', '"+timeNr+"');";
      mainLogic.db.execute(sql);

      SortTimes();

      for (int i = 0; i < timeInfoSorted.length; i++) {
        if (timeInfoSorted[i] == timeNr) {
          currentPosition = i+1;
        }
        if (currentPosition+2 >= 10) {
          outside10UN = sbInfoSorted[0][i]; 
          outside10Time = sbInfoSorted[1][i];
          break;
        }
      } 

      first = false;
    }
    if (opacity > 0) opacity -=2;
  }

  void Draw(float size) {
    //Selve scoreboardet tegnes
    fill(255);
    rect(width/(2*size)-200, 70, 400, 300);
    textSize(20);
    textAlign(LEFT);
    for (int i = 1; i < 11; i++) {
      if (i < tableSize+1) {
        textTime = sbInfoSorted[0][i];
        textUN = sbInfoSorted[1][i];
      }
      fill(230);
      if (i%2 == 0) rect(width/(2*size)-200, i*30+40, 400, 30);
      fill(0);
      line(width/(2*size)-200, i*30 + 70, width/(2*size)+200, i*30 + 70);
      text(i + ".", width/(2*size)-193, i*30 + 65);
      if (i < tableSize+1) {
        text(textUN, width/(2*size)-150, i*30+65);
        text(textTime, width/(2*size)+65, i*30+65);
      }
    }
    if (currentPosition-2 < 10) {
      fill(80, 235, 80, opacity);
      rect(width/(2*size)-200, currentPosition*30+10, 400, 30);
    } else {
      fill(255);
      rect(width/(2*size)-200, 11*30+60, 400, 30);
      fill(0);
      line(width/(size*2)-160, 11*30+60, width/(size*2)-160, 11*30+90);
      line(width/(size*2)+55, 11*30+60, width/(size*2)+55, 11*30+90);
      text(currentPosition-1 + ".", width/(2*size)-193, 11*30 + 85);
      text(outside10Time, width/(2*size)-150, 11*30+85);
      text(outside10UN, width/(2*size)+65, 11*30+85);
      textAlign(CENTER);
      textSize(35);
      text("...", width/(2*size), 11*30+55);
      textSize(20);
      textAlign(LEFT);
      fill(80, 235, 80, opacity);
      rect(width/(2*size)-200, 11*30+60, 400, 30);
    }
    line(width/(size*2)-160, 70, width/(size*2)-160, 370);
    line(width/(size*2)+55, 70, width/(size*2)+55, 370);
  }

  void SortTimes() {
    //Finder antallet af gemte tider
    mainLogic.db.query("SELECT count(*) FROM "+baneName+";");
    if (mainLogic.db.next()) {
      tableSize = mainLogic.db.getInt("count(*)");
    }

    sbInfoSorted = new String[2][tableSize+1];
    timeInfo = new int[tableSize+1];
    for (int i = 1; i < tableSize+1; i++) {
      mainLogic.db.query("SELECT username, ftime, nrTime FROM "+baneName+" WHERE ID = "+i+";");
      if (mainLogic.db.next()) {
        timeInfo[i] = mainLogic.db.getInt("nrTime");
      }
    }
    timeInfoSorted = sort(timeInfo);

    for (int i = 0; i < timeInfoSorted.length; i++) {
      mainLogic.db.query("SELECT username, ftime FROM "+baneName+" WHERE nrTime = "+timeInfoSorted[i]+";");
      //print(timeInfoSorted[i], "||");
      if (mainLogic.db.next()) {
        sbInfoSorted[0][i] = mainLogic.db.getString("ftime");
        sbInfoSorted[1][i] = mainLogic.db.getString("username");
      }
    }
  }

  String getRecord(String possibleRecord, int recordValue, String un, int lNr, boolean customLevel) {
    if (!customLevel) baneName = "bane" + lNr;
    else baneName = "cbane" + lNr;
    
    SortTimes();

    for (int i = 0; i < timeInfoSorted.length; i++) {
      print(sbInfoSorted[1][i], "|");
      //print("|"+ sbInfoSorted[1][i]+"="+un);
      if (sbInfoSorted[1][i] == un && timeInfoSorted[i] > recordValue) {
        print("yay");
        return possibleRecord;
      } else if (sbInfoSorted[1][i] == un) {
        print("nay");
        return sbInfoSorted[0][i];
      }
    }
    return "no record with this user";
  }
}
