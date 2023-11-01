import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Tarea.dart';

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
              ");"
              "Create table Tarea("
              "IDTarea text primary key,"
              "IDMateria text,"
              "F_entrega text,"
              "Descripcion text,"
              "CONSTRAINT FK_TAREA_MATERIA FOREIGN KEY (IDMateria) REFERENCES Materia(IDMateria)"
              ");"
        );
      },version: 1);
  }
  static Future<int> insertar(Tarea t) async{
    Database db = await _abrirBD();
    return db.insert("Tarea", t.toJSON(),conflictAlgorithm: ConflictAlgorithm.replace);
  }
  static Future<int> actualizar(Tarea t) async{
    Database db = await _abrirBD();
    return db.update("Tarea", t.toJSON(),where: "IDTarea = ?",whereArgs: [t.IDTarea]);
  }

  static Future<int> eliminar(int tarea) async{
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
}