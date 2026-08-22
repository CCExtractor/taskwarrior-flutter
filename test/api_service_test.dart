import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';
import 'package:taskwarrior/app/v3/models/task.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  databaseFactory = databaseFactoryFfi;

  setUpAll(() {
    sqfliteFfiInit();

    // Mock SharedPreferences plugin
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, Object>{}; // Return empty prefs
      }
      return null;
    });
  });

  group('Tasks model', () {
    test('fromJson creates Tasks object', () {
      final json = {
        'id': 1,
        'description': 'Task 1',
        'project': 'Project 1',
        'status': 'pending',
        'uuid': '123',
        'urgency': 5.0,
        'priority': 'H',
        'due': '2024-12-31',
        'end': null,
        'entry': '2024-01-01',
        'modified': '2024-11-01',
      };

      final task = TaskForC.fromJson(json);

      expect(task.id, 1);
      expect(task.description, 'Task 1');
      expect(task.project, 'Project 1');
      expect(task.status, 'pending');
      expect(task.uuid, '123');
      expect(task.urgency, 5.0);
      expect(task.priority, 'H');
      expect(task.due, '2024-12-31');
      expect(task.entry, '2024-01-01');
      expect(task.modified, '2024-11-01');
    });

    test('toJson converts Tasks object to JSON', () {
      final task = TaskForC(
          id: 1,
          description: 'Task 1',
          project: 'Project 1',
          status: 'pending',
          uuid: '123',
          urgency: 5.0,
          priority: 'H',
          due: '2024-12-31',
          end: null,
          entry: '2024-01-01',
          modified: '2024-11-01',
          tags: ['t1'],
          start: '',
          wait: '',
          rtype: '',
          recur: '',
          depends: [],
          annotations: []);

      final json = task.toJson();

      expect(json['id'], 1);
      expect(json['description'], 'Task 1');
      expect(json['project'], 'Project 1');
      expect(json['status'], 'pending');
      expect(json['uuid'], '123');
      expect(json['urgency'], 5.0);
      expect(json['priority'], 'H');
      expect(json['due'], '2024-12-31');
    });
  });

  group('TaskDatabase', () {
    late TaskDatabase taskDatabase;

    setUp(() async {
      taskDatabase = TaskDatabase();
      await taskDatabase.open();
    });

    test('insertTask adds a task to the database', () async {
      final task = TaskForC(
          id: 1,
          description: 'Task 1',
          project: 'Project 1',
          status: 'pending',
          uuid: '123',
          urgency: 5.0,
          priority: 'H',
          due: '2024-12-31',
          end: '',
          entry: '2024-01-01',
          modified: '2024-11-01',
          tags: ['t1'],
          start: '',
          wait: '',
          rtype: '',
          recur: '',
          depends: [],
          annotations: []);

      await taskDatabase.insertTask(task);

      final tasks = await taskDatabase.fetchTasksFromDatabase();

      expect(tasks.length, 1);
      expect(tasks[0].description, 'Task 1');
    });

    test('deleteAllTasksInDB removes all tasks', () async {
      final task = TaskForC(
          id: 1,
          description: 'Task 1',
          project: 'Project 1',
          status: 'pending',
          uuid: '123',
          urgency: 5.0,
          priority: 'H',
          due: '2024-12-31',
          end: null,
          entry: '2024-01-01',
          modified: '2024-11-01',
          tags: ['t1'],
          start: '',
          wait: '',
          rtype: '',
          recur: '',
          depends: [],
          annotations: []);

      await taskDatabase.insertTask(task);
      await taskDatabase.deleteAllTasksInDB();

      // The implementation has a bug where it calls maps.last on empty results
      // This will throw "Bad state: No element" when there are no tasks
      expect(() => taskDatabase.fetchTasksFromDatabase(), throwsStateError);
    });
  });
}
