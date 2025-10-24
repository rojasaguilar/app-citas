import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tabasconforanea/basedatosforanea.dart';
import 'package:u3_ejercicio2_tabasconforanea/components/carrucelCitas.dart';
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

  List<Map<String,dynamic>> citas = [];
  int _index = 0;
  late List<PageItem> pages;
  Map<String,dynamic> citaSeleccionada = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages = [
      PageItem(title: "Tus citas", page: Carrucelcitas(citas: citas, onS: (x){
        print(x);
        citaSeleccionada = x;
        _index = 3;
      },)),
      PageItem(title: "Agendar citas", page: Addcita(navigateToHome: (){
        setState(() {
          _index = 0;
          actualizarCitas();
        });
      },)),
      PageItem(title: "Agregar persona", page: Addpersona(navigateToHome: (){
        setState(() {

          _index = 0;
        });
      },)),
      PageItem(title: "Datos de la cita", page: Datoscita(cita: citaSeleccionada,)),
    ];
    actualizarCitas();
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
            citaSeleccionada = {};
          });
        },
      ),
    );
  }

  void actualizarCitas() async {
    final List<Map<String,dynamic>> citasTemp = await DB.obtenerCitas2();
    setState(() {
      citas = citasTemp;
      pages[0] = PageItem(title: "Tus citas", page: Carrucelcitas(citas: citas, onS: (x){
        setState(() {
          print(x);
          citaSeleccionada = x;
          _index = 3;
          pages[3] = PageItem(title: "Datos de la cita", page: Datoscita(cita: citaSeleccionada,));
        });
      },));
    });
  }
}
