import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:taskwarrior/api_service.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';

import 'main_test.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockCredentialsStorage extends Mock implements CredentialsStorage {}

@GenerateMocks([MockMethodChannel])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockHttpClient mockHttpClient;
  databaseFactory = databaseFactoryFfi;

  setUpAll(() {
    sqfliteFfiInit();
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
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

      final task = Tasks.fromJson(json);

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
      final task = Tasks(
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
      );

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
    test('fetchTasks returns list of Tasks on success', () async {
      const uuid = '123';
      const encryptionSecret = 'secret';
      final url =
          '$baseUrl/tasks?email=email&origin=$origin&UUID=$uuid&encryptionSecret=$encryptionSecret';

      final response = [
        {
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
        }
      ];

      when(mockHttpClient.get(Uri.parse(url), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode(response), 200));

      final tasks = await fetchTasks(uuid, encryptionSecret);

      expect(tasks.length, 1);
      expect(tasks[0].description, 'Task 1');
    });

    test('fetchTasks throws exception on failure', () async {
      const uuid = '123';
      const encryptionSecret = 'secret';
      final url =
          '$baseUrl/tasks?email=email&origin=$origin&UUID=$uuid&encryptionSecret=$encryptionSecret';

      when(mockHttpClient.get(Uri.parse(url), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(() => fetchTasks(uuid, encryptionSecret), throwsException);
    });
  });

  group('TaskDatabase', () {
    late TaskDatabase taskDatabase;

    setUp(() async {
      taskDatabase = TaskDatabase();
      await taskDatabase.open();
    });

    tearDown(() async {
      await taskDatabase.deleteAllTasksInDB();
    });

    test('insertTask adds a task to the database', () async {
      final task = Tasks(
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
      );

      await taskDatabase.insertTask(task);

      final tasks = await taskDatabase.fetchTasksFromDatabase();

      expect(tasks.length, 1);
      expect(tasks[0].description, 'Task 1');
    });

    test('deleteAllTasksInDB removes all tasks', () async {
      final task = Tasks(
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
      );

      await taskDatabase.insertTask(task);
      await taskDatabase.deleteAllTasksInDB();

      final tasks = await taskDatabase.fetchTasksFromDatabase();

      expect(tasks.length, 0);
    });
  });
}
