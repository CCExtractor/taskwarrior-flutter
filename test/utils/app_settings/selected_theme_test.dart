import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

void main() {
  group('SelectedTheme', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SelectedTheme.init();
    });

    test('should save and retrieve theme mode correctly', () async {
      await SelectedTheme.saveMode(false);
      expect(SelectedTheme.getMode(), false);

      await SelectedTheme.saveMode(true);
      expect(SelectedTheme.getMode(), true);
    });
  });
}
