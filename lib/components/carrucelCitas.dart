import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tabasconforanea/pages/cita/datosCita.dart';
import 'package:u3_ejercicio2_tabasconforanea/basedatosforanea.dart';

class Carrucelcitas extends StatefulWidget {
  const Carrucelcitas({ super.key});

  @override
  State<Carrucelcitas> createState() => _CarrucelcitasState();
}

class _CarrucelcitasState extends State<Carrucelcitas> {
  List<Map<String, dynamic>> citas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    actualizarCitas();
  }

  @override
  Widget build(BuildContext context) {
    return citas.isEmpty
        ? const Text("No tienes citas agendadas para hoy")
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tus citas: (${citas.length})"),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: citas.length,
                  itemBuilder: (context, index) {
                    final cita = citas[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Datoscita(onEdit: (){
                         setState(() {
                           actualizarCitas();
                         });
                        }, cita: cita)));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Columna izquierda
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cita['HORA'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(cita['FECHA'] ?? ''),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          cita['LUGAR'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Columna derecha
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  cita['NOMBRE']?.isNotEmpty == true
                                      ? cita['NOMBRE']
                                      : 'Sin nombre',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
  }

  void actualizarCitas() async {
    final List<Map<String, dynamic>> citasTemp = await DB.obtenerCitas2();
    setState(() {
      citas = citasTemp;
    });
  }
}
