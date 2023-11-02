class Materia{
  String IDMateria;
  String Nombre;
  String Semestre;
  String Docente;
  Materia({
    required this.IDMateria,
    required this.Nombre,
    required this.Semestre,
    required this.Docente
  });

  Map<String, dynamic> toJSON(){
    return{
      'IDMateria': IDMateria,
      'Nombre': Nombre,
      'Semestre': Semestre,
      'Docente': Docente,
    };
  }

}