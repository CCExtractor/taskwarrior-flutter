import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppSettings.init();
  });

  test('should save and retrieve time format setting', () async {
    // Initially should be false (12-hour format)
    expect(AppSettings.use24HourFormatRx.value, false);

    // Set to true (24-hour format)
    await SelectedTimeFormat.saveTimeFormat(true);
    expect(SelectedTimeFormat.getTimeFormat(), true);

    // Set back to false (12-hour format)
    await SelectedTimeFormat.saveTimeFormat(false);
    expect(SelectedTimeFormat.getTimeFormat(), false);
  });

  test('AppSettings should initialize with the stored time format', () async {
    // Set format to true (24-hour)
    await SelectedTimeFormat.saveTimeFormat(true);

    // Re-initialize and check
    await AppSettings.init();
    expect(AppSettings.use24HourFormatRx.value, true);
  });
}
