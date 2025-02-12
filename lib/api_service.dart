// ignore_for_file: depend_on_referenced_packages, unnecessary_null_in_if_null_operators

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';

class Tasks {
  final int id;
  final String description;
  final String? project;
  final String status;
  final String? uuid;
  final double? urgency;
  final String? priority;
  final String? due;
  final String? end;
  final String entry;
  final String? modified;
  final List<dynamic>? tags;

  Tasks(
      {required this.id,
      required this.description,
      required this.project,
      required this.status,
      required this.uuid,
      required this.urgency,
      required this.priority,
      required this.due,
      required this.end,
      required this.entry,
      required this.modified,
      required this.tags});

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
        id: json['id'],
        description: json['description'],
        project: json['project'],
        status: json['status'],
        uuid: json['uuid'],
        urgency: json['urgency'].toDouble(),
        priority: json['priority'],
        due: json['due'],
        end: json['end'],
        entry: json['entry'],
        modified: json['modified'],
        tags: json['tags']);
  }
  factory Tasks.fromDbJson(Map<String, dynamic> json) {
    debugPrint("FROM: $json");
    return Tasks(
        id: json['id'],
        description: json['description'],
        project: json['project'],
        status: json['status'],
        uuid: json['uuid'],
        urgency: json['urgency'].toDouble(),
        priority: json['priority'],
        due: json['due'],
        end: json['end'],
        entry: json['entry'],
        modified: json['modified'],
        tags: json['tags'].toString().split(' '));
  }

  Map<String, dynamic> toJson() {
    debugPrint("TAGS: $tags");
    return {
      'id': id,
      'description': description,
      'project': project,
      'status': status,
      'uuid': uuid,
      'urgency': urgency,
      'priority': priority,
      'due': due,
      'end': end,
      'entry': entry,
      'modified': modified,
      'tags': tags
    };
  }

  Map<String, dynamic> toDbJson() {
    return {
      'id': id,
      'description': description,
      'project': project,
      'status': status,
      'uuid': uuid,
      'urgency': urgency,
      'priority': priority,
      'due': due,
      'end': end,
      'entry': entry,
      'modified': modified,
      'tags': tags != null ? tags?.join(" ") : ""
    };
  }
}

String baseUrl = 'http://YOUR_IP:8000';
String origin = 'http://localhost:8080';

Future<List<Tasks>> fetchTasks(String uuid, String encryptionSecret) async {
  try {
    String url =
        '$baseUrl/tasks?email=email&origin=$origin&UUID=$uuid&encryptionSecret=$encryptionSecret';

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
    }).timeout(const Duration(seconds: 10000));
    if (response.statusCode == 200) {
      List<dynamic> allTasks = jsonDecode(response.body);
      debugPrint(allTasks.toString());
      return allTasks.map((task) => Tasks.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  } catch (e) {
    debugPrint('Error fetching tasks: $e');
    return [];
  }
}

Future<void> updateTasksInDatabase(List<Tasks> tasks) async {
  var taskDatabase = TaskDatabase();
  await taskDatabase.open();
  // find tasks without UUID
  List<Tasks> tasksWithoutUUID = await taskDatabase.findTasksWithoutUUIDs();

  //add tasks without UUID to the server and delete them from database
  for (var task in tasksWithoutUUID) {
    try {
      await addTaskAndDeleteFromDatabase(task.description, task.project!,
          task.due!, task.priority!, task.tags != null ? task.tags! : []);
    } catch (e) {
      debugPrint('Failed to add task without UUID to server: $e');
    }
  }

  // update existing tasks in db
  for (var task in tasks) {
    var existingTask = await taskDatabase.getTaskByUuid(task.uuid!);
    if (existingTask != null) {
      if (task.modified!.compareTo(existingTask.modified!) > 0) {
        await taskDatabase.updateTask(task);
      }
    } else {
      // add new tasks to db
      await taskDatabase.insertTask(task);
    }
  }

  var localTasks = await taskDatabase.fetchTasksFromDatabase();
  var localTasksMap = {for (var task in localTasks) task.uuid: task};

  for (var serverTask in tasks) {
    var localTask = localTasksMap[serverTask.uuid];

    if (localTask == null) {
      // Task doesn't exist in the local database, insert it
      await taskDatabase.insertTask(serverTask);
    } else {
      var serverTaskModifiedDate = DateTime.parse(serverTask.modified!);
      var localTaskModifiedDate = DateTime.parse(localTask.modified!);

      if (serverTaskModifiedDate.isAfter(localTaskModifiedDate)) {
        // Server task is newer, update local database
        await taskDatabase.updateTask(serverTask);
      } else if (serverTaskModifiedDate.isBefore(localTaskModifiedDate)) {
        // local task is newer, update server
        await modifyTaskOnTaskwarrior(
          localTask.description,
          localTask.project!,
          localTask.due!,
          localTask.priority!,
          localTask.status,
          localTask.uuid!,
        );
        if (localTask.status == 'completed') {
          completeTask('email', localTask.uuid!);
        } else if (localTask.status == 'deleted') {
          deleteTask('email', localTask.uuid!);
        }
      }
    }
  }
}

Future<void> deleteTask(String email, String taskUuid) async {
  var c = await CredentialsStorage.getClientId();
  var e = await CredentialsStorage.getEncryptionSecret();
  final url = Uri.parse('$baseUrl/delete-task');
  final body = jsonEncode({
    'email': email,
    'encryptionSecret': e,
    'UUID': c,
    'taskuuid': taskUuid,
  });

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      debugPrint('Task deleted successfully on server');
    } else {
      debugPrint('Failed to delete task: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error deleting task: $e');
  }
}

Future<void> completeTask(String email, String taskUuid) async {
  var c = await CredentialsStorage.getClientId();
  var e = await CredentialsStorage.getEncryptionSecret();
  final url = Uri.parse('$baseUrl/complete-task');
  final body = jsonEncode({
    'email': email,
    'encryptionSecret': e,
    'UUID': c,
    'taskuuid': taskUuid,
  });

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      debugPrint('Task completed successfully on server');
    } else {
      debugPrint('Failed to complete task: ${response.statusCode}');
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(const SnackBar(
          content: Text(
        "Failed to complete task!",
        style: TextStyle(color: Colors.red),
      )));
    }
  } catch (e) {
    debugPrint('Error completing task: $e');
  }
}

Future<void> addTaskAndDeleteFromDatabase(String description, String project,
    String due, String priority, List<dynamic> tags) async {
  String apiUrl = '$baseUrl/add-task';
  var c = await CredentialsStorage.getClientId();
  var e = await CredentialsStorage.getEncryptionSecret();
  debugPrint("Database Adding Tags $tags $description");
  debugPrint(c);
  debugPrint(e);
  var res = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'text/plain',
    },
    body: jsonEncode({
      'email': 'email',
      'encryptionSecret': e,
      'UUID': c,
      'description': description,
      'project': project,
      'due': due,
      'priority': priority,
      'tags': tags
    }),
  );
  debugPrint('Database res  ${res.body}');
  var taskDatabase = TaskDatabase();
  await taskDatabase.open();
  await taskDatabase._database!.delete(
    'Tasks',
    where: 'description = ? AND due = ? AND project = ? AND priority = ?',
    whereArgs: [description, due, project, priority],
  );
}

Future<void> modifyTaskOnTaskwarrior(String description, String project,
    String due, String priority, String status, String taskuuid) async {
  String apiUrl = '$baseUrl/modify-task';
  var c = await CredentialsStorage.getClientId();
  var e = await CredentialsStorage.getEncryptionSecret();
  debugPrint(c);
  debugPrint(e);
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'text/plain',
    },
    body: jsonEncode({
      "email": "e",
      "encryptionSecret": e,
      "UUID": c,
      "description": description,
      "priority": priority,
      "project": project,
      "due": due,
      "status": status,
      "taskuuid": taskuuid,
    }),
  );

  if (response.statusCode != 200) {
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(const SnackBar(
        content: Text(
      "Failed to update task!",
      style: TextStyle(color: Colors.red),
    )));
  }

  var taskDatabase = TaskDatabase();
  await taskDatabase.open();
  await taskDatabase._database!.delete(
    'Tasks',
    where: 'description = ? AND due = ? AND project = ? AND priority = ?',
    whereArgs: [description, due, project, priority],
  );
}

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

  Future<List<Tasks>> fetchTasksFromDatabase() async {
    await ensureDatabaseIsOpen();

    final List<Map<String, dynamic>> maps = await _database!.query('Tasks');
    debugPrint("Database fetch ${maps.last}");
    var a = List.generate(maps.length, (i) {
      return Tasks(
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

  Future<void> insertTask(Tasks task) async {
    await ensureDatabaseIsOpen();
    debugPrint("Database Insert");
    var dbi = await _database!.insert(
      'Tasks',
      task.toDbJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint("Database Insert ${task.toDbJson()} $dbi");
  }

  Future<void> updateTask(Tasks task) async {
    await ensureDatabaseIsOpen();

    await _database!.update(
      'Tasks',
      task.toDbJson(),
      where: 'uuid = ?',
      whereArgs: [task.uuid],
    );
  }

  Future<Tasks?> getTaskByUuid(String uuid) async {
    await ensureDatabaseIsOpen();

    List<Map<String, dynamic>> maps = await _database!.query(
      'Tasks',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );

    if (maps.isNotEmpty) {
      return Tasks.fromDbJson(maps.first);
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

  Future<List<Tasks>> findTasksWithoutUUIDs() async {
    await ensureDatabaseIsOpen();

    List<Map<String, dynamic>> maps = await _database!.query(
      'Tasks',
      where: 'uuid IS NULL OR uuid = ?',
      whereArgs: [''],
    );

    return List.generate(maps.length, (i) {
      return Tasks.fromDbJson(maps[i]);
    });
  }

  Future<List<Tasks>> getTasksByProject(String project) async {
    List<Map<String, dynamic>> maps = await _database!.query(
      'Tasks',
      where: 'project = ?',
      whereArgs: [project],
    );
    debugPrint("DB Stored for $maps");
    return List.generate(maps.length, (i) {
      return Tasks(
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

  Future<List<Tasks>> searchTasks(String query) async {
    final List<Map<String, dynamic>> maps = await _database!.query(
      'tasks',
      where: 'description LIKE ? OR project LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Tasks.fromDbJson(maps[i]);
    });
  }

  Future<void> close() async {
    await _database!.close();
  }
}
