import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';

part 'save_tour_status.dart';
part 'selected_theme.dart';
part 'selected_language.dart';

class AppSettings {
  static bool isDarkMode = true;
  static SupportedLanguage selectedLanguage = SupportedLanguage.english;

  /// Initialize all settings
  static Future init() async {
    await SelectedTheme.init();
    await SelectedLanguage.init();
    await SaveTourStatus.init();

    /// Theme
    isDarkMode = SelectedTheme.getMode() ?? true;

    /// Language
    SupportedLanguage? userPreferredLanguage =
    SelectedLanguage.getSelectedLanguage();

    if (userPreferredLanguage != null) {
      selectedLanguage = userPreferredLanguage;
    } else {
      /// Get system language fallback
      selectedLanguage = SupportedLanguageExtension.getSystemLanguage();

      /// Save system language for next launch
      await SelectedLanguage.saveSelectedLanguage(selectedLanguage);
    }
  }

  /// Save user settings
  static Future saveSettings(
      bool darkMode, SupportedLanguage language) async {
    await SelectedTheme.saveMode(darkMode);
    await SelectedLanguage.saveSelectedLanguage(language);

    isDarkMode = darkMode;
    selectedLanguage = language;
  }
}
