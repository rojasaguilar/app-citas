import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tabasconforanea/basedatosforanea.dart';
import 'package:u3_ejercicio2_tabasconforanea/components/gridHours.dart';
import 'package:u3_ejercicio2_tabasconforanea/models/persona.dart';

class Addcita extends StatefulWidget {
  const Addcita({super.key});

  @override
  State<Addcita> createState() => _AddcitaState();
}

class _AddcitaState extends State<Addcita> {
  List<Persona> personas = [];

  int? personaSeleccionada;
  String? fechaSeleccionada;
  String horaSeleccionada = "";
  TextEditingController lugarController = TextEditingController();
  TextEditingController anotacionesController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    llenarListaPersonas();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        //PERSONA
        DropdownButton<int>(
          hint: Text("Selecciona una persona"),
          value: personaSeleccionada,
          items: personas.asMap().entries.map((entry) {
            int index = entry.key;
            var persona = entry.value;
            return DropdownMenuItem<int>(
              value: index,
              child: Text(persona.NOMBRE),
            );
          }).toList(),
          onChanged: (x) {
            setState(() {
              personaSeleccionada = x;
            });
          },
        ),
        //FECHA
        CalendarDatePicker(
          initialDate: DateTime.timestamp(),
          firstDate: DateTime.timestamp(),
          lastDate: DateTime(2026, 1, 31),
          onDateChanged: (x) {
            setState(() {
              fechaSeleccionada = DateTime(
                x.year,
                x.month,
                x.day,
              ).toString().substring(0, 10);
            });
          },
        ),

        //HORA
        SizedBox(
          child: Gridhours(
            setHour: (String hour) {
              setState(() {
                horaSeleccionada = hour;
                print(horaSeleccionada);
              });
            },
          ),
        ),

        //LUGAR
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Lugar de la cita"),
            SizedBox(height: 5),
            TextField(
              controller: lugarController,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ],
        ),

        //ANOTACIONES
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Notas"),
            SizedBox(height: 5),
            TextField(
              controller: anotacionesController,
              decoration: InputDecoration(border: OutlineInputBorder()),
              minLines: 3,
              maxLines: 5,
            ),
          ],
        ),

        //AGREGAR
        FilledButton(onPressed: (){}, child: Text("Agendar cita"))
      ],
    );
  }

  void llenarListaPersonas() async {
    DB.obtenerPersonas().then((lista) {
      setState(() {
        personas = lista;
      });
    });
  }

  void vaciarInputs() {
    lugarController.text = "";
    // telefonoPersona.text = "";
  }

  // bool validarInputs() {
  //   if (telefonoPersona.text.isEmpty && nombrePersona.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Llena los campos para poder ingresar una persona"),
  //       ),
  //     );
  //     return false;
  //   }
  //
  //   if (telefonoPersona.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("El campo de telefono debe estár lleno")),
  //     );
  //     return false;
  //   }
  //
  //   if (nombrePersona.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("El campo de nombre debe estár lleno")),
  //     );
  //     return false;
  //   }
  //   return true;
  // }
}
