import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taskwarrior/model/json/task.dart';
import 'package:taskwarrior/services/task_list_tem.dart';

import 'package:uuid/uuid.dart';

void main() {
  // This test checks if there are tasks in the app.
  testWidgets("check if there are tasks in the app",
      (WidgetTester tester) async {
    // Pump the widget tree and await its rendering.
    await tester.pumpWidget(
      MaterialApp(
        // Create a Material app with the specified home widget.
        home: Material(
          child: TaskListItem(
            // Create a TaskListItem widget with a sample Task.
            Task(
              (b) => b
                ..status = 'pending'
                ..uuid = const Uuid().v1()
                ..entry = DateTime.now()
                ..description = 'foo',
            ),
            darkmode: true, // Specify dark mode.
          ),
        ),
      ),
    );
  });
}
