import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:taskwarrior/app/v3/models/annotation.dart';
import 'package:taskwarrior/app/v3/models/task.dart'; // Path to your updated TaskForC model

class TaskDatabase {
  Database? _database;

  Future<void> open() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'tasks.db');

    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, version) async {
        // Create the main Tasks table
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
            start TEXT,       -- New column
            end TEXT,
            entry TEXT,
            wait TEXT,        -- New column
            modified TEXT,
            rtype TEXT,       -- New column
            recur TEXT        -- New column
          )
        ''');

        // Create TaskTags table
        await db.execute('''
          CREATE TABLE TaskTags (
            task_uuid TEXT NOT NULL,
            tag TEXT NOT NULL,
            PRIMARY KEY (task_uuid, tag),
            FOREIGN KEY (task_uuid) REFERENCES Tasks (uuid) ON DELETE CASCADE
          )
        ''');

        // Create TaskDepends table
        await db.execute('''
          CREATE TABLE TaskDepends (
            task_uuid TEXT NOT NULL,
            depends_on_uuid TEXT NOT NULL,
            PRIMARY KEY (task_uuid, depends_on_uuid),
            FOREIGN KEY (task_uuid) REFERENCES Tasks (uuid) ON DELETE CASCADE,
            FOREIGN KEY (depends_on_uuid) REFERENCES Tasks (uuid) ON DELETE CASCADE
          )
        ''');

        // Create TaskAnnotations table
        await db.execute('''
          CREATE TABLE TaskAnnotations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task_uuid TEXT NOT NULL,
            entry TEXT NOT NULL,
            description TEXT NOT NULL,
            FOREIGN KEY (task_uuid) REFERENCES Tasks (uuid) ON DELETE CASCADE
          )
        ''');

        debugPrint(
            "All tables created: Tasks, TaskTags, TaskDepends, TaskAnnotations");
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // This code runs when an existing database is opened with a higher version.
        debugPrint("Database upgrade from version $oldVersion to $newVersion");

        // Example: Migrating from version 1 to version 2
        if (oldVersion < 2) {
          // 1. Add new columns to the 'Tasks' table
          try {
            await db.execute("ALTER TABLE Tasks ADD COLUMN start TEXT");
          } catch (e) {
            debugPrint("Could not add 'start' column: $e");
          }
          try {
            await db.execute("ALTER TABLE Tasks ADD COLUMN wait TEXT");
          } catch (e) {
            debugPrint("Could not add 'wait' column: $e");
          }
          try {
            await db.execute("ALTER TABLE Tasks ADD COLUMN rtype TEXT");
          } catch (e) {
            debugPrint("Could not add 'rtype' column: $e");
          }
          try {
            await db.execute("ALTER TABLE Tasks ADD COLUMN recur TEXT");
          } catch (e) {
            debugPrint("Could not add 'recur' column: $e");
          }

          // 2. Create the new relational tables
          await db.execute('''
            CREATE TABLE TaskTags (
              task_uuid TEXT NOT NULL,
              tag TEXT NOT NULL,
              PRIMARY KEY (task_uuid, tag),
              FOREIGN KEY (task_uuid) REFERENCES Tasks (uuid) ON DELETE CASCADE
            )
          ''');
          await db.execute('''
            CREATE TABLE TaskDepends (
              task_uuid TEXT NOT NULL,
              depends_on_uuid TEXT NOT NULL,
              PRIMARY KEY (task_uuid, depends_on_uuid),
              FOREIGN KEY (task_uuid) REFERENCES Tasks (uuid) ON DELETE CASCADE,
              FOREIGN KEY (depends_on_uuid) REFERENCES Tasks (uuid) ON DELETE CASCADE
            )
          ''');
          await db.execute('''
            CREATE TABLE TaskAnnotations (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              task_uuid TEXT NOT NULL,
              entry TEXT NOT NULL,
              description TEXT NOT NULL,
              FOREIGN KEY (task_uuid) REFERENCES Tasks (uuid) ON DELETE CASCADE
            )
          ''');
          debugPrint("New tables and columns added for upgrade to version 2.");

          // 3. Migrate data from the old 'tags' column in 'Tasks' to the new 'TaskTags' table
          // This is crucial if your old schema stored tags as a space-separated string.
          try {
            final List<Map<String, dynamic>> oldTasksWithTags =
                await db.query('Tasks',
                    columns: ['uuid', 'tags'], // Select old tags column
                    where: 'tags IS NOT NULL AND tags != ""');

            await db.transaction((txn) async {
              for (var oldTask in oldTasksWithTags) {
                final String taskUuid = oldTask['uuid'];
                final String tagsString = oldTask['tags'];
                final List<String> tags =
                    tagsString.split(' ').where((s) => s.isNotEmpty).toList();

                for (String tag in tags) {
                  await txn.insert(
                    'TaskTags',
                    {'task_uuid': taskUuid, 'tag': tag},
                    conflictAlgorithm: ConflictAlgorithm.ignore,
                  );
                }
              }
            });
            debugPrint(
                "Migrated tags data from old 'tags' column to 'TaskTags' table.");
          } catch (e) {
            debugPrint(
                "Error migrating old tags data (possibly old 'tags' column didn't exist or was empty): $e");
          }

          // 4. (Optional but recommended) Drop the old 'tags' column from 'Tasks' table
          // Only do this after you are absolutely sure the data migration is successful.
          try {
            await db.execute("ALTER TABLE Tasks DROP COLUMN tags");
            debugPrint("Dropped old 'tags' column from 'Tasks' table.");
          } catch (e) {
            debugPrint(
                "Could not drop old 'tags' column (might not exist): $e");
          }
        }
      },
    );
  }

  Future<void> ensureDatabaseIsOpen() async {
    if (_database == null || !_database!.isOpen) {
      await open();
    }
  }

  // Helper method to convert a database map to a TaskForC object
  Future<TaskForC> _taskFromDbMap(Map<String, dynamic> taskMap) async {
    final String taskUuid = taskMap['uuid'] as String;

    // Fetch Tags
    final List<Map<String, dynamic>> tagMaps = await _database!.query(
      'TaskTags',
      columns: ['tag'],
      where: 'task_uuid = ?',
      whereArgs: [taskUuid],
    );
    final List<String> tags =
        tagMaps.map((map) => map['tag'] as String).toList();

    // Fetch Depends
    final List<Map<String, dynamic>> dependsMaps = await _database!.query(
      'TaskDepends',
      columns: ['depends_on_uuid'],
      where: 'task_uuid = ?',
      whereArgs: [taskUuid],
    );
    final List<String> depends =
        dependsMaps.map((map) => map['depends_on_uuid'] as String).toList();

    // Fetch Annotations
    final List<Map<String, dynamic>> annotationMaps = await _database!.query(
      'TaskAnnotations',
      where: 'task_uuid = ?',
      whereArgs: [taskUuid],
    );
    final List<Annotation> annotations =
        annotationMaps.map((map) => Annotation.fromJson(map)).toList();

    return TaskForC(
      id: taskMap['id'],
      description: taskMap['description'],
      project: taskMap['project'],
      status: taskMap['status'],
      uuid: taskMap['uuid'],
      urgency: (taskMap['urgency'] as num?)?.toDouble(),
      priority: taskMap['priority'],
      due: taskMap['due'],
      start: taskMap['start'],
      end: taskMap['end'],
      entry: taskMap['entry'],
      wait: taskMap['wait'],
      modified: taskMap['modified'],
      rtype: taskMap['rtype'],
      recur: taskMap['recur'],
      tags: tags,
      depends: depends,
      annotations: annotations,
    );
  }

  // Helper method to convert a TaskForC object to a map for the 'Tasks' table
  Map<String, dynamic> _taskToDbMap(TaskForC task) {
    return {
      'id': task.id,
      'description': task.description,
      'project': task.project,
      'status': task.status,
      'uuid': task.uuid,
      'urgency': task.urgency,
      'priority': task.priority,
      'due': task.due,
      'start': task.start,
      'end': task.end,
      'entry': task.entry,
      'wait': task.wait,
      'modified': task.modified,
      'rtype': task.rtype,
      'recur': task.recur,
    };
  }

  // --- CRUD Operations for TaskForC ---

  Future<List<TaskForC>> fetchTasksFromDatabase() async {
    await ensureDatabaseIsOpen();

    final List<Map<String, dynamic>> taskMaps = await _database!.query('Tasks');
    debugPrint("Database fetch: ${taskMaps.length} tasks found.");

    List<TaskForC> tasks = [];
    for (var taskMap in taskMaps) {
      tasks.add(await _taskFromDbMap(taskMap));
    }
    return tasks;
  }

  Future<void> deleteAllTasksInDB() async {
    await ensureDatabaseIsOpen();

    await _database!.transaction((txn) async {
      await txn.delete('TaskAnnotations');
      await txn.delete('TaskDepends');
      await txn.delete('TaskTags');
      await txn.delete('Tasks');
    });

    debugPrint('Deleted all tasks and related data');
  }

  Future<void> printDatabaseContents() async {
    await ensureDatabaseIsOpen();

    debugPrint('--- Contents of Tasks table ---');
    List<Map<String, dynamic>> tasks = await _database!.query('Tasks');
    for (var map in tasks) {
      debugPrint(map.toString());
    }

    debugPrint('--- Contents of TaskTags table ---');
    List<Map<String, dynamic>> taskTags = await _database!.query('TaskTags');
    for (var map in taskTags) {
      debugPrint(map.toString());
    }

    debugPrint('--- Contents of TaskDepends table ---');
    List<Map<String, dynamic>> taskDepends =
        await _database!.query('TaskDepends');
    for (var map in taskDepends) {
      debugPrint(map.toString());
    }

    debugPrint('--- Contents of TaskAnnotations table ---');
    List<Map<String, dynamic>> taskAnnotations =
        await _database!.query('TaskAnnotations');
    for (var map in taskAnnotations) {
      debugPrint(map.toString());
    }
  }

  Future<void> insertTask(TaskForC task) async {
    await ensureDatabaseIsOpen();
    debugPrint("Database Insert: Starting for task UUID: ${task.uuid}");

    await _database!.transaction((txn) async {
      // 1. Insert into Tasks table
      await txn.insert(
        'Tasks',
        _taskToDbMap(task), // Use helper to get map for main table
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint("Inserted main task data for UUID: ${task.uuid}");

      // 2. Insert into TaskTags table
      if (task.tags != null && task.tags!.isNotEmpty) {
        for (String tag in task.tags!) {
          await txn.insert(
            'TaskTags',
            {'task_uuid': task.uuid, 'tag': tag},
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
        debugPrint("Inserted tags for UUID: ${task.uuid}");
      }

      // 3. Insert into TaskDepends table
      if (task.depends != null && task.depends!.isNotEmpty) {
        for (String dependsOnUuid in task.depends!) {
          await txn.insert(
            'TaskDepends',
            {'task_uuid': task.uuid, 'depends_on_uuid': dependsOnUuid},
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
        debugPrint("Inserted dependencies for UUID: ${task.uuid}");
      }

      // 4. Insert into TaskAnnotations table
      if (task.annotations != null && task.annotations!.isNotEmpty) {
        for (Annotation annotation in task.annotations!) {
          await txn.insert(
            'TaskAnnotations',
            {
              'task_uuid': task.uuid,
              'entry': annotation.entry,
              'description': annotation.description,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        debugPrint("Inserted annotations for UUID: ${task.uuid}");
      }
    });
    debugPrint("Database Insert Complete for task UUID: ${task.uuid}");
  }

  Future<void> updateTask(TaskForC task) async {
    await ensureDatabaseIsOpen();
    debugPrint("Database Update: Starting for task UUID: ${task.uuid}");

    await _database!.transaction((txn) async {
      // 1. Update main Tasks table
      await txn.update(
        'Tasks',
        _taskToDbMap(task), // Use helper to get map for main table
        where: 'uuid = ?',
        whereArgs: [task.uuid],
      );
      debugPrint("Updated main task data for UUID: ${task.uuid}");

      // 2. Update TaskTags table: Delete existing, then insert new
      await txn
          .delete('TaskTags', where: 'task_uuid = ?', whereArgs: [task.uuid]);
      if (task.tags != null && task.tags!.isNotEmpty) {
        for (String tag in task.tags!) {
          await txn.insert(
            'TaskTags',
            {'task_uuid': task.uuid, 'tag': tag},
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      }
      debugPrint("Updated tags for UUID: ${task.uuid}");

      // 3. Update TaskDepends table: Delete existing, then insert new
      await txn.delete('TaskDepends',
          where: 'task_uuid = ?', whereArgs: [task.uuid]);
      if (task.depends != null && task.depends!.isNotEmpty) {
        for (String dependsOnUuid in task.depends!) {
          await txn.insert(
            'TaskDepends',
            {'task_uuid': task.uuid, 'depends_on_uuid': dependsOnUuid},
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      }
      debugPrint("Updated dependencies for UUID: ${task.uuid}");

      // 4. Update TaskAnnotations table: Delete existing, then insert new
      await txn.delete('TaskAnnotations',
          where: 'task_uuid = ?', whereArgs: [task.uuid]);
      if (task.annotations != null && task.annotations!.isNotEmpty) {
        for (Annotation annotation in task.annotations!) {
          await txn.insert(
            'TaskAnnotations',
            {
              'task_uuid': task.uuid,
              'entry': annotation.entry,
              'description': annotation.description,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
      debugPrint("Updated annotations for UUID: ${task.uuid}");
    });
    debugPrint("Database Update Complete for task UUID: ${task.uuid}");
  }

  Future<TaskForC?> getTaskByUuid(String uuid) async {
    await ensureDatabaseIsOpen();

    final List<Map<String, dynamic>> taskMaps = await _database!.query(
      'Tasks',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );

    if (taskMaps.isEmpty) {
      return null;
    }

    return await _taskFromDbMap(taskMaps.first);
  }

  Future<void> markTaskAsCompleted(String uuid) async {
    await ensureDatabaseIsOpen();

    await _database!.update(
      'Tasks',
      {'modified': (DateTime.now()).toIso8601String(), 'status': 'completed'},
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    debugPrint('Task $uuid marked as completed');
  }

  Future<void> markTaskAsDeleted(String uuid) async {
    await ensureDatabaseIsOpen();

    // Due to FOREIGN KEY ... ON DELETE CASCADE, related tags, depends, and annotations
    // will be automatically deleted when the main task is deleted from the Tasks table.
    await _database!.delete(
      'Tasks',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    debugPrint('Task $uuid deleted (and related data cascaded)');
  }

  Future<void> saveEditedTaskInDB(
    String uuid,
    String newDescription,
    String? newProject,
    String newStatus,
    String? newPriority,
    String? newDue,
    List<String>? newTags,
    List<String>? newDepends,
    List<Annotation>? newAnnotations,
  ) async {
    await ensureDatabaseIsOpen();
    debugPrint('Saving edited task $uuid');

    await _database!.transaction((txn) async {
      await txn.update(
        'Tasks',
        {
          'description': newDescription,
          'project': newProject,
          'status': newStatus,
          'priority': newPriority,
          'due': newDue,
          'modified': (DateTime.now()).toIso8601String(),
        },
        where: 'uuid = ?',
        whereArgs: [uuid],
      );
      debugPrint('Main task data updated for $uuid');

      // Update Tags
      await txn.delete('TaskTags', where: 'task_uuid = ?', whereArgs: [uuid]);
      if (newTags != null && newTags.isNotEmpty) {
        for (String tag in newTags) {
          await txn.insert(
            'TaskTags',
            {'task_uuid': uuid, 'tag': tag},
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      }
      debugPrint('Tags updated for $uuid');

      // Update Depends
      await txn
          .delete('TaskDepends', where: 'task_uuid = ?', whereArgs: [uuid]);
      if (newDepends != null && newDepends.isNotEmpty) {
        for (String dependsOnUuid in newDepends) {
          await txn.insert(
            'TaskDepends',
            {'task_uuid': uuid, 'depends_on_uuid': dependsOnUuid},
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      }
      debugPrint('Dependencies updated for $uuid');

      // Update Annotations
      await txn
          .delete('TaskAnnotations', where: 'task_uuid = ?', whereArgs: [uuid]);
      if (newAnnotations != null && newAnnotations.isNotEmpty) {
        for (Annotation annotation in newAnnotations) {
          await txn.insert(
            'TaskAnnotations',
            {
              'task_uuid': uuid,
              'entry': annotation.entry,
              'description': annotation.description,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
      debugPrint('Annotations updated for $uuid');
    });
    debugPrint('Task $uuid edited successfully');
  }

  Future<List<TaskForC>> findTasksWithoutUUIDs() async {
    await ensureDatabaseIsOpen();

    List<Map<String, dynamic>> maps = await _database!.query(
      'Tasks',
      where: 'uuid IS NULL OR uuid = ?',
      whereArgs: [''],
    );

    List<TaskForC> tasks = [];
    for (var taskMap in maps) {
      // Note: If task_uuid is NULL or empty, the _taskFromDbMap will attempt to query related tables
      // with a potentially invalid UUID. Ensure your data integrity that tasks always have a UUID
      // if they are expected to have tags/depends/annotations.
      tasks.add(await _taskFromDbMap(taskMap));
    }
    return tasks;
  }

  Future<List<TaskForC>> getTasksByProject(String project) async {
    await ensureDatabaseIsOpen();

    List<Map<String, dynamic>> taskMaps = await _database!.query(
      'Tasks',
      where: 'project = ?',
      whereArgs: [project],
    );
    debugPrint("DB Stored for $project: ${taskMaps.length} tasks");

    List<TaskForC> tasks = [];
    for (var taskMap in taskMaps) {
      tasks.add(await _taskFromDbMap(taskMap));
    }
    return tasks;
  }

  Future<List<String>> fetchUniqueProjects() async {
    await ensureDatabaseIsOpen();

    final List<Map<String, dynamic>> result = await _database!.rawQuery(
        'SELECT DISTINCT project FROM Tasks WHERE project IS NOT NULL AND project != ""');

    return result.map((row) => row['project'] as String).toList();
  }

  Future<List<TaskForC>> searchTasks(String query) async {
    await ensureDatabaseIsOpen();

    final List<Map<String, dynamic>> taskMaps = await _database!.query(
      'Tasks',
      where: 'description LIKE ? OR project LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    List<TaskForC> tasks = [];
    for (var taskMap in taskMaps) {
      tasks.add(await _taskFromDbMap(taskMap));
    }
    return tasks;
  }

  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> deleteTask(
      {String? description,
      String? due,
      String? project,
      String? priority,
      String? uuid}) async {
    await ensureDatabaseIsOpen();

    if (uuid != null && uuid.isNotEmpty) {
      // If UUID is provided, use it for a more robust deletion which triggers cascade
      await markTaskAsDeleted(uuid);
    } else {
      // Fallback for deleting without UUID (less reliable, does not cascade automatically for related tables)
      List<String> whereClauses = [];
      List<dynamic> whereArgs = [];

      if (description != null) {
        whereClauses.add('description = ?');
        whereArgs.add(description);
      }
      if (due != null) {
        whereClauses.add('due = ?');
        whereArgs.add(due);
      }
      if (project != null) {
        whereClauses.add('project = ?');
        whereArgs.add(project);
      }
      if (priority != null) {
        whereClauses.add('priority = ?');
        whereArgs.add(priority);
      }

      if (whereClauses.isNotEmpty) {
        await _database!.delete(
          'Tasks',
          where: whereClauses.join(' AND '),
          whereArgs: whereArgs,
        );
        debugPrint(
            'Task deleted using old method (description, due, project, priority). NOTE: Related data in TaskTags, TaskDepends, TaskAnnotations for this task UUID might remain if UUID was not used for deletion.');
      } else {
        debugPrint(
            'Delete task called without sufficient identifying parameters (UUID or other fields). No action taken.');
      }
    }
  }
}
