part of 'app_settings.dart';

class SelectedLanguage {
  static late SharedPreferences _prefs;
  static const _keyLanguage = 'selectedLanguage';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SupportedLanguage? getSelectedLanguage() {
    final langString = _prefs.getString(_keyLanguage);
    if (langString == null) return null;
    return SupportedLanguageExtension.fromString(langString);
  }

  static Future saveSelectedLanguage(SupportedLanguage lang) async {
    await _prefs.setString(_keyLanguage, lang.toShortString());
  }
}
