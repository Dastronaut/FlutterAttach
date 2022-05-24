import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_thi_gk/components/dog_model.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'testthi.db'),
      
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE dog(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT"
          ", bred_for TEXT, breed_group TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertContact(Dog contact) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert('doggies', contact.toMap());
    return result;
  }

  Future<List<Dog>> retrieveContacts() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('doggies');
    return queryResult.map((e) => Dog.fromMap(e)).toList();
  }

  Future<void> deleteContact(int id) async {
    final db = await initializeDB();
    await db.delete(
      'doggies',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
