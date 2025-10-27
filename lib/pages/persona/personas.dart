import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tabasconforanea/basedatosforanea.dart';
import 'package:u3_ejercicio2_tabasconforanea/models/persona.dart';
import 'package:u3_ejercicio2_tabasconforanea/pages/persona/addPersona.dart';
import 'package:u3_ejercicio2_tabasconforanea/pages/persona/personaDetalles.dart';

class Personas extends StatefulWidget {
  const Personas({super.key});

  @override
  State<Personas> createState() => _PersonasState();
}

class _PersonasState extends State<Personas> {
  List<Persona> personas = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenerPersonas();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tus contactos (${personas.length})",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Addpersona(
                        onAdd: () {
                          setState(() {
                            obtenerPersonas();
                          });
                        },
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: personas
                  .map(
                    (persona) => InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Personadetalles(
                              persona: persona,
                              onEdit: () {
                                setState(() {
                                  obtenerPersonas();
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 15,
                          right: 15,
                          bottom: 15,
                        ),
                        decoration: BoxDecoration(),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              child: Icon(Icons.person_2_outlined, size: 32),
                            ),
                            SizedBox(width: 35),
                            Text(
                              persona.NOMBRE,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future obtenerPersonas() async {
    final res = await DB.obtenerPersonas();
    setState(() {
      personas = res;
    });
  }
}
