class FileHandler { //<>// //<>// //<>//
  SQLite db;

  FileHandler(PApplet program) {
    MakeDataFolder(program);
    //File folder = new File(sketchPath());
    //listFilesForFolder(folder);
    try (Stream<Path> paths = Files.walk(Paths.get(sketchPath()))) {
      paths
        .filter(Files::isRegularFile)
        .forEach(System.out::println);
    }
  }

  int MakeLevelFile(IntList[][] b) {
    Table bane = new Table();
    bane.addColumn("id");
    bane.addColumn("rotation");
    bane.addColumn("extra"); //Extra bruges kun til selve banens information

    for (int i = 0; i < b[0][0].get(0); i++) {
      for (int j = 0; j < b[0][0].get(1); j++) {
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
      saveTable(bane, "levels\\level_"+b[0][0].get(2)+".csv");
    }
    catch(Exception e) {
      println("Time: "+millis()+" Exception: "+e);
      return -1;
    }
    return 0;
  }

  IntList[][] LoadLevelFile(String path) {
    IntList[][] out;
    try {
      Table table = loadTable(path, "header");
      out = new IntList[table.getInt(0, "id")][table.getInt(0, "rotation")];

      for (int i = 0; i < table.getInt(0, "id"); i++) {
        for (int j = 0; j < table.getInt(0, "rotation"); j++) {
          out[i][j] = new IntList();
          if (i == 0 && j == 0) {
            out[i][j].append(table.getInt(0, "id"));
            out[i][j].append(table.getInt(0, "rotation"));
            out[i][j].append(table.getInt(0, "extra"));
          } else {
            out[i][j].append(table.getInt((i*out[0][0].get(1))+j, "id"));
            out[i][j].append(table.getInt((i*out[0][0].get(1))+j, "rotation"));
          }
        }
      }
    }
    catch(Exception e) {
      println("Time: "+millis()+" Exception: "+e);
      println("Couldn't load and parse level file");
      out = new IntList[0][0];
    }
    return out;
  }

  void listFilesForFolder(File folder) {
    for (File fileEntry : folder.listFiles()) {
      if (fileEntry.isDirectory()) {
        listFilesForFolder(fileEntry);
      } else {
        System.out.println(fileEntry.getName());
      }
    }
  }

  void MakeDataFolder(PApplet program) {
    try {
      //Makes data folder
      File directory = new File(sketchPath()+"\\data");
      if (!directory.exists()) {
        directory.mkdir();
      }

      directory = new File(sketchPath()+"\\levels");
      if (!directory.exists()) {
        directory.mkdir();
      }

      //Laver SQLite filen hvis den ikke existerer
      File tempFile = new File(sketchPath()+"\\data\\hookdb.SQLite");
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
