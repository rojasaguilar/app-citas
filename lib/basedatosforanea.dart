import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:u3_ejercicio2_tabasconforanea/models/persona.dart';
import 'package:u3_ejercicio2_tabasconforanea/models/cita.dart';

class DB {
  static Future<Database> _conectarDB() async {
    return openDatabase(
      join(await getDatabasesPath(), "ejercicio2_3.db"),
      version: 1,
      onConfigure: (db) async => await db.execute("PRAGMA foreign_keys = ON"),
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

  static Future<List<Map<String, dynamic>>> obtenerCitas2() async {
    Database db = await _conectarDB();

    final List<Map<String, dynamic>> citasMap = await db.rawQuery(
      'SELECT C.IDCITA, C.LUGAR, C.FECHA, C.HORA, C.ANOTACIONES, '
      'P.NOMBRE, P.IDPERSONA FROM CITA C INNER JOIN PERSONA P ON (P.IDPERSONA = C.IDPERSONA)',
    );

    print(citasMap);
    return citasMap;
  }

  static Future<Map<String, dynamic>> vistaCita(int id) async {
    Database db = await _conectarDB();

    final List<Map<String, dynamic>> citasMap = await db.rawQuery(
      'SELECT C.IDCITA, C.LUGAR, C.FECHA, C.HORA, C.ANOTACIONES, '
          'P.NOMBRE, P.IDPERSONA FROM CITA C INNER JOIN PERSONA P ON (P.IDPERSONA = C.IDPERSONA)'
          'WHERE IDCITA = ?', [id]
    );

    print(citasMap[0]);
    return citasMap[0];
  }

  static Future<int> actualizarPersona(Persona p) async {
    Database db = await _conectarDB();
    final result = await db.rawUpdate(
      'UPDATE PERSONA '
      'SET NOMBRE = ?, TELEFONO = ?  WHERE IDPERSONA = ?',
      [p.NOMBRE, p.TELEFONO, p.IDPERSONA],
    );
    return result;
  }

  static Future<int> actualizarCita(Cita c) async {
    Database db = await _conectarDB();
    final result = await db.rawUpdate(
      'UPDATE CITA '
          'SET LUGAR = ?, FECHA = ?, HORA = ?, ANOTACIONES = ?, IDPERSONA = ? WHERE IDCITA = ?',
      [c.LUGAR, c.FECHA, c.HORA, c.ANOTACIONES, c.IDPERSONA, c.IDCITA]
    );
    return result;
  }

  static Future<int> eliminarPersona(int id) async {
    Database db = await _conectarDB();
    final result = await db.rawDelete(
      'DELETE FROM PERSONA WHERE IDPERSONA = ?',
      [id],
    );
    return result;
  }

  static Future<int> eliminarCita(int id) async {
    Database db = await _conectarDB();
    final result = await db.rawDelete('DELETE FROM CITA WHERE IDCITA = ?',[id]);
    return result;
  }
}
