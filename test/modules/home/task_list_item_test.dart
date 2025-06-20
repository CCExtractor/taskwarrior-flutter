import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:taskwarrior/app/models/json/task.dart';
import 'package:taskwarrior/app/modules/home/views/tas_list_item.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';
import 'package:taskwarrior/app/utils/taskfunctions/modify.dart';

class MockModify extends Mock implements Modify {}

void main() {
  group('TaskListItem', () {
    late Task normalTask;
    late Task dueSoonTask;
    late Task overdueTask;
    late MockModify mockModify;

    setUp(() {
      mockModify = MockModify();

      normalTask = Task((b) => b
        ..id = 1
        ..uuid = 'uuid1'
        ..description = 'Task without urgency'
        ..status = 'pending'
        ..entry = DateTime.now()
        ..due = DateTime.now().add(const Duration(days: 5)));

      dueSoonTask = Task((b) => b
        ..id = 2
        ..uuid = 'uuid2'
        ..description = 'Task due soon'
        ..status = 'pending'
        ..entry = DateTime.now()
        ..due = DateTime.now().add(const Duration(hours: 23)));

      overdueTask = Task((b) => b
        ..id = 3
        ..uuid = 'uuid3'
        ..description = 'Overdue task'
        ..status = 'pending'
        ..entry = DateTime.now()
        ..due = DateTime.now().subtract(const Duration(days: 1)));
    });

    testWidgets('renders normal task without highlight',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TaskListItem(
            normalTask,
            useDelayTask: true,
            modify: mockModify,
            selectedLanguage: SupportedLanguage.english,
          ),
        ),
      ));

      expect(find.text('1. Task without urgency'), findsOneWidget);

      final containerFinder = find.byType(Container).first;
      final Container container = tester.widget(containerFinder);
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.border!.top.color, isNot(Colors.red));
      expect((decoration.color as Color).alpha, isNot(50));
    });

    testWidgets('renders due soon task with red border',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TaskListItem(
            dueSoonTask,
            useDelayTask: true,
            modify: mockModify,
            selectedLanguage: SupportedLanguage.english,
          ),
        ),
      ));

      expect(find.text('2. Task due soon'), findsOneWidget);

      final containerFinder = find.byType(Container).first;
      final Container container = tester.widget(containerFinder);
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.border!.top.color, Colors.red);
    });

    testWidgets('renders overdue task with red background',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TaskListItem(
            overdueTask,
            useDelayTask: true,
            modify: mockModify,
            selectedLanguage: SupportedLanguage.english,
          ),
        ),
      ));

      expect(find.text('3. Overdue task'), findsOneWidget);

      final containerFinder = find.byType(Container).first;
      final Container container = tester.widget(containerFinder);
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect((decoration.color as Color).red, Colors.red.red);
      expect((decoration.color as Color).alpha, 50);
    });

    testWidgets('does not highlight tasks when useDelayTask is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TaskListItem(
            overdueTask,
            useDelayTask: false,
            modify: mockModify,
            selectedLanguage: SupportedLanguage.english,
          ),
        ),
      ));

      expect(find.text('3. Overdue task'), findsOneWidget);

      final containerFinder = find.byType(Container).first;
      final Container container = tester.widget(containerFinder);
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.border!.top.color, isNot(Colors.red));
      expect((decoration.color as Color).alpha, isNot(50));
    });
  });
}
