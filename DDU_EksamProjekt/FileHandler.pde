class FileHandler { //<>// //<>// //<>//
  SQLite db;

  FileHandler(PApplet program) {
    MakeDataFolder(program);
  }

  int MakeLevelFile(IntList[][] b) {
    Table bane = new Table();
    bane.addColumn("id");
    bane.addColumn("rotation");
    bane.addColumn("extra"); //Extra bruges kun til selve banens information

    for (int i = 0; i < b[0][0].get(1); i++) { //Højde
      for (int j = 0; j < b[0][0].get(0); j++) { //Bredde
        TableRow newRow = bane.addRow();
        if (j == 0 && i == 0) {    
          newRow.setInt("id", b[0][0].get(0));
          newRow.setInt("rotation", b[0][0].get(1));
          newRow.setInt("extra", b[0][0].get(2));
        } else {
          newRow.setInt("id", b[i][j].get(0));
          newRow.setInt("rotation", b[i][j].get(1));
        }
      }
    }

    try {
    }
    catch(Exception e) {
      println("Time: "+millis()+" Exception: "+e);
      return -1;
    }
    return 0;
  }

  IntList[][] ParseLevelFile() {
    return new IntList[0][0];
  }

  void MakeDataFolder(PApplet program) {
    try {
      //Makes data folder
      File directory = new File(sketchPath()+"\\data");
      if (!directory.exists()) {
        directory.mkdir();
      }

      //Laver SQLite filen hvis den ikke existerer
      File tempFile = new File(sketchPath()+"\\data\\hookdb.SQLite"); //<>//
      if (!tempFile.exists()) {
        tempFile.createNewFile();
        delay(100);
        db = new SQLite(program, sketchPath()+"\\data\\hookdb.SQLite");
        db.connect(); //Opretter de forskellige tables i sqlite filen
        db.execute("CREATE TABLE [PW] (username text NOT NULL PRIMARY KEY UNIQUE,password text)");
      }
    }
    catch(Exception e) {
      println("Time: "+millis()+" Exception: "+e);
      println("Error in filehandler");
    }
  }
}
