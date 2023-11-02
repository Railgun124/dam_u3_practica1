class Tarea{
  int IDTarea;
  String IDMateria;
  String F_Entrega;
  String Descripcion;
  Tarea({
    required this.IDTarea,
    required this.IDMateria,
    required this.F_Entrega,
    required this.Descripcion
});
  Map<String,dynamic> toJSON(){
    return {
      "IDTarea":IDTarea,
      "IDMateria":IDMateria,
      "F_Entrega":F_Entrega,
      "Descripcion":Descripcion,
    };
  }
}