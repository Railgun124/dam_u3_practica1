import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Materia.dart';

class DB{
  static Future<Database> _abrirBDMateria() async{
    return openDatabase(
      join(await getDatabasesPath(), "practica1.db"),
      onCreate: (db, version) {
        return db.execute(
            "Create table Materia("
                "IDMateria text primary key,"
                "Nombre text,"
                "Semestre text,"
                "Docente text"
                ")"
        );
      },
      version: 1,
    );

  }

  static Future<int> insertarMateria(Materia m) async{
    Database db = await _abrirBDMateria();
    return db.insert("Materia", m.toJSON(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Materia>> mostrarMateria() async{
    Database db = await _abrirBDMateria();

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
    Database db = await _abrirBDMateria();

    return db.update("Materia", m.toJSON(),where: "IDMateria=?", whereArgs: [m.IDMateria]);
  }

  static Future<int> eliminarMateria(String IdMateria) async{
    Database db = await _abrirBDMateria();

    return db.delete("Materia",where: "IDMateria=?", whereArgs: [IdMateria]);
  }

}