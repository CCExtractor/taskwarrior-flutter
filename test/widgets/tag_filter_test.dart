import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/widgets/tag_filter.dart';

void main() {
  // Define a test case for testing the "Tag Filter" widget.
  testWidgets('test tag filter widget', (WidgetTester tester) async {
    // Pump the widget tree and await its rendering.
    await tester.pumpWidget(
      MaterialApp(
        // Create a Material app with the specified home widget.
        home: Material(
          child: TagFiltersWrap(
            // Build the TagFilters widget with specific configuration.
            TagFilters(
              tagUnion: false, // Set tag union value.
              toggleTagUnion:
                  () {}, // Provide a callback for toggling tag union.
              tags: {
                'Tag': const TagFilterMetadata(
                    display: 'Tag',
                    selected: false), // Provide tag filter metadata.
              },
              toggleTagFilter:
                  (_) {}, // Provide a callback for toggling tag filter.
            ),
          ),
        ),
      ),
    );

    // Expect to find the text 'AND' in the widget tree.
    expect(find.text('AND'), findsOneWidget);

    // Simulate tapping on the 'AND' text.
    await tester.tap(find.text('AND'));
    await tester.pump();

    // Expect to find the text 'Tag' in the widget tree.
    expect(find.text('Tag'), findsOneWidget);

    // Simulate tapping on the 'Tag' text.
    await tester.tap(find.text('Tag'));
  });
}
