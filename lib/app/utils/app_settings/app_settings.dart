import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';

part 'save_tour_status.dart';
part 'selected_theme.dart';
part 'selected_language.dart';

class AppSettings {
  static bool isDarkMode = true;
  static SupportedLanguage selectedLanguage = SupportedLanguage.english;

  static Future init() async {
    await HomeWidget.setAppGroupId("group.taskwarrior");
    await SelectedTheme.init();
    await SelectedLanguage.init();
    await SaveTourStatus.init();

    isDarkMode = SelectedTheme.getMode() ?? true;

    SupportedLanguage? userPreferredLanguage =
        SelectedLanguage.getSelectedLanguage();

    if (userPreferredLanguage != null) {
      selectedLanguage = userPreferredLanguage;
    } else {
      // If no explicit preference, use the system language (if supported)
      selectedLanguage = SupportedLanguageExtension.getSystemLanguage();
      // Save the system language as the user's preference
      await SelectedLanguage.saveSelectedLanguage(selectedLanguage);
    }
  }

  static Future saveSettings(
      bool isDarkMode, SupportedLanguage language) async {
    await SelectedTheme.saveMode(isDarkMode);
    await SelectedLanguage.saveSelectedLanguage(language);
  }
}
