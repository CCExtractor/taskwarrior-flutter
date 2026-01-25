import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    AppSettings.use24HourFormatRx.value = false;
  });

  test('DateFormat should respect 24-hour format setting', () {
    // Test date: May 15, 2023, 2:30 PM / 14:30
    final dateTime = DateTime(2023, 5, 15, 14, 30);

    // Test with 12-hour format
    AppSettings.use24HourFormatRx.value = false;
    final format12h = DateFormat(AppSettings.use24HourFormatRx.value
        ? 'yyyy-MM-dd HH:mm'
        : 'yyyy-MM-dd hh:mm a');
    String formatted12h = format12h.format(dateTime);
    expect(formatted12h, contains('02:30 PM'));
    expect(formatted12h, isNot(contains('14:30')));

    // Test with 24-hour format
    AppSettings.use24HourFormatRx.value = true;
    final format24h = DateFormat(AppSettings.use24HourFormatRx.value
        ? 'yyyy-MM-dd HH:mm'
        : 'yyyy-MM-dd hh:mm a');
    String formatted24h = format24h.format(dateTime);
    expect(formatted24h, contains('14:30'));
    expect(formatted24h, isNot(contains('PM')));
    expect(formatted24h, isNot(contains('AM')));
  });

  test('DateTime formatting in detail view should respect 24-hour format', () {
    // Test date: May 15, 2023, 2:30 PM / 14:30
    final dateTime = DateTime(2023, 5, 15, 14, 30);

    // Test with 12-hour format
    AppSettings.use24HourFormatRx.value = false;
    final format12h = DateFormat(AppSettings.use24HourFormatRx.value
        ? 'EEE, yyyy-MM-dd HH:mm:ss'
        : 'EEE, yyyy-MM-dd hh:mm:ss a');
    String formatted12h = format12h.format(dateTime);
    expect(formatted12h, contains('02:30:00 PM'));
    expect(formatted12h, isNot(contains('14:30:00')));

    // Test with 24-hour format
    AppSettings.use24HourFormatRx.value = true;
    final format24h = DateFormat(AppSettings.use24HourFormatRx.value
        ? 'EEE, yyyy-MM-dd HH:mm:ss'
        : 'EEE, yyyy-MM-dd hh:mm:ss a');
    String formatted24h = format24h.format(dateTime);
    expect(formatted24h, contains('14:30:00'));
    expect(formatted24h, isNot(contains('PM')));
  });
}
