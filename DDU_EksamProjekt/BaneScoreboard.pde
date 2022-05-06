class BaneScoreboard {
  String sql, time;
  SQLite db;
  boolean insert;

  BaneScoreboard() {
    //db.connect();
  }

  void Update(String un, String newTime) {
    
    if(newTime != time) insert = true;
    if(insert){
    sql = "INSERT INTO b1 VALUES('"+null+"','"+un+"','"+newTime+"');";
    db.execute(sql);
    insert = false;
    print("haha");
    }
    time = newTime;
  }

  void Draw() {
  }
}
