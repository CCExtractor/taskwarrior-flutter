part of 'app_settings.dart';

class SelectedTheme {
  static late SharedPreferences _prefs;
  static const _keyTheme = 'isDarkMode';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool? getMode() {
    return _prefs.getBool(_keyTheme);
  }

  static Future saveMode(bool isDark) async {
    await _prefs.setBool(_keyTheme, isDark);
  }
}
