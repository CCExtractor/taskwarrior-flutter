import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';

part 'save_tour_status.dart';
part 'selected_theme.dart';
part 'selected_language.dart';

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
