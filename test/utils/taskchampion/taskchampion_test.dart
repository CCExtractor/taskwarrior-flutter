import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/taskchampion/taskchampion.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ManageTaskChampionCreds', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('should load credentials and display them in text fields',
        (WidgetTester tester) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('encryptionSecret', 'testSecret');
      await prefs.setString('clientId', 'testClientId');

      await tester.pumpWidget(MaterialApp(home: ManageTaskChampionCreds()));

      await tester.pump();

      expect(find.text('testSecret'), findsOneWidget);
      expect(find.text('testClientId'), findsOneWidget);
    });

    testWidgets('should save credentials when the save button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: ManageTaskChampionCreds()));

      await tester.enterText(find.byType(TextField).at(0), 'newSecret');
      await tester.enterText(find.byType(TextField).at(1), 'newClientId');

      await tester.tap(find.text('Save Credentials'));
      await tester.pump();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('encryptionSecret'), 'newSecret');
      expect(prefs.getString('clientId'), 'newClientId');
    });

    testWidgets('should show snackbar when credentials are saved',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: ManageTaskChampionCreds()));

      await tester.tap(find.text('Save Credentials'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Credentials saved successfully'), findsOneWidget);
    });
  });
}
