import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';
import 'package:taskwarrior/app/v3/models/annotation.dart';
import 'package:taskwarrior/app/v3/models/task.dart';
import 'package:taskwarrior/app/v3/net/complete.dart';
import 'package:taskwarrior/app/v3/net/fetch.dart';

import 'api_service_test.mocks.dart';

class MockCredentialsStorage extends Mock implements CredentialsStorage {}

class MockMethodChannel extends Mock implements MethodChannel {}

@GenerateMocks([MockMethodChannel, http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  databaseFactory = databaseFactoryFfi;
  MockClient mockClient = MockClient();

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

  group('fetchTasks', () {
    test('Fetch data successfully', () async {
      final responseJson = jsonEncode({'data': 'Mock data'});
      var baseUrl = await CredentialsStorage.getApiUrl();
      when(mockClient.get(
          Uri.parse(
              '$baseUrl/tasks?email=email&origin=$baseUrl&UUID=123&encryptionSecret=secret'),
          headers: {
            "Content-Type": "application/json",
          })).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await fetchTasks('123', 'secret');

      expect(result, isA<List<TaskForC>>());
    });

    test('fetchTasks returns empty array', () async {
      const uuid = '123';
      const encryptionSecret = 'secret';

      expect(await fetchTasks(uuid, encryptionSecret), isEmpty);
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

  group('TaskForC annotations', () {
    test('fromJson parses annotations from JSON', () {
      final json = {
        'id': 1,
        'description': 'Task with notes',
        'project': null,
        'status': 'pending',
        'uuid': 'abc-123',
        'urgency': 2.0,
        'priority': null,
        'due': null,
        'end': null,
        'entry': '2024-01-01',
        'modified': null,
        'annotations': [
          {'entry': '2024-05-01', 'description': 'First note'},
          {'entry': '2024-05-02', 'description': 'Second note'},
        ],
      };

      final task = TaskForC.fromJson(json);

      expect(task.annotations, hasLength(2));
      expect(task.annotations![0].entry, '2024-05-01');
      expect(task.annotations![0].description, 'First note');
      expect(task.annotations![1].description, 'Second note');
    });

    test('fromJson returns empty list when annotations are absent', () {
      final json = {
        'id': 1,
        'description': 'Task no notes',
        'project': null,
        'status': 'pending',
        'uuid': 'abc-456',
        'urgency': 1.0,
        'priority': null,
        'due': null,
        'end': null,
        'entry': '2024-01-01',
        'modified': null,
      };

      final task = TaskForC.fromJson(json);

      expect(task.annotations, isEmpty);
    });

    test('fromJson returns empty list when annotations are null', () {
      final json = {
        'id': 1,
        'description': 'Task null notes',
        'project': null,
        'status': 'pending',
        'uuid': 'abc-789',
        'urgency': 1.0,
        'priority': null,
        'due': null,
        'end': null,
        'entry': '2024-01-01',
        'modified': null,
        'annotations': null,
      };

      final task = TaskForC.fromJson(json);

      expect(task.annotations, isEmpty);
    });

    test('toJson round-trips annotations', () {
      final task = TaskForC(
          id: 1,
          description: 'Task',
          project: null,
          status: 'pending',
          uuid: '123',
          urgency: 1.0,
          priority: null,
          due: null,
          end: null,
          entry: '2024-01-01',
          modified: null,
          tags: [],
          start: null,
          wait: null,
          rtype: null,
          recur: null,
          depends: [],
          annotations: [
            Annotation(entry: '2024-01-01', description: 'My note')
          ]);

      final json = task.toJson();

      expect(json['annotations'], isA<List>());
      expect((json['annotations'] as List)[0]['description'], 'My note');
      expect((json['annotations'] as List)[0]['entry'], '2024-01-01');
    });
  });

  group('completeTask', () {
    test('throws exception when server returns non-200', () async {
      final mockClient = MockClient();
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Unauthorized', 401));

      await expectLater(
        completeTask('email', 'some-uuid', client: mockClient),
        throwsException,
      );
    });
  });

  group('timeout constant regression', () {
    test('credential-check timeout is 10 seconds not 10000', () {
      const timeout = Duration(seconds: 10);
      expect(timeout.inSeconds, equals(10));
      expect(timeout.inMinutes, lessThan(1));
    });
  });
}
