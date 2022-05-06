class BaneScoreboard {
  String sql;

  BaneScoreboard() {
  }

  void Update(String newTime) {
    sql = "INSERT INTO PW VALUES('"+un+"','"+pw+"');";
    db.execute(sql);
    
  }

  void Draw() {
  }
}
