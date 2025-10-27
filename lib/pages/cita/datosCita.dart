import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tabasconforanea/basedatosforanea.dart';
import 'package:u3_ejercicio2_tabasconforanea/components/gridHours.dart';
import 'package:u3_ejercicio2_tabasconforanea/models/cita.dart';
import 'package:u3_ejercicio2_tabasconforanea/models/persona.dart';

class Datoscita extends StatefulWidget {
  final Map<String, dynamic> cita;
  final Function onEdit;

  const Datoscita({required this.onEdit, required this.cita, super.key});

  @override
  State<Datoscita> createState() => _DatoscitaState();
}

class _DatoscitaState extends State<Datoscita> {
  Map<String, dynamic> citaLocal = {};
  bool editing = false;
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

    citaLocal = Map<String, dynamic>.from(widget.cita);
    personaSeleccionada = citaLocal['IDPERSONA'];
    fechaSeleccionada = citaLocal['FECHA'];
    horaSeleccionada = citaLocal['HORA'];
    lugarController.text = citaLocal['LUGAR'];
    anotacionesController.text = citaLocal['ANOTACIONES'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              if (editing) {
                if (!validarInputs()) return;

                DB
                    .actualizarCita(
                      Cita(
                        IDCITA: citaLocal['IDCITA'],
                        LUGAR: lugarController.text,
                        FECHA: fechaSeleccionada!,
                        HORA: horaSeleccionada,
                        ANOTACIONES: anotacionesController.text,
                        IDPERSONA: personaSeleccionada!,
                      ),
                    )
                    .then((r) {
                      if (r > 0) {
                        obtenerNuevosDatos(widget.cita['IDCITA']);
                        setState(() {
                          editing = false;
                        });
                        widget.onEdit();
                      }
                    })
                    .catchError(
                      (error) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error al actualizar la cita")),
                      ),
                    );
              } else {
                setState(() {
                  editing = true;
                });
              }
            },
            child: editing
                ? Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.indigo[300],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(Icons.check_outlined),
                  )
                : Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.indigo[300],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      "Editar",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: editing
          ? ListView(
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
                    initHour: citaLocal['HORA'],
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

                //ELIMINAR CITA
                FilledButton(
                  onPressed: () async {
                    final confirma = await showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("Eliminar?"),
                        content: Text(
                          "Seguro que quieres eliminar a esta persona de tus contactos? "
                          "Todas tus citas con esta persona también se elminiarán",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text("Eliminar"),
                          ),
                        ],
                      ),
                    );

                    if (confirma) {
                      DB
                          .eliminarCita(widget.cita['IDCITA'])
                          .then((r) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.check_outlined,
                                      color: Colors.green,
                                    ),
                                    Text("cita ELIMINADA de tu agenda"),
                                  ],
                                ),
                                duration: Duration(milliseconds: 900),
                              ),
                            );
                            setState(() {
                              widget.onEdit();
                              editing = false;
                              Navigator.pop(context);
                            });
                          })
                          .catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "No se pudo eliminar a la persona de tus contactos. Intenta más tarde",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                duration: const Duration(milliseconds: 900),
                              ),
                            );
                          });
                      return;
                    }
                  },
                  child: Text("Eliminar cita"),
                ),
              ],
            )
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Cita con ${citaLocal['NOMBRE']}",
                    style: TextStyle(fontSize: 32),
                    // overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 15),

                  //FECHA Y PERSONA CON QUIEN ES LA CITA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //FECHA
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black87),
                        ),
                        child: Text(citaLocal['FECHA']),
                      ),

                      //PERSONA
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: CircleAvatar(child: Icon(Icons.face)),
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                citaLocal['NOMBRE'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.1,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  //NOTAS
                  Text(
                    (citaLocal['ANOTACIONES']?.isEmpty ?? true)
                        ? "Sin anotaciones"
                        : citaLocal['ANOTACIONES'],
                    style: TextStyle(color: Colors.black54),
                  ),

                  SizedBox(height: 15),

                  //UBICACIÓN
                  Row(
                    children: [
                      CircleAvatar(child: Icon(Icons.location_on_outlined)),
                      SizedBox(width: 8),
                      Text(citaLocal['LUGAR'], style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(height: 25),
                  //HORA
                  Row(
                    children: [
                      CircleAvatar(child: Icon(Icons.timer_outlined)),
                      SizedBox(width: 8),
                      Text(citaLocal['HORA'], style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ],
              ),
            ),
    );
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

  void obtenerNuevosDatos(int id) async {
    final map = await DB.vistaCita(id);
    setState(() {
      citaLocal = map;
    });
  }

  void llenarListaPersonas() async {
    DB.obtenerPersonas().then((lista) {
      setState(() {
        personas = lista;
      });
    });
  }
}
