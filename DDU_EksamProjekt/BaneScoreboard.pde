class BaneScoreboard {
  SQLite db;
  String sql;
  boolean first = true;

  BaneScoreboard(PApplet program) {

    db = new SQLite(program, "hookdb.sqlite");
    db.connect();
  }

  void Update(int lNr, String un, String time) {
    /*if (first) {
     sql = "CREATE TABLE IF NOT EXISTS [bane" +lNr+"] (ID integer PRIMARY KEY AUTOINCREMENT, username text, ftime time)";
     db.execute(sql);
     delay(100);
     sql = "INSERT INTO bane"+lNr+" VALUES(null,'"+un+"','"+time+"');";
     db.execute(sql);
     print("inserted");
     first = false;
     }*/
  }

  void Draw(float size) {
    //Selve scoreboardet tegnes
    fill(255);
    rect(width/(2*size)-200, 70, 400, 300);
    textSize(20);
    textAlign(LEFT);
    for (int i = 1; i < 11; i++) {
      fill(230);
      if (i%2 == 0) rect(width/(2*size)-200, i*30+40, 400, 30);
      fill(0);
      line(width/(2*size)-200, i*30 + 70, width/(2*size)+200, i*30 + 70);
      text(i + ".", width/(2*size)-190, i*30 + 65);
      text("ole", width/(2*size)-150, i*30+65);
      text("1:01:2", width/(2*size)+65, i*30+65);
    }
    line(width/(size*2)-165, 70, width/(size*2)-165, 370);
    line(width/(size*2)+55, 70, width/(size*2)+55, 370);
  }
}
