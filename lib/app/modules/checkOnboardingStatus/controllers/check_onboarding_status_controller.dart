import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOnboardingStatusController extends GetxController {
  RxBool hasCompletedOnboarding = false.obs;

  bool get hasCompletedOnboardingStatus => hasCompletedOnboarding.value;

  @override
  void onInit() {
    super.onInit();
    checkOnboardingStatus();
  }

  Future<void> checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    hasCompletedOnboarding.value =
        prefs.getBool('onboarding_completed') ?? false;
  }
}
