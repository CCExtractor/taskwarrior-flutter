import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/constants/supported_language.dart';

class SelectedTheme {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future saveMode(bool mode) async {
    await _preferences?.setBool('_isDark', mode);
  }

  static bool? getMode() {
    return _preferences?.getBool('_isDark');
  }
}

class LanguageSettings {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future saveSelectedLanguage(SupportedLanguage language) async {
    await _preferences?.setString('_selectedLanguage', language.languageCode);
  }

  static SupportedLanguage? getSelectedLanguage() {
    String? languageCode = _preferences?.getString('_selectedLanguage');
    return SupportedLanguageExtension.fromCode(languageCode);
  }
}

class AppSettings {
  static bool isDarkMode = true;

  static SupportedLanguage selectedLanguage = SupportedLanguage.english;

  static Future init() async {
    await SelectedTheme.init();
    isDarkMode = SelectedTheme.getMode() ?? true;
    selectedLanguage =
        LanguageSettings.getSelectedLanguage() ?? SupportedLanguage.english;
  }

  static Future saveSettings(
      bool isDarkMode, SupportedLanguage language) async {
    await SelectedTheme.saveMode(isDarkMode);
    await LanguageSettings.saveSelectedLanguage(language);
  }
}
