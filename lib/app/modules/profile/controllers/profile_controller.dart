import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/tour/profile_page_tour.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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

  late TutorialCoachMark tutorialCoachMark;

  final GlobalKey currentProfileKey = GlobalKey();

  final GlobalKey addNewProfileKey = GlobalKey();
  final GlobalKey manageSelectedProfileKey = GlobalKey();

  void initProfilePageTour() {
    tutorialCoachMark = TutorialCoachMark(
      targets: addProfilePage(
        currentProfileKey: currentProfileKey,
        addNewProfileKey: addNewProfileKey,
        manageSelectedProfileKey: manageSelectedProfileKey,
      ),
      colorShadow: TaskWarriorColors.black,
      paddingFocus: 10,
      opacityShadow: 1.00,
      hideSkip: true,
      onFinish: () {
        SaveTourStatus.saveProfileTourStatus(true);
      },
    );
  }

  void showProfilePageTour(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        SaveTourStatus.getProfileTourStatus().then((value) => {
              if (value == false && context.mounted)
                {
                  tutorialCoachMark.show(context: context),
                }
              else
                {
                  // ignore: avoid_print
                  debugPrint('User has seen this page'),
                }
            });
      },
    );
  }
}
