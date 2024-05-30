import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/onboarding/controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<OnboardingController>();
  }
}
