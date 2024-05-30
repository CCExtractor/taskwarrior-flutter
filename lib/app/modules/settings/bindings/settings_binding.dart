import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SettingsController>(
      SettingsController(),
    );
  }
}
