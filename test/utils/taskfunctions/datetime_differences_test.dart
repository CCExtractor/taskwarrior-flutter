import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/taskfunctions/datetime_differences.dart';

void main() {
  setUp(() {
    AppSettings.use24HourFormatRx.value = false;
  });

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

    test('age function should respect use24HourFormat app setting', () {
      final now = DateTime.now();
      final dt = now.subtract(const Duration(days: 2)); // 2 days

      // Test with 12-hour format
      AppSettings.use24HourFormatRx.value = false;
      expect(age(dt), contains('2d'));
      expect(age(dt), contains('(hh:mm a)'));

      // Test with 24-hour format
      AppSettings.use24HourFormatRx.value = true;
      expect(age(dt), contains('2d'));
      expect(age(dt), contains('(HH:mm)'));
    });

    test('when function should return correct string for future dates', () {
      final now = DateTime.now();
      final dt = now.add(const Duration(days: 2)); // 2 days from now
      expect(when(dt), '1d ');
    });

    test('when function should respect use24HourFormat app setting', () {
      final now = DateTime.now();
      final dt = now.add(const Duration(days: 2)); // 2 days from now

      // Test with 12-hour format
      AppSettings.use24HourFormatRx.value = false;
      expect(when(dt), contains('1d'));
      expect(when(dt), contains('(hh:mm a)'));

      // Test with 24-hour format
      AppSettings.use24HourFormatRx.value = true;
      expect(when(dt), contains('1d'));
      expect(when(dt), contains('(HH:mm)'));
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
