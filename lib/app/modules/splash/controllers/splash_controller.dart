// ignore_for_file: body_might_complete_normally_catch_error, depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/models/storage.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/taskfunctions/profiles.dart';

class SplashController extends GetxController {
  late Rx<Directory> baseDirectory = Directory('').obs;
  late RxMap<String, String?> profilesMap = <String, String?>{}.obs;
  late RxString currentProfile = ''.obs;

  Profiles get _profiles => Profiles(baseDirectory.value);

  @override
  void onInit() async {
    super.onInit();
    await checkForUpdate();
    initBaseDir().then((_) {
      _checkProfiles();
      profilesMap.value = _profiles.profilesMap();
      currentProfile.value = _profiles.getCurrentProfile()!;
      sendToNextPage();
    });
  }

  Future<void> initBaseDir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? directory = prefs.getString('baseDirectory');
    Directory dir = (directory != null)
        ? Directory(directory)
        : await getDefaultDirectory();
    baseDirectory.value = dir;
  }

  void _checkProfiles() {
    if (_profiles.profilesMap().isEmpty) {
      _profiles.setCurrentProfile(_profiles.addProfile());
    } else if (!_profiles
        .profilesMap()
        .containsKey(_profiles.getCurrentProfile())) {
      _profiles.setCurrentProfile(_profiles.profilesMap().keys.first);
    }
  }

  Future<Directory> getDefaultDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  void setBaseDirectory(Directory newBaseDirectory) {
    baseDirectory.value = newBaseDirectory;
    profilesMap.value = _profiles.profilesMap();
  }

  void addProfile() {
    _profiles.addProfile();
    profilesMap.value = _profiles.profilesMap();
  }

  void copyConfigToNewProfile(String profile) {
    _profiles.copyConfigToNewProfile(profile);
    profilesMap.value = _profiles.profilesMap();
  }

  void deleteProfile(String profile) {
    _profiles.deleteProfile(profile);
    _checkProfiles();
    profilesMap.value = _profiles.profilesMap();
    currentProfile.value = _profiles.getCurrentProfile()!;
  }

  void renameProfile({required String profile, required String? alias}) {
    _profiles.setAlias(profile: profile, alias: alias!);
    profilesMap.value = _profiles.profilesMap();
  }

  void selectProfile(String profile) {
    _profiles.setCurrentProfile(profile);
    currentProfile.value = _profiles.getCurrentProfile()!;
  }

  Storage getStorage(String profile) {
    return _profiles.getStorage(profile);
  }

  RxBool hasCompletedOnboarding = false.obs;

  Future<void> checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    hasCompletedOnboarding.value =
        prefs.getBool('onboarding_completed') ?? false;
  }

  void sendToNextPage() async {
    await checkOnboardingStatus();
    if (hasCompletedOnboarding.value) {
      Get.offNamed(Routes.HOME);
    } else {
      Get.offNamed(Routes.ONBOARDING);
    }
  }

  Future<void> checkForUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          InAppUpdate.performImmediateUpdate().catchError((e) {
            debugPrint(e.toString());
          });
        } else if (updateInfo.flexibleUpdateAllowed) {
          InAppUpdate.startFlexibleUpdate().then((_) {
            InAppUpdate.completeFlexibleUpdate().catchError((e) {
              debugPrint(e.toString());
            });
          }).catchError((e) {
            debugPrint(e.toString());
          });
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
