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
      expect(age(dt), startsWith('2y ago ('));
    });

    test('age function should return correct string for months', () {
      final now = DateTime.now();
      final dt = now.subtract(const Duration(days: 2 * 30));
      expect(age(dt), startsWith('2mo ago ('));
    });

    test('age function should return correct string for weeks', () {
      final now = DateTime.now();
      final dt = now.subtract(const Duration(days: 2 * 7));
      expect(age(dt), startsWith('2w ago ('));
    });

    test('age function should return correct string for days', () {
      final now = DateTime.now();
      final dt = now.subtract(const Duration(days: 2)); // 2 days
      expect(age(dt), startsWith('2d ago ('));
    });

    test('age function should return correct string for hours', () {
      final now = DateTime.now();
      final dt = now.subtract(const Duration(hours: 2)); // 2 hours
      expect(age(dt), startsWith('2h ago ('));
    });

    test('age function should return correct string for minutes', () {
      final now = DateTime.now();
      final dt = now.subtract(const Duration(minutes: 2)); // 2 minutes
      expect(age(dt), startsWith('2min ago ('));
    });

    test('age function should return correct string for seconds', () {
      final now = DateTime.now();
      final dt = now.subtract(const Duration(seconds: 2)); // 2 seconds
      expect(age(dt), startsWith('2s ago ('));
    });

    test('age function should respect use24HourFormat app setting', () {
      final now = DateTime.now();
      final dt = now.subtract(const Duration(days: 2)); // 2 days

      // Test with 12-hour format
      AppSettings.use24HourFormatRx.value = false;
      expect(age(dt), contains('2d'));
      expect(age(dt), matches(r'.*\d{1,2}:\d{2} [AP]M\)'));

      // Test with 24-hour format
      AppSettings.use24HourFormatRx.value = true;
      expect(age(dt), contains('2d'));
      expect(age(dt), matches(r'.*\d{1,2}:\d{2}\)'));
    });

    test('when function should return correct string for future dates', () {
      final now = DateTime.now();
      final dt =
          now.add(const Duration(days: 1, hours: 12)); // 1+ days from now
      expect(when(dt), startsWith('1d ('));
    });

    test('when function should respect use24HourFormat app setting', () {
      final now = DateTime.now();
      final dt =
          now.add(const Duration(days: 1, hours: 12)); // 1+ days from now

      // Test with 12-hour format
      AppSettings.use24HourFormatRx.value = false;
      expect(when(dt), contains('1d'));
      expect(when(dt), matches(r'.*\d{1,2}:\d{2} [AP]M\)'));

      // Test with 24-hour format
      AppSettings.use24HourFormatRx.value = true;
      expect(when(dt), contains('1d'));
      expect(when(dt), matches(r'.*\d{1,2}:\d{2}\)'));
    });
  });
}
