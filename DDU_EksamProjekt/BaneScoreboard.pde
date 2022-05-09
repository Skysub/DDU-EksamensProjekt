class BaneScoreboard {
  SQLite db;
  String sql;

  BaneScoreboard(PApplet program) {

    db = new SQLite(program, "hookdb.sqlite");
    db.connect();
  }

  void Update(int lNr, String un, String time) {
    db.execute("CREATE TABLE IF NOT EXISTS [bane" +lNr+"] (ID integer PRIMARY KEY AUTOINCREMENT, username text, ftime time)");

    db.query( "SELECT ftime FROM bane"+lNr+" WHERE username='"+un+"' AND ftime='"+time+"';" ); 
    if (db.next()) { 
      print("Time for this user already exists/is already inserted into the databse");
    } else {
      sql = "INSERT INTO bane"+lNr+" VALUES(null,'"+un+"','"+time+"');";
      db.execute(sql);
    }
  }

  void Draw() {
  }
}
