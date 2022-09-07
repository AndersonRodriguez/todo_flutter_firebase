import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_flutter_firebase/models/data_model.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._internal();

  DBProvider._internal();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentDirectory.path, 'DataDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db
          .execute('CREATE TABLE Data (id INTEGER PRIMARY KEY, value TEXT)');
    });
  }

  // Crear Registro

  createData(DataModel newData) async {
    final db = await database;

    final res = await db!.insert('Data', newData.toJson());

    return res;
  }

  createDataSQL(DataModel newData) async {
    final db = await database;

    final res = await db!.rawInsert(
        "INSERT Into Data (id, value) VALUES (${newData.id}, '${newData.value}')");

    return res;
  }

  // Seleccionar registros

}
