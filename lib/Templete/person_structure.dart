import 'package:sqflite/sqflite.dart';
import 'package:sqlite_person/Model/person.dart';

abstract class PersonDatabaseTemplate {
  Future<Database> initializeDB() async {
    return openDatabase('database.db');
  }

  Future<void> insertData(Person person) async {}
  Future<void> updateData(Person person) async {}
  Future<void> deleteteData(Person person) async {}
  Future<List<Person>> getData() async {
    return [];
  }
}
