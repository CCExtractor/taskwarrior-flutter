import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';

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

class SelectedLanguage {
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

class SaveTourStatus {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future saveReportsTourStatus(bool status) async {
    await _preferences?.setBool('reports_tour', status);
  }

  static Future<bool> getReportsTourStatus() async {
    return _preferences?.getBool('reports_tour') ?? false;
  }

  static Future saveInAppTourStatus(bool status) async {
    await _preferences?.setBool('tour', status);
  }

  static Future<bool> getInAppTourStatus() async {
    return _preferences?.getBool('tour') ?? false;
  }

  static Future saveFilterTourStatus(bool status) async {
    await _preferences?.setBool('filter_tour', status);
  }

  static Future<bool> getFilterTourStatus() async {
    return _preferences?.getBool('filter_tour') ?? false;
  }
}

class AppSettings {
  static bool isDarkMode = true;
  static SupportedLanguage selectedLanguage = SupportedLanguage.english;

  static Future init() async {
    await SelectedTheme.init();
    await SelectedLanguage.init();
    await SaveTourStatus.init();

    isDarkMode = SelectedTheme.getMode() ?? true;
    selectedLanguage =
        SelectedLanguage.getSelectedLanguage() ?? SupportedLanguage.english;
  }

  static Future saveSettings(
      bool isDarkMode, SupportedLanguage language) async {
    await SelectedTheme.saveMode(isDarkMode);
    await SelectedLanguage.saveSelectedLanguage(language);
  }
}
