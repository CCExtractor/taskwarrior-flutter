// Import necessary packages and libraries for testing.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/widgets/profilefunctions/selectprofile.dart';

void main() {
  // Test case for testing the Profile Selection widget.
  testWidgets('Profile selection widget test', (WidgetTester tester) async {
    // Pump the widget tree and await its rendering.
    await tester.pumpWidget(
      MaterialApp(
        // Create a Material app with the specified home widget.
        home: Scaffold(
          body: SelectProfile(
            'currentProfile', // Provide the current profile value.
            const {
              'profile1': 'Profile 1',
              'profile2': 'Profile 2'
            }, // Provide a map of profile data.
            (String profile) {}, // Provide a callback function.
          ),
        ),
      ),
    );

    // Expect to find the text 'Profile:' in the widget tree.
    expect(find.text('Profile:'), findsOneWidget);
  });

  // Test case for testing the Manage Selected Profile widget.
  testWidgets('Manage selected profile widget test',
      (WidgetTester tester) async {
    // Build the SelectProfileListTile widget.
    await tester.pumpWidget(
      MaterialApp(
        // Create a Material app with the specified home widget.
        home: Scaffold(
          body: SelectProfileListTile(
            '12h3fh3he-2b2b2ibdkb-sndh3dh34', // Provide a unique identifier.
            'uuid', // Provide a UUID.
            () {}, // Provide a callback function.
            'Alias', // Provide an alias value.
          ),
        ),
      ),
    );

    // Expect to find the text 'Alias' and 'uuid' in the widget tree.
    expect(find.text('Alias'), findsOneWidget);
    expect(find.text('uuid'), findsOneWidget);
  });
}
