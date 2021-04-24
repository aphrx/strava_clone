import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:strava/model/entry.dart';

abstract class DB {
  static Database _db;
  static int get _version => 1;

  static Future<void> init() async {
    try {
      String _path = await getDatabasesPath();
      String _dbpath = p.join(_path, 'database.db');
      _db = await openDatabase(_dbpath, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static FutureOr<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE entries (
        id INTEGER PRIMARY KEY NOT NULL,
        date STRING, 
        duration STRING, 
        speed REAL, 
        distance REAL
      )
    ''');
  }

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      await _db.query(table);
  static Future<int> insert(String table, Entry item) async =>
      await _db.insert(table, item.toMap());
}
