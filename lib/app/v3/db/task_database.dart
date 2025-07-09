import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:taskwarrior/app/v3/models/task.dart';

class TaskDatabase {
  Database? _database;

  Future<void> open() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'tasks.db');

    _database = await openDatabase(path,
        version: 1,
        onOpen: (db) async => await addTagsColumnIfNeeded(db),
        onCreate: (Database db, version) async {
          await db.execute('''
        CREATE TABLE Tasks (
          uuid TEXT PRIMARY KEY,
          id INTEGER,
          description TEXT,
          project TEXT,
          status TEXT,
          urgency REAL,
          priority TEXT,
          due TEXT,
          end TEXT,
          entry TEXT,
          modified TEXT
        )
      ''');
        });
  }

  Future<void> addTagsColumnIfNeeded(Database db) async {
    try {
      await db.rawQuery("SELECT tags FROM Tasks LIMIT 0");
    } catch (e) {
      await db.execute("ALTER TABLE Tasks ADD COLUMN tags TEXT");
      debugPrint("Added Column tags");
    }
  }

  Future<void> ensureDatabaseIsOpen() async {
    if (_database == null) {
      await open();
    }
  }

  Future<List<TaskForC>> fetchTasksFromDatabase() async {
    await ensureDatabaseIsOpen();

    final List<Map<String, dynamic>> maps = await _database!.query('Tasks');
    debugPrint("Database fetch ${maps.last}");
    var a = List.generate(maps.length, (i) {
      return TaskForC(
          id: maps[i]['id'],
          description: maps[i]['description'],
          project: maps[i]['project'],
          status: maps[i]['status'],
          uuid: maps[i]['uuid'],
          urgency: maps[i]['urgency'],
          priority: maps[i]['priority'],
          due: maps[i]['due'],
          end: maps[i]['end'],
          entry: maps[i]['entry'],
          modified: maps[i]['modified'],
          tags: maps[i]['tags'] != null ? maps[i]['tags'].split(' ') : []);
    });
    // debugPrint('Tasks from db');
    // debugPrint(a.toString());
    return a;
  }

  Future<void> deleteAllTasksInDB() async {
    await ensureDatabaseIsOpen();

    await _database!.delete('Tasks');
    debugPrint('Deleted all tasks');
    await open();
    debugPrint('Created new task table');
  }

  Future<void> printDatabaseContents() async {
    await ensureDatabaseIsOpen();

    List<Map<String, dynamic>> maps = await _database!.query('Tasks');
    for (var map in maps) {
      map.forEach((key, value) {
        debugPrint('Key: $key, Value: $value, Type: ${value.runtimeType}');
      });
    }
  }

  Future<void> insertTask(TaskForC task) async {
    await ensureDatabaseIsOpen();
    debugPrint("Database Insert");
    var dbi = await _database!.insert(
      'Tasks',
      task.toDbJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint("Database Insert ${task.toDbJson()} $dbi");
  }

  Future<void> updateTask(TaskForC task) async {
    await ensureDatabaseIsOpen();

    await _database!.update(
      'Tasks',
      task.toDbJson(),
      where: 'uuid = ?',
      whereArgs: [task.uuid],
    );
  }

  Future<TaskForC?> getTaskByUuid(String uuid) async {
    await ensureDatabaseIsOpen();

    List<Map<String, dynamic>> maps = await _database!.query(
      'Tasks',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );

    if (maps.isNotEmpty) {
      return TaskForC.fromDbJson(maps.first);
    } else {
      return null;
    }
  }

  Future<void> markTaskAsCompleted(String uuid) async {
    await ensureDatabaseIsOpen();

    await _database!.update(
      'Tasks',
      {'modified': (DateTime.now()).toIso8601String(), 'status': 'completed'},
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    debugPrint('task${uuid}completed');
    debugPrint({DateTime.now().toIso8601String()}.toString());
  }

  Future<void> markTaskAsDeleted(String uuid) async {
    await ensureDatabaseIsOpen();

    await _database!.update(
      'Tasks',
      {'status': 'deleted'},
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    debugPrint('task${uuid}deleted');
  }

  Future<void> saveEditedTaskInDB(
    String uuid,
    String newDescription,
    String newProject,
    String newStatus,
    String newPriority,
    String newDue,
  ) async {
    await ensureDatabaseIsOpen();

    debugPrint('task${uuid}deleted');
    await _database!.update(
      'Tasks',
      {
        'description': newDescription,
        'project': newProject,
        'status': newStatus,
        'priority': newPriority,
        'due': newDue,
      },
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    debugPrint('task${uuid}edited');
  }

  Future<List<TaskForC>> findTasksWithoutUUIDs() async {
    await ensureDatabaseIsOpen();

    List<Map<String, dynamic>> maps = await _database!.query(
      'Tasks',
      where: 'uuid IS NULL OR uuid = ?',
      whereArgs: [''],
    );

    return List.generate(maps.length, (i) {
      return TaskForC.fromDbJson(maps[i]);
    });
  }

  Future<List<TaskForC>> getTasksByProject(String project) async {
    List<Map<String, dynamic>> maps = await _database!.query(
      'Tasks',
      where: 'project = ?',
      whereArgs: [project],
    );
    debugPrint("DB Stored for $maps");
    return List.generate(maps.length, (i) {
      return TaskForC(
          uuid: maps[i]['uuid'],
          id: maps[i]['id'],
          description: maps[i]['description'],
          project: maps[i]['project'],
          status: maps[i]['status'],
          urgency: maps[i]['urgency'],
          priority: maps[i]['priority'],
          due: maps[i]['due'],
          end: maps[i]['end'],
          entry: maps[i]['entry'],
          modified: maps[i]['modified'],
          tags: maps[i]['tags'].toString().split(' '));
    });
  }

  Future<List<String>> fetchUniqueProjects() async {
    var taskDatabase = TaskDatabase();
    await taskDatabase.open();
    await taskDatabase.ensureDatabaseIsOpen();

    final List<Map<String, dynamic>> result = await taskDatabase._database!
        .rawQuery(
            'SELECT DISTINCT project FROM Tasks WHERE project IS NOT NULL');

    return result.map((row) => row['project'] as String).toList();
  }

  Future<List<TaskForC>> searchTasks(String query) async {
    final List<Map<String, dynamic>> maps = await _database!.query(
      'tasks',
      where: 'description LIKE ? OR project LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) {
      return TaskForC.fromDbJson(maps[i]);
    });
  }

  Future<void> close() async {
    await _database!.close();
  }

  Future<void> deleteTask({description, due, project, priority}) async {
    await _database!.delete(
      'Tasks',
      where: 'description = ? AND due = ? AND project = ? AND priority = ?',
      whereArgs: [description, due, project, priority],
    );
  }
}
