import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskfunctions/datetime_differences.dart';

void main() {
  group('DateTime Functions Tests', () {
    test('Test age function', () {
      DateTime dt = DateTime.now().subtract(const Duration(days: 365));
      String result = age(dt);
      expect(result, contains('12mo '));

      dt = DateTime.now().subtract(const Duration(days: 60));
      result = age(dt);
      expect(result, contains('2mo '));

      dt = DateTime.now().subtract(const Duration(days: 21));
      result = age(dt);
      expect(result, contains('3w '));

      dt = DateTime.now().subtract(const Duration(days: 4));
      result = age(dt);
      expect(result, contains('4d '));

      dt = DateTime.now().subtract(const Duration(hours: 5));
      result = age(dt);
      expect(result, contains('5h '));

      dt = DateTime.now().subtract(const Duration(minutes: 10));
      result = age(dt);
      expect(result, contains('10min '));

      dt = DateTime.now().subtract(const Duration(seconds: 30));
      result = age(dt);
      expect(result, contains('30s '));
    });

    test('Test when function', () {
      DateTime dt = DateTime.now().add(const Duration(days: 365));
      String result = when(dt);
      expect(result, contains('12mo'));

      dt = DateTime.now().add(const Duration(days: 60));
      result = when(dt);
      expect(result, contains('1mo'));

      dt = DateTime.now().add(const Duration(days: 21));
      result = when(dt);
      expect(result, contains('2w'));

      dt = DateTime.now().add(const Duration(days: 4));
      result = when(dt);
      expect(result, contains('3d'));

      dt = DateTime.now().add(const Duration(hours: 5));
      result = when(dt);
      expect(result, contains('4h'));

      dt = DateTime.now().add(const Duration(minutes: 10));
      result = when(dt);
      expect(result, contains('9min'));

      dt = DateTime.now().add(const Duration(seconds: 30));
      result = when(dt);
      expect(result, contains('29s'));
    });

    test('Test difference function', () {
      DateTime dt = DateTime.now().subtract(const Duration(days: 365));
      String result = difference(DateTime.now().difference(dt));
      expect(result, contains('12mo '));

      dt = DateTime.now().subtract(const Duration(days: 60));
      result = difference(DateTime.now().difference(dt));
      expect(result, contains('2mo '));

      dt = DateTime.now().subtract(const Duration(days: 21));
      result = difference(DateTime.now().difference(dt));
      expect(result, contains('3w '));

      dt = DateTime.now().subtract(const Duration(days: 4));
      result = difference(DateTime.now().difference(dt));
      expect(result, contains('4d '));

      dt = DateTime.now().subtract(const Duration(hours: 5));
      result = difference(DateTime.now().difference(dt));
      expect(result, contains('5h '));

      dt = DateTime.now().subtract(const Duration(minutes: 10));
      result = difference(DateTime.now().difference(dt));
      expect(result, contains('10min '));

      dt = DateTime.now().subtract(const Duration(seconds: 30));
      result = difference(DateTime.now().difference(dt));
      expect(result, contains('30s '));
    });
  });
}
