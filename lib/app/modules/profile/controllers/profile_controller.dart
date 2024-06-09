import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';

class ProfileController extends GetxController {
  var profilesWidget = Get.find<SplashController>();
  late RxMap<String, String?> profilesMap;
  late RxString currentProfile;
  @override
  void onInit() {
    profilesMap = profilesWidget.profilesMap;
    currentProfile = profilesWidget.currentProfile;
    super.onInit();
  }
}
