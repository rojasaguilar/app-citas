import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tabasconforanea/basedatosforanea.dart';
import 'package:u3_ejercicio2_tabasconforanea/components/carrucelCitas.dart';
import 'package:u3_ejercicio2_tabasconforanea/models/cita.dart';
import 'package:u3_ejercicio2_tabasconforanea/pages/addCita.dart';
import 'package:u3_ejercicio2_tabasconforanea/pages/addPersona.dart';
import 'package:u3_ejercicio2_tabasconforanea/pages/datosCita.dart';
import 'package:u3_ejercicio2_tabasconforanea/pages/pageItem.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Cita> citas = [];
  int _index = 0;
  late List<PageItem> pages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    actualizarCitas();
    pages = [
      PageItem(title: "Tus citas", page: Carrucelcitas(citas: citas)),
      PageItem(title: "Agendar citas", page: Addcita()),
      PageItem(title: "Agregar persona", page: Addpersona()),
      PageItem(title: "Datos de la cita", page: Datoscita()),
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
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart_sharp),
            label: "Nueva cita",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_reaction_outlined),
            label: "Nueva persona",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: "Cita",
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

  void actualizarCitas() async {
    final List<Cita> citasTemp = await DB.obtenerCitas();
    setState(() {
      citas = citasTemp;
    });
  }
}
