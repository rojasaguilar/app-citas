class Cita {
  int? IDCITA;
  String LUGAR;
  String FECHA;
  String HORA;
  String? ANOTACIONES;
  int IDPERSONA;

  Cita({
    this.IDCITA,
    required this.LUGAR,
    required this.FECHA,
    required this.HORA,
    this.ANOTACIONES,
    required this.IDPERSONA,
  });

  Map<String, dynamic> toJSON() {
    return {
      "IDCITA": this.IDCITA,
      "LUGAR": this.LUGAR,
      "FECHA": this.FECHA,
      "HORA": this.HORA,
      "ANOTACIONES": this.ANOTACIONES,
      "IDPERSONA": this.IDPERSONA,
    };
  }

  factory Cita.fromMap(Map<String, dynamic> map) {
    return Cita(
      IDCITA: map['IDCITA'],
      LUGAR: map['LUGAR'],
      FECHA: map['FECHA'],
      HORA: map['HORA'],
      ANOTACIONES: map['ANOTACIONES'],
      IDPERSONA: map['IDPERSONA'],
    );
  }
}
