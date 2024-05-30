import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/onboarding/controllers/onboarding_controller.dart';

import '../controllers/check_onboarding_status_controller.dart';

class CheckOnboardingStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CheckOnboardingStatusController>(
      CheckOnboardingStatusController(),
    );

    Get.put<OnboardingController>(
      OnboardingController(),
    );

    Get.put(
      HomeController(),
    );
  }
}
