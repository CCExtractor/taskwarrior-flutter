part of 'app_settings.dart';

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
