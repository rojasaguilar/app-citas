import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tabasconforanea/basedatosforanea.dart';
import 'package:u3_ejercicio2_tabasconforanea/models/persona.dart';

class Personadetalles extends StatefulWidget {
  final Persona persona;
  final Function onEdit;
  const Personadetalles({
    required this.persona,
    required this.onEdit,
    super.key,
  });

  @override
  State<Personadetalles> createState() => _PersonadetallesState();
}

class _PersonadetallesState extends State<Personadetalles> {
  bool editing = false;
  TextEditingController nombrePersona = TextEditingController();
  TextEditingController telefonoPersona = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nombrePersona.text = widget.persona.NOMBRE;
    telefonoPersona.text = widget.persona.TELEFONO;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        actions: [
          TextButton(
            onPressed: () async {
              if (editing) {
                if (validarInputs()) {
                  Persona personaEditada = Persona(
                    IDPERSONA: widget.persona.IDPERSONA,
                    NOMBRE: nombrePersona.text,
                    TELEFONO: telefonoPersona.text,
                  );

                  DB.actualizarPersona(personaEditada).then((r) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_outlined, color: Colors.green),
                            Text("Persona editada correctamente"),
                          ],
                        ),
                        duration: Duration(milliseconds: 900),
                      ),
                    );
                    widget.persona.NOMBRE = nombrePersona.text;
                    widget.persona.TELEFONO = telefonoPersona.text;
                    widget.onEdit();
                    setState(() {
                      editing = false;
                    });
                  });
                }
              }
              setState(() {
                editing = true;
              });
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
          ? // FIELDS PARA EDITAR
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 50, child: Icon(Icons.face, size: 60)),
                  SizedBox(height: 15),
                  //NOMBRE
                  TextFormField(controller: nombrePersona),
                  SizedBox(height: 35),
                  //NUMERO TELEFONO
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Telefono",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(controller: telefonoPersona),
                    ],
                  ),
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
                                print("si");
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
                            .eliminarPersona(widget.persona.IDPERSONA!)
                            .then((r) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.check_outlined,
                                        color: Colors.green,
                                      ),
                                      Text(
                                        "Persona ELIMINADA de tus contactos",
                                      ),
                                    ],
                                  ),
                                  duration: Duration(milliseconds: 900),
                                ),
                              );
                              setState(() {
                                editing = false;
                                widget.onEdit();
                                Navigator.pop(context);
                              });
                            })
                            .catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.cancel_outlined, color: Colors.red),
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
                    child: Text("Eliminar"),
                  ),
                ],
              ),
            )
          : //NO SE ESTÁ EDITANDO
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 50, child: Icon(Icons.face, size: 60)),
                  SizedBox(height: 15),
                  Center(
                    child: Text(
                      widget.persona.NOMBRE,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Telefono",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.persona.TELEFONO,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  void vaciarInputs() {
    nombrePersona.text = "";
    telefonoPersona.text = "";
  }

  bool validarInputs() {
    if (telefonoPersona.text.isEmpty && nombrePersona.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Llena los campos para poder ingresar una persona"),
        ),
      );
      return false;
    }

    if (telefonoPersona.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("El campo de telefono debe estár lleno")),
      );
      return false;
    }

    if (nombrePersona.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("El campo de nombre debe estár lleno")),
      );
      return false;
    }
    return true;
  }
}
