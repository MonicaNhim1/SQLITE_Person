import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_person/Model/person.dart';

String table = 'person';

class DatabaseConnection {
  Future<Database> initializeData() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String path = await getDatabasesPath();
    return openDatabase(join(path, 'data.db'), version: 1,
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $table(id INTEGER PRIMARY KEY, name TEXT,sex TEXT, age  INTEGER , pic TEX)');
    });
  }

  Future<void> insertData(Person person) async {
    final db = await initializeData();
    await db.insert(table, person.toMap());
    print('object inserted to database');
  }

  Future<List<Person>> getData() async {
    final db = await initializeData();
    List<Map<String, dynamic>> result = await db.query(table);
    return result.map((e) => Person.fromMap(e)).toList();
  }

  Future<void> updateData(Person person) async {
    final db = await initializeData();
    await db
        .update(table, person.toMap(), where: 'id = ?', whereArgs: [person.id]);
  }

  Future<void> deleteData(int id) async {
    final db = await initializeData();
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
