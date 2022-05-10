class BaneScoreboard {
  String sql, textTime, textUN;
  boolean first = true;
  int tableSize;
  String[][] sbInfo, sbInfoSorted;

  BaneScoreboard(PApplet program) {
  }

  void Update(int lNr, String un, String time) {
    if (first) {
      //Laver en tabel med banen hvis der ikke eksisterer en
      sql = "CREATE TABLE IF NOT EXISTS [bane" +lNr+"] (ID integer PRIMARY KEY AUTOINCREMENT, username text, ftime time)";
      mainLogic.db.execute(sql);
      delay(100);
      //Indsætter tiden i tabellen
      sql = "INSERT INTO bane"+lNr+" VALUES(null,'"+un+"','"+time+"');";
      mainLogic.db.execute(sql);

      //Finder antallet af gemte tider
      mainLogic.db.query("SELECT count(*) FROM bane"+lNr+";");
      if (mainLogic.db.next()) {
        tableSize = mainLogic.db.getInt("count(*)");
      }

      sbInfo = new String[2][tableSize+1];
      for (int i = 1; i < tableSize+1; i++) {
        mainLogic.db.query("SELECT username, ftime FROM bane"+lNr+" WHERE ID = "+i+";");
        if (mainLogic.db.next()) {
          sbInfo[0][i] = mainLogic.db.getString("ftime");
          sbInfo[1][i] = mainLogic.db.getString("username");
        }
      }
      //lav sortering
      sbInfoSorted = sbInfo;
      first = false;
    }
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
      text(i + ".", width/(2*size)-190, i*30 + 65);
      if (i < tableSize+1) {
        text(textUN, width/(2*size)-150, i*30+65);
        text(textTime, width/(2*size)+65, i*30+65);
      }
    }
    line(width/(size*2)-160, 70, width/(size*2)-160, 370);
    line(width/(size*2)+55, 70, width/(size*2)+55, 370);
  }
}
