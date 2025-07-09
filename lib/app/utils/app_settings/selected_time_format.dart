part of 'app_settings.dart';

class SelectedTimeFormat {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future saveTimeFormat(bool mode) async {
    await _preferences?.setBool('24hourformate', mode);
  }

  static bool? getTimeFormat() {
    return _preferences?.getBool('24hourformate');
  }
}
