import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskfunctions/datetime_differences.dart';

void main() {
  group('DateTime Differences', () {
    test('age function should return correct string for years', () {
      final now = DateTime.now();
      final dt = now.subtract(const Duration(days: 2 * 365));
      expect(age(dt), '2y ');
    });

    test('age function should return correct string for months', () {
      final now = DateTime.now();
      final dt = now.subtract(const Duration(days: 2 * 30));
      expect(age(dt), '2mo ');
    });

    test('age function should return correct string for weeks', () {
      final now = DateTime.now();
      final dt = now.subtract(const Duration(days: 2 * 7));
      expect(age(dt), '2w ');
    });

    test('age function should return correct string for days', () {
      final now = DateTime.now();
      final dt = now.subtract(const Duration(days: 2)); // 2 days
      expect(age(dt), '2d ');
    });

    test('age function should return correct string for hours', () {
      final now = DateTime.now();
      final dt = now.subtract(const Duration(hours: 2)); // 2 hours
      expect(age(dt), '2h ');
    });

    test('age function should return correct string for minutes', () {
      final now = DateTime.now();
      final dt = now.subtract(const Duration(minutes: 2)); // 2 minutes
      expect(age(dt), '2min ');
    });

    test('age function should return correct string for seconds', () {
      final now = DateTime.now();
      final dt = now.subtract(const Duration(seconds: 2)); // 2 seconds
      expect(age(dt), '2s ');
    });

    test('when function should return correct string for future dates', () {
      final now = DateTime.now();
      final dt = now.add(const Duration(days: 2)); // 2 days from now
      expect(when(dt), '1d ');
    });

    test(
        'difference function should return correct string for various durations',
        () {
      expect(difference(const Duration(days: 2 * 365)), '2y ');
      expect(difference(const Duration(days: 2 * 30)), '2mo ');
      expect(difference(const Duration(days: 2 * 7)), '2w ');
      expect(difference(const Duration(days: 2)), '2d ');
      expect(difference(const Duration(hours: 2)), '2h ');
      expect(difference(const Duration(minutes: 2)), '2min ');
      expect(difference(const Duration(seconds: 2)), '2s ');

      expect(difference(const Duration(days: -2)), '2d ago ');
      expect(difference(const Duration(hours: -2)), '2h ago ');
      expect(difference(const Duration(minutes: -2)), '2min ago ');
      expect(difference(const Duration(seconds: -2)), '2s ago ');
    });
  });
}
