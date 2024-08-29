import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

class AboutController extends GetxController {
  final Rx<SupportedLanguage> selectedLanguage = SupportedLanguage.english.obs;

  @override
  void onInit() {
    super.onInit();
    initLanguage();
  }

  void initLanguage() {
    selectedLanguage.value = AppSettings.selectedLanguage;
  }
}
