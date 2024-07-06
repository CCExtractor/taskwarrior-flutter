export 'package:taskwarrior/app/utils/app_settings/save_tour_status.dart';
export 'package:taskwarrior/app/utils/app_settings/selected_language.dart';
export 'package:taskwarrior/app/utils/app_settings/selected_theme.dart';
export 'package:taskwarrior/app/utils/language/supported_language.dart';
import 'package:taskwarrior/app/utils/app_settings/save_tour_status.dart';
import 'package:taskwarrior/app/utils/app_settings/selected_language.dart';
import 'package:taskwarrior/app/utils/app_settings/selected_theme.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';

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
