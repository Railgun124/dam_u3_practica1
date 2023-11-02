import 'package:flutter/material.dart';
import 'BaseDatos.dart';
import 'Materia.dart';
import 'Tarea.dart';

class App01 extends StatefulWidget {
  const App01({super.key});

  @override
  State<App01> createState() => _App01State();
}

class _App01State extends State<App01> {
  List<Materia> Materias=[];
  List<Tarea> Tareas = [];
  int _index = 0;
  //Editar Tareas
  final numTarea =  TextEditingController();
  final descripcion = TextEditingController();
  final materiaId = TextEditingController();
  final fechaEntrega = TextEditingController();
  String? materiaSeleccionada;

  //Capturar Tareas
  final numTareaInsert =  TextEditingController();
  final descripcionInsert = TextEditingController();
  final materiaIdInsert = TextEditingController();
  final fechaEntregaInsert = TextEditingController();
  String? materiaSeleccionadaInsert;

  //Editar Materias
  final idM = TextEditingController();
  final nombreM = TextEditingController();
  final semestre = TextEditingController();
  final docente = TextEditingController();

  //Capturar Materias
  final idMInsert = TextEditingController();
  final nombreMInsert = TextEditingController();
  final semestreInsert = TextEditingController();
  final docenteInsert = TextEditingController();

  Tarea TareaGlb =
      Tarea(IDTarea: 0, IDMateria: "", F_Entrega: "", Descripcion: "");

  DateTime f_entrega = DateTime.now();

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: f_entrega,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != f_entrega) {
      setState(() {
        f_entrega = picked;
        fechaEntrega.text = "${f_entrega.toLocal()}".split(' ')[0];
      });
    }
  }

  void _selectDateInsert(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: f_entrega,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != f_entrega) {
      setState(() {
        f_entrega = picked;
        fechaEntregaInsert.text = "${f_entrega.toLocal()}".split(' ')[0];
      });
    }
  }
  
  void actualizarMaterias() async{
    List<Materia> temp = await DB.mostrarMateria();
    setState(() {
      Materias=temp;
    });
  }
  void actualizarListaTareas() async {
    List<Tarea> temp = await DB.mostrarTareas();
    setState(() {
      Tareas = temp;
    });
  }

  @override
  void initState() {
    actualizarListaTareas();
    actualizarMaterias();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Practica 1"),
      ),
      body: dinamico(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Materias"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Tarea"),
        ],
        currentIndex: _index,
        onTap: (valor) {
          setState(() {
            _index = valor;
          });
        },
      ),
    );
  }

  Widget dinamico() {
    switch (_index) {
      case 0:
        {
          return mostrar();
        }
      case 1:
        {
          return DefaultTabController(
              length: 3,
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
                  itemCount: Materias.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("${Materias[index].Nombre}"),
                      subtitle: Text("${Materias[index].Docente}\n ${Materias[index].Semestre}"),
                      leading: CircleAvatar(
                        child: Text("${index + 1}"),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (builder) {
                              return AlertDialog(
                                title: Text("Seguro que quieres eliminar ${Materias[index].Nombre}"),
                                content: Text(""),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      DB.eliminarMateria(Materias[index].IDMateria).then((value) {
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
                        idM.text = Materias[index].IDMateria;
                        nombreM.text = Materias[index].Nombre;
                        semestre.text = Materias[index].Semestre;
                        docente.text = Materias[index].Docente;
                        DefaultTabController.of(context).animateTo(1);
                      },
                    );
                  },
                ),
                //EDITAR
                ListView(
                  padding: EdgeInsets.all(40),
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
                  padding: EdgeInsets.all(40),
                  children: [
                    TextField(decoration: InputDecoration(
                      labelText: "ID materia:",
                    ),controller: idMInsert,),
                    TextField(decoration: InputDecoration(
                      labelText: "Nombre materia:",
                    ),controller: nombreMInsert,),
                    TextField(decoration: InputDecoration(
                      labelText: "Semestre:",
                    ),controller: semestreInsert,),
                    TextField(decoration: InputDecoration(
                      labelText: "Nombre docente:",
                    ),controller: docenteInsert,),
                    ElevatedButton(onPressed: (){
                      var temporal = Materia(IDMateria: idMInsert.text, Nombre: nombreMInsert.text, Semestre: semestreInsert.text, Docente: docenteInsert.text);
                      DB.insertarMateria(temporal).then((value){
                        setState(() {
                          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Materia Guardada")));
                        });
                      });
                      idMInsert.text = "";
                      nombreMInsert.text = "";
                      semestreInsert.text = "";
                      docenteInsert.text = "";
                      actualizarMaterias();
                    }, child: Text("Guardar"))
                  ],
                ),
              ]),
            ));
        }
      case 2:
        {
          return DefaultTabController(
              length: 3,
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
                  mostrarTareas(),
                  //EDITAR
                  editarTareas(),
                  //AGREGAR
                  capturarTareas(),
                ]),
              ));
        }
      default:
        {
          return Center();
        }
    }
  }

  Widget mostrarTareas() {
    return ListView.builder(
        itemCount: Tareas.length,
        itemBuilder: (context, indice) {
          var materia = Materias.firstWhere(
              (materia) => materia.IDMateria == Tareas[indice].IDMateria,
              orElse: () => Materia(
                  IDMateria: "",
                  Nombre: "",
                  Semestre: "",
                  Docente: ""));
          return ListTile(
            leading: CircleAvatar(
              child: Text("${Tareas[indice].IDTarea}"),
            ),
            title: Text(
                "${Tareas[indice].Descripcion}"),
            subtitle: Text("Materia: ${materia != Materia(IDMateria: "", Nombre: "", Semestre: "", Docente: "") ? materia.Nombre : 'Materia Desconocida'}\nPara el: ${Tareas[indice].F_Entrega}"),
            trailing: IconButton(onPressed: () {
              showDialog(context: context, builder: (builder){
                return AlertDialog(
                  title: Text("Eiminar"),
                  content: Text("¿Seguro que quieres borrar la tarea ´${Tareas[indice].Descripcion}?´"),
                  actions: [
                    OutlinedButton(onPressed: (){
                      DB.eliminarTarea(Tareas[indice].IDTarea).then((value){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Se ha borrado corretamente!")));
                        actualizarListaTareas();
                      });
                      Navigator.pop(context);
                    }, child: Text("Eliminar")),
                    OutlinedButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("Cancelar"))
                  ],
                );
              });
            }, icon: Icon(Icons.delete)),
            onTap: () {
              setState(() {
                TareaGlb = Tareas[indice];
              });
              var materia = Materias.firstWhere(
                      (materia) => materia.IDMateria == TareaGlb.IDMateria,
                  orElse: () => Materia(
                      IDMateria: "",
                      Nombre: "",
                      Semestre: "",
                      Docente: ""));
              numTarea.text = "${TareaGlb.IDTarea}";
              descripcion.text = TareaGlb.Descripcion;
              fechaEntrega.text = TareaGlb.F_Entrega;
              materiaId.text = TareaGlb.IDMateria;
              materiaSeleccionada = "${materia.Nombre}";
              DefaultTabController.of(context).animateTo(1);
            },
          );
        });
  }

  Widget capturarTareas() {
    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        TextField(controller: numTareaInsert,
        decoration: InputDecoration(labelText: "Número de tarea"),keyboardType: TextInputType.number),
        TextFormField(
          readOnly: true,
          controller: fechaEntregaInsert,
          onTap: () {
            _selectDateInsert(context);
          },
          decoration: InputDecoration(
            labelText: 'Fecha',
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                _selectDateInsert(context);
              },
            ),
          ),
        ),
        DropdownButton<String>(
          hint: Text("Seleccionar Materia"),
          value: materiaSeleccionadaInsert, // Valor actualmente seleccionado
          onChanged: (String? value) {
            setState(() {
              materiaSeleccionadaInsert = value; // Actualiza la materia seleccionada
            });
          },
          items: Materias.map((materia) {
            return DropdownMenuItem<String>(
              value:
                  materia.Nombre, // Puedes usar el ID de la materia como valor
              child: Text(materia.Nombre),
              onTap: () {
                setState(() {
                  materiaIdInsert.text = materia.IDMateria;
                });
              },
            );
          }).toList(),
        ),
        TextField(
          controller: descripcionInsert,
          decoration: InputDecoration(labelText: "Descripcion"),
        ),
        SizedBox(height: 30),
        ElevatedButton(onPressed: (){
          DB.insertarTarea(
            Tarea(
                IDTarea: int.parse(numTareaInsert.text),
                IDMateria: materiaIdInsert.text,
                F_Entrega: fechaEntregaInsert.text,
                Descripcion: descripcionInsert.text)
          ).then((value) => actualizarListaTareas());
          numTareaInsert.clear();
          fechaEntregaInsert.clear();
          materiaIdInsert.clear();
          descripcionInsert.clear();
          materiaSeleccionadaInsert = null;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Añadido Exitosamente!")));
        }, child: Text("Agregar"))
      ],
    );
  }

  Widget editarTareas() {
    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        TextField(controller: numTarea,
            enabled: false,
            decoration: InputDecoration(labelText: "Número de tarea"),keyboardType: TextInputType.number),
        TextFormField(
          readOnly: true,
          controller: fechaEntrega,
          onTap: () {
            _selectDate(context);
          },
          decoration: InputDecoration(
            labelText: 'Fecha',
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                _selectDate(context);
              },
            ),
          ),
        ),
        DropdownButton<String>(
          hint: Text("Seleccionar Materia"),
          value: materiaSeleccionada,
          onChanged: (String? value) {
            setState(() {
              materiaSeleccionada = value;
            });
          },
          items: Materias.map((materia) {
            return DropdownMenuItem<String>(
              value:
              materia.Nombre,
              child: Text(materia.Nombre),
              onTap: () {
                setState(() {
                  materiaId.text = materia.IDMateria;
                });
              },
            );
          }).toList(),
        ),
        TextField(
          controller: descripcion,
          decoration: InputDecoration(labelText: "Descripcion"),
        ),
        SizedBox(height: 30),
        ElevatedButton(onPressed: (){
          DB.actualizarTarea(
            Tarea(IDTarea: int.parse(numTarea.text), IDMateria: materiaId.text, F_Entrega: fechaEntrega.text, Descripcion: descripcion.text)
          ).then((value) => actualizarListaTareas());
          numTarea.clear();
          fechaEntrega.clear();
          materiaId.clear();
          descripcion.clear();
          materiaSeleccionada=null;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Editado Exitosamente!")));

        }, child: Text("Editar"))
      ],
    );
  }

  Widget mostrar(){
    return ListView.builder(
        itemCount: Tareas.length,
        itemBuilder: (context, indice) {
          var materia = Materias.firstWhere(
                  (materia) => materia.IDMateria == Tareas[indice].IDMateria,
              orElse: () => Materia(
                  IDMateria: "",
                  Nombre: "",
                  Semestre: "",
                  Docente: ""));
          return ListTile(
            leading: CircleAvatar(
              child: Text("${Tareas[indice].IDTarea}"),
            ),
            title: Text(
                "${Tareas[indice].Descripcion}"),
            subtitle: Text("Materia: ${materia != Materia(IDMateria: "", Nombre: "", Semestre: "", Docente: "") ? materia.Nombre : 'Materia Desconocida'}\nPara el: ${Tareas[indice].F_Entrega}"),
            trailing: IconButton(onPressed: () {
              showDialog(context: context, builder: (builder){
                return AlertDialog(
                  title: Text("Eiminar"),
                  content: Text("¿Seguro que quieres borrar la tarea ´${Tareas[indice].Descripcion}?´"),
                  actions: [
                    OutlinedButton(onPressed: (){
                      DB.eliminarTarea(Tareas[indice].IDTarea).then((value){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Se ha borrado corretamente!")));
                        actualizarListaTareas();
                      });
                      Navigator.pop(context);
                    }, child: Text("Eliminar")),
                    OutlinedButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("Cancelar"))
                  ],
                );
              });
            }, icon: Icon(Icons.delete)),
            onTap: () {
              setState(() {
                TareaGlb = Tareas[indice];
                _index = 2;
              });
              var materia = Materias.firstWhere(
                      (materia) => materia.IDMateria == TareaGlb.IDMateria,
                  orElse: () => Materia(
                      IDMateria: "",
                      Nombre: "",
                      Semestre: "",
                      Docente: ""));
              numTarea.text = "${TareaGlb.IDTarea}";
              descripcion.text = TareaGlb.Descripcion;
              fechaEntrega.text = TareaGlb.F_Entrega;
              materiaId.text = TareaGlb.IDMateria;
              materiaSeleccionada = "${materia.Nombre}";
            },
          );
        });
  }
}
