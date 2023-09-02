import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/widgets/profilefunctions/manageprofile.dart';

void main() {
  // Define a test case for the "Manage Profile" widget.
  testWidgets('test manage profile widget', (WidgetTester tester) async {
    // Pump the widget tree and await its rendering.
    await tester.pumpWidget(
      MaterialApp(
        // Create a Material app with the specified home widget.
        home: Material(
          child: ManageProfile(
            () {},
            () {},
            () {},
            () {},
            () {},
          ),
        ),
      ),
    );
  });
}
