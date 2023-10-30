import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB{
  static Future<Database> _abrirBD() async{
    return openDatabase(
      join(await getDatabasesPath(), "practica1.db"),
      onCreate: (db,version){
        return db.execute(
          "Create table Materia("
              "IDMateria text primary key,"
              "Nombre text,"
              "Semestre text,"
              "Docente text,"
              ")"
        );
      },version: 1);
  }
}