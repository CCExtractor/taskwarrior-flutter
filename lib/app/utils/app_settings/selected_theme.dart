part of 'app_settings.dart';

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
