import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';

part 'save_tour_status.dart';
part 'selected_theme.dart';
part 'selected_language.dart';
part 'selected_time_format.dart';

class AppSettings {
  static bool isDarkMode = true;
  static SupportedLanguage selectedLanguage = SupportedLanguage.english;
  static final RxBool use24HourFormatRx = false.obs;

  static Future init() async {
    await SelectedTheme.init();
    await SelectedLanguage.init();
    await SaveTourStatus.init();
    await SelectedTimeFormat.init();

    isDarkMode = SelectedTheme.getMode() ?? true;
    selectedLanguage =
        SelectedLanguage.getSelectedLanguage() ?? SupportedLanguage.english;
    use24HourFormatRx.value = SelectedTimeFormat.getTimeFormat() ?? false;
  }

  static Future saveSettings(
      bool isDarkMode, SupportedLanguage language, bool use24hour) async {
    await SelectedTheme.saveMode(isDarkMode);
    await SelectedLanguage.saveSelectedLanguage(language);
    await SelectedTimeFormat.saveTimeFormat(use24hour);
  }
}
