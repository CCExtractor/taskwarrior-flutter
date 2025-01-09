import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';

void main() {
  group('Utils', () {
    test('should return the correct week number as string', () {
      DateTime date = DateTime(2024, 12, 15);
      expect(Utils.getWeekNumber(date), '50');
    });

    test('should return the correct week number as integer', () {
      DateTime date = DateTime(2024, 12, 15);
      expect(Utils.getWeekNumbertoInt(date), 50);
    });

    test('should format date correctly', () {
      DateTime date = DateTime(2024, 12, 15);
      String pattern = 'yyyy-MM-dd';
      expect(Utils.formatDate(date, pattern), '2024-12-15');
    });

    test('should return the correct month name', () {
      expect(Utils.getMonthName(1), 'January');
      expect(Utils.getMonthName(2), 'February');
      expect(Utils.getMonthName(3), 'March');
      expect(Utils.getMonthName(4), 'April');
      expect(Utils.getMonthName(5), 'May');
      expect(Utils.getMonthName(6), 'June');
      expect(Utils.getMonthName(7), 'July');
      expect(Utils.getMonthName(8), 'August');
      expect(Utils.getMonthName(9), 'September');
      expect(Utils.getMonthName(10), 'October');
      expect(Utils.getMonthName(11), 'November');
      expect(Utils.getMonthName(12), 'December');
      expect(Utils.getMonthName(0), '');
    });

    testWidgets('should create an AlertDialog', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Utils.showAlertDialog(
                        title: const Text('Test Dialog'),
                        content: const Text('This is a test dialog'),
                      );
                    },
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pump();

      expect(find.text('Test Dialog'), findsOneWidget);
      expect(find.text('This is a test dialog'), findsOneWidget);
    });
  });
}
