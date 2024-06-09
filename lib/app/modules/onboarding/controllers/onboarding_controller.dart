import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController {
  RxInt currentPage = 0.obs;
  int get getCurrentPage => currentPage.value;

  void setCurrentPage(int newCurrentPage) => currentPage.value = newCurrentPage;
  // Might cause issue
  Future<void> markOnboardingAsCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    update();
  }
}
