import 'package:mvc_persistence/app/models/item.model.dart';
import 'package:mvc_persistence/app/settings.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ItemRepository {
  Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), DATABASE_NAME),
      onCreate: (db, version) {
        return db.execute(CREATE_LISTS_TABLE_SCRIPT);
      },
      version: 1,
    );
  }

  Future create(Item item) async {
    try {
      final Database db = await _getDB();
      await db.insert(
        TABLE_NAME,
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<List<Item>> getAll() async {
    try {
      final Database db = await _getDB();
      final List<Map<String, dynamic>> maps = await db.query(TABLE_NAME);

      return List.generate(
        maps.length,
        (index) => Item(
          id: maps[index]['id'],
          nome: maps[index]['nome'],
          concluido: maps[index]['concluido'],
          dueDate: maps[index]['duedate'],
        ),
      );
    } catch (e) {
      print(e);
      return new List<Item>();
    }
  }

  Future<Item> read(int id) async {
    try {
      final Database db = await _getDB();
      final List<Map<String, dynamic>> maps = await db.query(
        TABLE_NAME,
        where: "id = ?",
        whereArgs: [id],
      );

      return Item(
        id: maps[0]['id'],
        nome: maps[0]['nome'],
        concluido: maps[0]['concluido'],
        dueDate: maps[0]['duedate'],
      );
    } catch (ex) {
      print(ex);
      return new Item();
    }
  }

  Future update(Item item) async {
    try {
      final Database db = await _getDB();
      await db.update(
        TABLE_NAME,
        item.toMap(),
        where: "id = ?",
        whereArgs: [item.id],
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  Future delete(int id) async {
    try {
      final Database db = await _getDB();
      await db.delete(
        TABLE_NAME,
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (e) {
      print(e);
      return;
    }
  }
}
