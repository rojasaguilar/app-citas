import 'package:flutter/material.dart';

class Datoscita extends StatefulWidget {
  final Map<String,dynamic> cita;
  const Datoscita({required this.cita, super.key});

  @override
  State<Datoscita> createState() => _DatoscitaState();
}

class _DatoscitaState extends State<Datoscita> {
  @override
  Widget build(BuildContext context) {
    return widget.cita.isEmpty?
        Center(child: Text("Selecciona una cita para ver sus detalles"),) :
        Center(child: Text(widget.cita['NOMBRE']??""),);
  }
}
