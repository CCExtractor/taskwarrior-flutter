import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LogDatabaseHelper {
  static Database? _database;
  static const String tableName = 'logs';
  static const String columnId = 'id';
  static const String columnMessage = 'message';
  static const String columnTimestamp = 'timestamp';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'debug_logs.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnMessage TEXT NOT NULL,
            $columnTimestamp TEXT NOT NULL
          )
          ''');
      },
    );
  }

  Future<void> insertLog(String message) async {
    final db = await database;
    await db.insert(
      tableName,
      {
        columnMessage: message,
        columnTimestamp: DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getLogs() async {
    final db = await database;
    return await db.query(tableName, orderBy: '$columnTimestamp DESC');
  }

  Future<void> clearLogs() async {
    final db = await database;
    await db.delete(tableName);
  }
}
