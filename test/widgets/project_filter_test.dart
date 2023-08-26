// Import necessary packages and libraries for testing.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/widgets/project_filter.dart';
import 'package:taskwarrior/widgets/taskfunctions/projects.dart';

void main() {
  // Define a test case for testing the "Projects Column" widget.
  testWidgets('test project column widget', (WidgetTester tester) async {
    // Pump the widget tree and await its rendering.
    await tester.pumpWidget(
      MaterialApp(
        // Create a Material app with the specified home widget.
        home: Material(
          child: ProjectsColumn(
            {
              'a': ProjectNode()
                ..children = {'a.b'}, // Provide project hierarchy.
              'a.b': ProjectNode()
                ..parent = 'a', // Provide sub-project hierarchy.
            },
            'foo', // Provide the currently selected project.
            (_) {}, // Provide a callback function.
          ),
        ),
      ),
    );

    // Simulate a tap on the 'project:foo' text.
    await tester.tap(find.text('project:foo'));
    await tester.pump();

    // Expect to find the text 'a' and '0' in the widget tree.
    expect(find.text('a'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    // Ensure 'a' is visible and wait for animations to settle.
    await tester.ensureVisible(find.text('a'));
    await tester.pumpAndSettle();

    // Simulate a tap on the 'a' text.
    await tester.tap(find.text('a'));

    // Expect to find the text 'a.b' in the widget tree.
    expect(find.text('a.b'), findsOneWidget);

    // Simulate a tap on the 'a.b' text.
    await tester.tap(find.text('a.b'));
  });
}
