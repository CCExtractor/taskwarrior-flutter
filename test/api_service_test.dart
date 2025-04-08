import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as mockClient;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/api_service.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';

import 'api_service_test.mocks.dart';

// Define the missing constants
const String baseUrl =
    'https://your-api-base-url.com'; // Replace with your actual base URL
const String origin =
    'http://localhost:8080'; // Replace with your actual origin

class MockCredentialsStorage extends Mock implements CredentialsStorage {
  getApiUrl() {}
}

class MockMethodChannel extends Mock implements MethodChannel {}

@GenerateMocks([http.Client, CredentialsStorage])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock SharedPreferences
  SharedPreferences.setMockInitialValues({});

  var mockCredentialsStorage = MockCredentialsStorage();

  setUpAll(() {
    when(mockCredentialsStorage.getApiUrl())
        .thenAnswer((_) async => 'https://test-api.com');
  });

  test('Fetch data successfully', () async {
    final client = MockClient();
    when(client.get(any))
        .thenAnswer((_) async => http.Response('[{"id":1}]', 200));

    final tasks = await fetchTasks(
      'test-uuid',
      'test-secret',
      credentialsStorage: mockCredentialsStorage, // Inject mock
    );

    expect(tasks, isA<List<Tasks>>());
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
    test('Fetch data successfully', () async {
      final responseJson = jsonEncode({'data': 'Mock data'});
      when(mockClient.get(
          Uri.parse(
              '$baseUrl/tasks?email=email&origin=$origin&UUID=123&encryptionSecret=secret'),
          headers: {
            "Content-Type": "application/json",
          })).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await fetchTasks('123', 'secret',
          credentialsStorage: mockCredentialsStorage);

      expect(result, isA<List<Tasks>>());
    });

    test('fetchTasks returns empty array', () async {
      const uuid = '123';
      const encryptionSecret = 'secret';

      expect(
          await fetchTasks(uuid, encryptionSecret,
              credentialsStorage: mockCredentialsStorage),
          isEmpty);
    });
  });

  group('TaskDatabase', () {
    late TaskDatabase taskDatabase;

    setUp(() async {
      taskDatabase = TaskDatabase();
      await taskDatabase.open();
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
