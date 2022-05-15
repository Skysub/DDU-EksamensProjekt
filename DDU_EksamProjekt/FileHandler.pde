class FileHandler { //<>// //<>// //<>//

  FileHandler(PApplet program) {
    MakeDataFolder(program);
    //File folder = new File(sketchPath());
    //listFilesForFolder(folder);
  }

  //Laver en .csv fil med al banens information
  int MakeLevelFile(IntList[][] b) {
    Table bane = new Table(); //Processings table() klasse bruges
    bane.addColumn("id");
    bane.addColumn("rotation");
    bane.addColumn("extra"); //Extra bruges kun til selve banens information, og til knapper/døres pairing id

    //Laver først en tabel med banens information
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
          if (b[i][j].get(0) == 7 || b[i][j].get(0) == 8) {
            newRow.setInt("extra", b[i][j].get(2));
          }
        }
      }
    }

    //Prøver at lave en .csv fil gennem tabellen.
    try {
      //Opretter et objekt med den korrekte path
      File tempFile = new File(sketchPath()+"\\custom_levels\\level_"+b[0][0].get(2)+".csv"); 
      if (tempFile.exists()) {
        //Hvis denne fil allerede eksisterer tjekkes der om man kan lave en fil med samme navn med '(i)' sat på enden
        for (int i = 1; i < 70; i++) {
          File t = new File(sketchPath()+"\\custom_levels\\level_"+b[0][0].get(2)+"("+i+")"+".csv");
          if (!t.exists()) { 
            saveTable(bane, "custom_levels\\level_"+b[0][0].get(2)+"("+i+")"+".csv"); 
            break;
          }
        }
      } else saveTable(bane, "custom_levels\\level_"+b[0][0].get(2)+".csv"); //gemmer tabellen som csv fil
    }
    catch(Exception e) {
      println("Time: "+millis()+" Exception: "+e); //Til hvis noget går galt
      return -1;
    }
    return 0;
  }

  //Loader en level fil fra en .csv fil
  IntList[][] LoadLevelFile(String path) {
    IntList[][] out;
    try {
      Table table = loadTable(path, "header"); //Loader .csv filen ind i en tabel
      out = new IntList[table.getInt(0, "id")][table.getInt(0, "rotation")];

      //tabellen konverteres til et IntList array som kan læses af bane klasen.
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
            if (out[i][j].get(0) == 7 || out[i][j].get(0) == 8) {
              out[i][j].append(table.getInt((i*out[0][0].get(1))+j, "extra"));
            }
          }
        }
      }
    }
    catch(Exception e) {
      println("Time: "+millis()+" Exception: "+e);
      println("Couldn't load and parse level file");
      out = null;
    }
    return out;
  }

  //sørger for at de forskellige foldere og filer, som spillet skal bruge, eksisterer
  void MakeDataFolder(PApplet program) {
    try {
      //Makes data folder
      File directory = new File(sketchPath()+"\\data");
      if (!directory.exists()) {
        directory.mkdir();
      }

      //Laver en custom_levels folder
      directory = new File(sketchPath()+"\\custom_levels");
      if (!directory.exists()) {
        directory.mkdir();
      }

      directory = new File(sketchPath()+"\\data\\levels");
      if (!directory.exists()) {
        directory.mkdir();
      }

      //Laver SQLite filen hvis den ikke existerer
      File tempFile = new File(sketchPath()+"\\data\\hookdb.SQLite");
      if (!tempFile.exists()) {
        tempFile.createNewFile();
        delay(100);
        SQLite db = new SQLite(program, sketchPath()+"\\data\\hookdb.SQLite"); 
        db.connect();
        //Opretter de forskellige tables i sqlite filen
        db.execute("CREATE TABLE [PW] (username text NOT NULL PRIMARY KEY UNIQUE,password text)");
      }
    }
    catch(Exception e) {
      println("Time: "+millis()+" Exception: "+e);
      println("Error in filehandler");
    }
  }
}
