
import 'package:shared_preferences/shared_preferences.dart';


class selectedTheme {

  static SharedPreferences? _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future saveMode(bool mode) async =>
      await _preferences?.setBool('_isDark', mode);

  static bool? getMode() => _preferences?.getBool('_isDark');
}

class AppSettings {
  static bool isDarkMode = selectedTheme.getMode()?? true;
}


