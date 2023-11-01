import 'package:flutter/material.dart';
import 'package:dam_u3_practica1/Materia.dart';

import 'BaseDatos.dart';

class App01 extends StatefulWidget {
  const App01({super.key});

  @override
  State<App01> createState() => _App01State();
}

class _App01State extends State<App01> {
  List<Materia> materias=[];
  int _index = 0;
  final idM = TextEditingController();
  final nombreM = TextEditingController();
  final semestre = TextEditingController();
  final docente = TextEditingController();
  void actualizarMaterias() async{
    List<Materia> temp = await DB.mostrarMateria();
    setState(() {
      materias=temp;
    });
  }
  @override
  void initState(){
    actualizarMaterias();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Practica 1"),),
      body: dinamico(),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.list),label: "Inicio"),
        BottomNavigationBarItem(icon: Icon(Icons.add),label: "Materias"),
        BottomNavigationBarItem(icon: Icon(Icons.add),label: "Tarea"),
      ],
        currentIndex: _index,
        onTap: (valor){
        setState(() {
          _index=valor;
        });
        },
      ),
    );
  }

  Widget dinamico(){
    switch(_index){
      case 0:{
        return Center(child: Text("Incio"),);
      }
      case 1:{
        return DefaultTabController(length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: Text("Materias"),
                bottom: TabBar(tabs: [
                  Icon(Icons.list),
                  Icon(Icons.edit),
                  Icon(Icons.add)
                ]),
              ),
              body: TabBarView(children: [
                //MOSTRAR TODOS
                ListView.builder(
                  itemCount: materias.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("${materias[index].Nombre}"),
                      subtitle: Text("${materias[index].Docente}\n ${materias[index].Semestre}"),
                      leading: CircleAvatar(
                        child: Text("${index + 1}"),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (builder) {
                              return AlertDialog(
                                title: Text("Seguro que quieres eliminar ${materias[index].Nombre}"),
                                content: Text(""),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      DB.eliminarMateria(materias[index].IDMateria).then((value) {
                                        setState(() {
                                          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Se eliminó la materia ${materias[index].Nombre}")));
                                        });
                                        actualizarMaterias();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("Aceptar"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancelar"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                      onTap: () {
                        idM.text = materias[index].IDMateria;
                        nombreM.text = materias[index].Nombre;
                        semestre.text = materias[index].Semestre;
                        docente.text = materias[index].Docente;
                      },
                    );
                  },
                ),
                //EDITAR
                ListView(
                  children: [
                    TextField(enabled:false,decoration: InputDecoration(
                      labelText: "ID materia:",
                    ),controller: idM,),
                    TextField(decoration: InputDecoration(
                      labelText: "Nombre materia:",
                    ),controller: nombreM,),
                    TextField(decoration: InputDecoration(
                      labelText: "Semestre:",
                    ),controller: semestre,),
                    TextField(decoration: InputDecoration(
                      labelText: "Nombre docente:",
                    ),controller: docente,),
                    ElevatedButton(onPressed: (){
                      var temporal = Materia(IDMateria: idM.text, Nombre: nombreM.text, Semestre: semestre.text, Docente: docente.text);
                      DB.actualizarMateria(temporal).then((value){
                        setState(() {
                          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Materia Guardada")));
                        });
                      });
                      idM.text = "";
                      nombreM.text = "";
                      semestre.text = "";
                      docente.text = "";
                      actualizarMaterias();
                    }, child: Text("Guardar"))
                  ],
                ),
                //AGREGAR
                ListView(
                  children: [
                    TextField(decoration: InputDecoration(
                      labelText: "ID materia:",
                    ),controller: idM,),
                    TextField(decoration: InputDecoration(
                      labelText: "Nombre materia:",
                    ),controller: nombreM,),
                    TextField(decoration: InputDecoration(
                      labelText: "Semestre:",
                    ),controller: semestre,),
                    TextField(decoration: InputDecoration(
                      labelText: "Nombre docente:",
                    ),controller: docente,),
                    ElevatedButton(onPressed: (){
                      var temporal = Materia(IDMateria: idM.text, Nombre: nombreM.text, Semestre: semestre.text, Docente: docente.text);
                      DB.insertarMateria(temporal).then((value){
                        setState(() {
                          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Materia Guardada")));
                        });
                      });
                      idM.text = "";
                      nombreM.text = "";
                      semestre.text = "";
                      docente.text = "";
                      actualizarMaterias();
                    }, child: Text("Guardar"))
                  ],
                ),
              ]),
            ));
      }
      case 2:{
        return DefaultTabController(length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: Text("Tareas"),
                bottom: TabBar(tabs: [
                  Icon(Icons.list),
                  Icon(Icons.edit),
                  Icon(Icons.add)
                ]),
              ),
              body: TabBarView(children: [
                //MOSTRAR TODOS
                ListView(
                  children: [
                    Text("Mostrar todos")
                  ],
                ),
                //EDITAR
                ListView(
                  children: [
                    Text("Editar")
                  ],
                ),
                //AGREGAR
                ListView(
                  children: [
                    Text("Agregar")
                  ],
                ),
              ]),
            ));
      }
      default:{
        return Center();
      }
    }
  }

}
