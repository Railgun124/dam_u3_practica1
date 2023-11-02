import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Materia.dart';
import 'Tarea.dart';

class DB{

  static Future<Database> _abrirBD() async{
    return openDatabase(
      join(await getDatabasesPath(), "practica12.db"),
      onCreate: (db,version){
        return batchCreateTables(db);
      },version: 1);

  }
  static Future<void> batchCreateTables(Database db) async {
    await db.execute(
        "CREATE TABLE Materia ("
            "IDMateria text primary key,"
            "Nombre TEXT,"
            "Semestre TEXT,"
            "Docente TEXT"
            ")");
    await db.execute(
        "CREATE TABLE Tarea ("
            "IDTarea INTEGER PRIMARY KEY,"
            "IDMateria TEXT,"
            "F_Entrega TEXT,"
            "Descripcion TEXT,"
        "CONSTRAINT FK_TAREA_MATERIA FOREIGN KEY (IDMateria) REFERENCES Materia(IDMateria)"
            ")");
  }
  static Future<int> insertarTarea(Tarea t) async{
    Database db = await _abrirBD();
    return db.insert("Tarea", t.toJSON(),conflictAlgorithm: ConflictAlgorithm.replace);
  }
  static Future<int> actualizarTarea(Tarea t) async{
    Database db = await _abrirBD();
    return db.update("Tarea", t.toJSON(),where: "IDTarea = ?",whereArgs: [t.IDTarea]);
  }

  static Future<int> eliminarTarea(int tarea) async{
    Database db = await _abrirBD();
    return db.delete("Tarea",where: "IDTarea = ?",whereArgs: [tarea]);
  }
  static Future<List<Tarea>> mostrarTareas() async{
    Database db = await _abrirBD();
    List<Map<String,dynamic>> resultado = await db.query("Tarea");
    return List.generate(resultado.length, (index){
      return Tarea(
          IDTarea: resultado[index]['IDTarea'],
          IDMateria: resultado[index]['IDMateria'],
          F_Entrega: resultado[index]['F_Entrega'],
          Descripcion: resultado[index]['Descripcion']);
    });
  }
  static Future<int> insertarMateria(Materia m) async{
    Database db = await _abrirBD();
    return db.insert("Materia", m.toJSON(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Materia>> mostrarMateria() async{
    Database db = await _abrirBD();

    List<Map<String,dynamic>> resultado = await db.query("Materia");

    return List.generate(resultado.length, (index){
      return Materia(
          IDMateria: resultado[index]['IDMateria'],
          Nombre: resultado[index]['Nombre'],
          Semestre: resultado[index]['Semestre'],
          Docente: resultado[index]['Docente']);
    });
  }

  static Future<int> actualizarMateria(Materia m) async{
    Database db = await _abrirBD();

    return db.update("Materia", m.toJSON(),where: "IDMateria=?", whereArgs: [m.IDMateria]);
  }

  static Future<int> eliminarMateria(String IdMateria) async{
    Database db = await _abrirBD();

    return db.delete("Materia",where: "IDMateria=?", whereArgs: [IdMateria]);
  }
}