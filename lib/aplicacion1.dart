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
  int _index = 0;
  //Editar
  final numTarea =  TextEditingController();
  final descripcion = TextEditingController();
  final materiaId = TextEditingController();
  final fechaEntrega = TextEditingController();
  String? materiaSeleccionada;

  //Capturar
  final numTareaInsert =  TextEditingController();
  final descripcionInsert = TextEditingController();
  final materiaIdInsert = TextEditingController();
  final fechaEntregaInsert = TextEditingController();
  String? materiaSeleccionadaInsert;

  List<Tarea> Tareas = [
    Tarea(
        IDTarea: 1,
        IDMateria: "1",
        F_Entrega: "20/09/23",
        Descripcion: "Tarea 1"),
  ];

  List<Materia> Materias = [
    Materia(
        IDMateria: "1", Nombre: "NoSQL", Semestre: "8", Docente: "Docente1"),
    Materia(
        IDMateria: "2", Nombre: "Moviles", Semestre: "9", Docente: "Docente2")
  ];

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

  void actualizarListaTareas() async {
    List<Tarea> temp = await DB.mostrarTareas();
    setState(() {
      Tareas = temp;
    });
  }

  @override
  void initState() {
    actualizarListaTareas();
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
          return Center(
            child: Text("Incio"),
          );
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
                  ListView(
                    children: [Text("Mostrar todos")],
                  ),
                  //EDITAR
                  ListView(
                    children: [Text("Editar")],
                  ),
                  //AGREGAR
                  ListView(
                    children: [Text("Agregar")],
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
                  Docente: "")); //Buscar el nombre de la materia por IDMateria
          return ListTile(
            leading: CircleAvatar(
              child: Text("${Tareas[indice].IDTarea}"),
            ),
            title: Text(
                "${Tareas[indice].Descripcion} - Materia: ${materia != Materia(IDMateria: "", Nombre: "", Semestre: "", Docente: "") ? materia.Nombre : 'Materia Desconocida'}"),
            subtitle: Text("${Tareas[indice].F_Entrega}"),
            trailing: IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
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
        Text("${materiaIdInsert.text}"),
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
          DB.insertar(
            Tarea(
                IDTarea: int.parse(numTareaInsert.text),
                IDMateria: materiaIdInsert.text,
                F_Entrega: fechaEntregaInsert.text,
                Descripcion: descripcionInsert.text)
          );
          numTareaInsert.clear();
          fechaEntregaInsert.clear();
          materiaIdInsert.clear();
          descripcionInsert.clear();
        }, child: Text("Agregar"))
      ],
    );
  }

  Widget editarTareas() {
    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        TextField(controller: numTarea,
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
        Text("${materiaId.text}"),
        DropdownButton<String>(
          hint: Text("Seleccionar Materia"),
          value: materiaSeleccionada, // Valor actualmente seleccionado
          onChanged: (String? value) {
            setState(() {
              materiaSeleccionada = value; // Actualiza la materia seleccionada
            });
          },
          items: Materias.map((materia) {
            return DropdownMenuItem<String>(
              value:
              materia.Nombre, // Puedes usar el ID de la materia como valor
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

          numTarea.clear();
          fechaEntrega.clear();
          materiaId.clear();
          descripcion.clear();

        }, child: Text("Editar"))
      ],
    );
  }
}
