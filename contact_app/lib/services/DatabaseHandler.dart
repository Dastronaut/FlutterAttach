import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../components/contac_argument.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE contacts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, numphone TEXT NOT NULL, mail TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertContact(Contact contact) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert('contacts', contact.toMap());
    return result;
  }

  Future<List<Contact>> retrieveContacts() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('contacts');
    return queryResult.map((e) => Contact.fromMap(e)).toList();
  }

  Future<void> deleteContact(int id) async {
    final db = await initializeDB();
    await db.delete(
      'contacts',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
