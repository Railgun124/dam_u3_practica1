import 'package:flutter/material.dart';

class App01 extends StatefulWidget {
  const App01({super.key});

  @override
  State<App01> createState() => _App01State();
}

class _App01State extends State<App01> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Practica 1"),),
      body: dinamico(),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.add),label: "Inicio"),
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
                  Icon(Icons.add),
                  Icon(Icons.add),
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
      case 2:{
        return DefaultTabController(length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: Text("Tareas"),
                bottom: TabBar(tabs: [
                  Icon(Icons.add),
                  Icon(Icons.add),
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
