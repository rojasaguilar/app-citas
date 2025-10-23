import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tabasconforanea/basedatosforanea.dart';
import 'package:u3_ejercicio2_tabasconforanea/components/gridHours.dart';
import 'package:u3_ejercicio2_tabasconforanea/models/cita.dart';
import 'package:u3_ejercicio2_tabasconforanea/models/persona.dart';

class Addcita extends StatefulWidget {
  final Function() navigateToHome;
  const Addcita({required this.navigateToHome, super.key});

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
            var persona = entry.value;
            int index = persona.IDPERSONA!;
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
        FilledButton(
          onPressed: () {
            if (!validarInputs()) return;
            DB
                .insertarCita(
                  Cita(
                    LUGAR: lugarController.text,
                    FECHA: fechaSeleccionada!,
                    HORA: horaSeleccionada,
                    ANOTACIONES: anotacionesController.text,
                    IDPERSONA: personaSeleccionada!,
                  ),
                )
                .then((r) {
                  if (r > 0) {
                    print(r);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_outlined, color: Colors.green),
                            SizedBox(width: 3),
                            Text(
                              "Cita agendada correctamente",
                            ),
                          ],
                        ),
                      ),
                    );
                    vaciarInputs();
                    widget.navigateToHome();
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.cancel_outlined, color: Colors.redAccent),
                          SizedBox(width: 3),
                          Text(
                            "Error al agendar cita",
                          ),
                        ],
                      ),
                    ),
                  );
                  return;
                });
          },
          child: Text("Agendar cita"),
        ),
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
    anotacionesController.text = "";
  }

  bool validarInputs() {
    if (personaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Debes seleccionar una persona con la que agendarás la cita",
          ),
        ),
      );
      return false;
    }

    if (fechaSeleccionada!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Debes seleccionar una fecha")));
      return false;
    }

    if (horaSeleccionada.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Debes seleccionar una hora")));
      return false;
    }

    if (lugarController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Debes indicar un lugar para la cita")),
      );
      return false;
    }
    return true;
  }
}
