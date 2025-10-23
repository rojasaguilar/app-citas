import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tabasconforanea/models/cita.dart';

class Carrucelcitas extends StatefulWidget {
  final List<Cita> citas;
  const Carrucelcitas({required this.citas, super.key});

  @override
  State<Carrucelcitas> createState() => _CarrucelcitasState();
}

class _CarrucelcitasState extends State<Carrucelcitas> {
  @override
  Widget build(BuildContext context) {
    return widget.citas.isEmpty ?
        Row(
          children: [
            Text("No tienes ninguna cita para hoy")
          ],
        ) : SingleChildScrollView(scrollDirection: Axis.horizontal,child: Row(
      children: [
        Container(
          child:  Text("No tienes ninguna cita para hoy"),
        ),
        Container(
          child:  Text("No tienes ninguna cita para hoy"),
        ),
        Container(
          child:  Text("No tienes ninguna cita para hoy"),
        )
      ],
    ),);
  }
}
