import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';

void main() {
  group('SelectedLanguage', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SelectedLanguage.init();
    });

    test('should save and retrieve selected language correctly', () async {
      await SelectedLanguage.saveSelectedLanguage(SupportedLanguage.spanish);
      expect(SelectedLanguage.getSelectedLanguage(), SupportedLanguage.spanish);

      await SelectedLanguage.saveSelectedLanguage(SupportedLanguage.english);
      expect(SelectedLanguage.getSelectedLanguage(), SupportedLanguage.english);
    });
  });
}
