import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';

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
