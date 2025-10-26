import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tabasconforanea/basedatosforanea.dart';
import 'package:u3_ejercicio2_tabasconforanea/models/persona.dart';

class Addpersona extends StatefulWidget {
  const Addpersona({super.key});

  @override
  State<Addpersona> createState() => _AddpersonaState();
}

class _AddpersonaState extends State<Addpersona> {
  TextEditingController nombrePersona = TextEditingController();
  TextEditingController telefonoPersona = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agrega un nuevo contacto")),
      body: SizedBox.expand(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //AGREGA CONTACTO
              Column(
                children: [
                  CircleAvatar(radius: 60, child: Icon(Icons.person, size: 90)),
                  SizedBox(height: 10),
                  Text(
                    "Agrega un nuevo contacto",
                    style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                  ),
                ],
              ),

              //NOMBRE
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nombre del contacto", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: nombrePersona,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ],
              ),

              //TELEFONO
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Número de telefono", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: telefonoPersona,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ],
              ),

              //BOTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!validarInputs()) return;
                    Persona p = Persona(
                      NOMBRE: nombrePersona.text,
                      TELEFONO: telefonoPersona.text,
                    );
                    DB.insertarPersona(p).then((r) {
                      vaciarInputs();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_outlined, color: Colors.green),
                              Text("Persona agregada a tus contactos"),
                            ],
                          ),
                          duration: Duration(milliseconds: 900),
                        ),
                      );
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    "Agregar contacto",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
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
