part of 'app_settings.dart';

class SelectedLanguage {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future saveSelectedLanguage(SupportedLanguage language) async {
    if (language == SupportedLanguage.system) {
      await _preferences?.remove('_selectedLanguage');
      return;
    }
    await _preferences?.setString('_selectedLanguage', language.languageCode);
  }

  static SupportedLanguage? getSelectedLanguage() {
    String? languageCode = _preferences?.getString('_selectedLanguage');
    return SupportedLanguageExtension.fromCode(languageCode);
  }

  static String? getRawCode() {
    return _preferences?.getString('_selectedLanguage');
  }
  static Future clearSelectedLanguage() async {
    await _preferences?.remove('_selectedLanguage');
}
}
