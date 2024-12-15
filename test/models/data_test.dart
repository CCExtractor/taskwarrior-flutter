import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:taskwarrior/app/models/data.dart';
import 'package:taskwarrior/app/models/json/task.dart';
import 'package:taskwarrior/app/services/notification_services.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Data', () {
    late Data data;
    late Directory home;
    late MockNotificationService mockNotificationService;

    setUp(() {
      WidgetsFlutterBinding.ensureInitialized();
      home = Directory.systemTemp.createTempSync();
      data = Data(home);
      mockNotificationService = MockNotificationService();

      when(mockNotificationService.initiliazeNotification())
          .thenAnswer((_) async {});
    });

    test('should update tasks with status "waiting" or "until" correctly',
        () async {
      final task1 = Task((b) => b
        ..uuid = '1'
        ..status = 'pending'
        ..wait = DateTime.now().toUtc().subtract(const Duration(days: 1))
        ..description = 'Test Task'
        ..entry = DateTime.now().toUtc());
      final task2 = Task((b) => b
        ..uuid = '2'
        ..status = 'deleted'
        ..until = DateTime.now().toUtc().subtract(const Duration(days: 1))
        ..description = 'Test Task'
        ..entry = DateTime.now().toUtc());

      final updatedTasks = data.pendingData();
      expect(
          updatedTasks.any(
              (task) => task.uuid == task1.uuid && task.status == task1.status),
          isFalse);
      expect(
          updatedTasks.any(
              (task) => task.uuid == task2.uuid && task.status == task2.status),
          isFalse);
    });

    test('should correctly return pending data', () {
      final task = Task((b) => b
        ..uuid = '1'
        ..status = 'pending'
        ..description = 'Test Task'
        ..entry = DateTime.now().toUtc());

      data.updateWaitOrUntil([task]);
      final tasks = data.pendingData();
      expect(tasks.any((t) => t.uuid == '1' && t.description == 'Test Task'),
          isFalse);
    });

    test('should correctly return completed data', () {
      final task = Task((b) => b
        ..uuid = '1'
        ..status = 'completed'
        ..description = 'Test Task'
        ..entry = DateTime.now().toUtc());

      data.updateWaitOrUntil([task]);
      final tasks = data.completedData();
      expect(tasks.any((t) => t.uuid == '1' && t.description == 'Test Task'),
          isFalse);
    });

    test('should correctly return waiting data', () {
      final task = Task((b) => b
        ..uuid = '1'
        ..status = 'waiting'
        ..description = 'Test Task'
        ..entry = DateTime.now().toUtc());

      data.updateWaitOrUntil([task]);
      final tasks = data.waitingData();
      expect(tasks.any((t) => t.uuid == '1' && t.description == 'Test Task'),
          isFalse);
    });

    test('should correctly export data', () {
      final exportedData = data.export();
      expect(exportedData, isNotNull);
    });

    tearDown(() {
      home.deleteSync(recursive: true);
    });
  });
}
