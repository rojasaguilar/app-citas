class Persona {
  int? IDPERSONA;
  String NOMBRE;
  String TELEFONO;

  Persona({this.IDPERSONA, required this.NOMBRE, required this.TELEFONO});

  Map<String, dynamic> toJSON() {
    return {
      "IDPERSONA": this.IDPERSONA,
      "NOMBRE": this.NOMBRE,
      "TELEFONO": this.TELEFONO,
    };
  }

  factory Persona.fromMap(Map<String, dynamic> map) {
    return Persona(
      IDPERSONA: map['IDPERSONA'],
      NOMBRE: map['NOMBRE'],
      TELEFONO: map['TELEFONO'],
    );
  }
}
