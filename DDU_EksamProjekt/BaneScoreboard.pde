class BaneScoreboard {
  SQLite db;
  String sql;
  boolean first = true;

  BaneScoreboard(PApplet program) {

    db = new SQLite(program, "hookdb.sqlite");
    db.connect();
  }

  void Update(int lNr, String un, String time) {
    db.execute("CREATE TABLE IF NOT EXISTS [bane" +lNr+"] (ID integer PRIMARY KEY AUTOINCREMENT, username text, ftime time)");
    delay(100);

    if (first) {
      sql = "INSERT INTO bane"+lNr+" VALUES(null,'"+un+"','"+time+"');";
      db.execute(sql);
      print("inserted");
      first = false;
    }
  }

  void Draw() {
  }
}
