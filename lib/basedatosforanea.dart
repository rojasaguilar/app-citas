import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:u3_ejercicio2_tabasconforanea/models/persona.dart';
import 'package:u3_ejercicio2_tabasconforanea/models/cita.dart';

class DB {
  static Future<Database> _conectarDB() async {
    return openDatabase(
      join(await getDatabasesPath(), "ejercicio2.db"),
      version: 1,
      onConfigure: (db) => db.execute("PRAGMA foreign_key = ON"),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE PERSONA"
          "(IDPERSONA INTEGER PRIMARY KEY AUTOINCREMENT,"
          " NOMBRE TEXT,"
          " TELEFONO TEXT)",
        );
        await db.execute(
          "CREATE TABLE CITA("
          "IDCITA INTEGER PRIMARY KEY AUTOINCREMENT,"
          " LUGAR TEXT,"
          " FECHA TEXT,"
          " HORA TEXT,"
          " ANOTACIONES TEXT,"
          " IDPERSONA INTEGER,"
          " FOREIGN KEY (IDPERSONA) REFERENCES PERSONA(IDPERSONA)"
          " ON DELETE CASCADE ON UPDATE CASCADE)",
        );
      },
    );
  }

  static Future<int> insertarPersona(Persona p) async {
    Database db = await _conectarDB();
    return db.insert("PERSONA", p.toJSON()..remove("IDPERSONA"));
  }

  static Future<int> insertarCita(Cita c) async {
    Database db = await _conectarDB();
    return db.insert("CITA", c.toJSON()..remove("IDCITA"));
  }

  static Future<List<Persona>> obtenerPersonas() async {
    Database db = await _conectarDB();

    final List<Map<String, dynamic>> personasMap = await db.query('PERSONA');

    return personasMap.map((persona) => Persona.fromMap(persona)).toList();
  }

  static Future<List<Cita>> obtenerCitas() async {
    List<Cita> citas = [];
    Database db = await _conectarDB();

    final List<Map<String, dynamic>> citasMap = await db.query('CITA');
    citasMap.forEach((cita) => citas.add(Cita.fromMap(cita)));

    return citas;
  }

  static Future<List<Map<String,dynamic>>> obtenerCitas2() async {
    Database db = await _conectarDB();

    final List<Map<String, dynamic>> citasMap =
    await db.rawQuery('SELECT C.IDCITA, C.LUGAR, C.FECHA, C.HORA, C.ANOTACIONES, '
        'P.NOMBRE FROM CITA C INNER JOIN PERSONA P ON (P.IDPERSONA = C.IDPERSONA)');

    print(citasMap);
    return citasMap;
  }
}
