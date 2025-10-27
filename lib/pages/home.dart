import 'package:flutter/material.dart';

import 'package:u3_ejercicio2_tabasconforanea/components/carrucelCitas.dart';
import 'package:u3_ejercicio2_tabasconforanea/pages/cita/addCita.dart';
import 'package:u3_ejercicio2_tabasconforanea/pages/persona/addPersona.dart';
import 'package:u3_ejercicio2_tabasconforanea/pages/pageItem.dart';
import 'package:u3_ejercicio2_tabasconforanea/pages/persona/personas.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;
  late List<PageItem> pages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages = [
      PageItem(
        title: "Tus citas",
        page: Carrucelcitas(
        ),
      ),
      PageItem(
        title: "Agendar citas",
        page: Addcita(
          navigateToHome: () {
            setState(() {
              _index = 0;
            });
          },
        ),
      ),
      PageItem(title: "Persona", page: Personas()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pages[_index].title)),
      body: pages[_index].page,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Citas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart_sharp),
            label: "Agendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face_2_outlined),
            label: "Contactos",
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (x) {
          setState(() {
            _index = x;
          });
        },
      ),
    );
  }
}
