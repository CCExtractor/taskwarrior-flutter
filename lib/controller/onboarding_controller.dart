import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController {
  RxBool hasCompletedOnboarding = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Check onboarding status when the controller is initialized
    checkOnboardingStatus();
  }

  Future<void> checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the completion status (default to false if not found)
    hasCompletedOnboarding.value =
        prefs.getBool('onboarding_completed') ?? false;
  }

  Future<void> markOnboardingAsCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    // Update the completion status
    hasCompletedOnboarding.value = true;
  }
}
