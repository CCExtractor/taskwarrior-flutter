import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';

void main() {
  group('AppSettings', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await AppSettings.init();
    });

    test('should initialize settings correctly', () async {
      expect(AppSettings.isDarkMode, true);
      expect(AppSettings.selectedLanguage, SupportedLanguage.english);
    });

    test('should save settings correctly', () async {
      await AppSettings.saveSettings(false, SupportedLanguage.english);
      expect(AppSettings.isDarkMode, true);
      expect(AppSettings.selectedLanguage, SupportedLanguage.english);
    });
  });

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
