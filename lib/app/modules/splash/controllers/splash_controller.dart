// ignore_for_file: body_might_complete_normally_catch_error, depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/models/storage.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/taskfunctions/profiles.dart';
import 'package:taskwarrior/app/services/deep_link_service.dart';

class SplashController extends GetxController {
  late Rx<Directory> baseDirectory = Directory('').obs;
  late RxMap<String, String?> profilesMap = <String, String?>{}.obs;
  late RxString currentProfile = ''.obs;

  Profiles get _profiles => Profiles(baseDirectory.value);

  @override
  void onInit() {
    debugPrint("🚀 BOOT: SplashController.onInit()");
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();

    await initBaseDir();
    _checkProfiles();
    profilesMap.value = _profiles.profilesMap();
    currentProfile.value = _profiles.getCurrentProfile()!;

    final deepLinkService = Get.find<DeepLinkService>();
    if (deepLinkService.queuedUri != null) {
      debugPrint("🚀 TRACE: Bypassing Splash routing for queued URI");
      Get.offNamed(Routes.HOME);
      return;
    }

    await checkForUpdate();
    sendToNextPage();
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
    Get.find<HomeController>().changeInDirectory();
  }

  void addProfile() {
    _profiles.addProfile();
    profilesMap.value = _profiles.profilesMap();
  }

  Future<void> copyConfigToNewProfile(String profile) async {
    await _profiles.copyConfigToNewProfile(profile);
    profilesMap.value = _profiles.profilesMap();
  }

  Future<void> deleteProfile(String profile) async {
    await _profiles.deleteProfile(profile);
    _checkProfiles();
    profilesMap.value = _profiles.profilesMap();
    // Activate whichever profile is now current. Without this the home list
    // kept showing the deleted profile's tasks until the app was restarted:
    // only `currentProfile` changed, while the mode flags and the task lists
    // stayed on the old profile (see [switching]).
    await switching(_profiles.getCurrentProfile()!);
  }

  void renameProfile({required String profile, required String? alias}) {
    _profiles.setAlias(profile: profile, alias: alias!);
    profilesMap.value = _profiles.profilesMap();
  }

  void selectProfile(String profile) async {
    await switching(profile);
  }

  /// Makes [profile] the active profile and reloads the home state for its
  /// sync mode.
  ///
  /// Shared by [selectProfile] (a manual switch) and [deleteProfile] (deleting
  /// the current profile must activate the next one). Keeping this in one place
  /// is what stops the two paths from drifting: deletion used to only re-point
  /// `currentProfile`, so the TaskChampion/replica task lists kept the deleted
  /// profile's tasks and the mode flags stayed on the old profile.
  Future<void> switching(String profile) async {
    _profiles.setCurrentProfile(profile);
    final String mode = getMode(profile);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('settings_taskc', mode == 'TW3');
    await prefs.setBool('settings_taskr_repl', mode == 'TW3C');

    final HomeController home = Get.find<HomeController>();
    home.taskchampion.value = mode == 'TW3';
    home.taskReplica.value = mode == 'TW3C';

    // Discard the previous profile's tasks before loading the new profile's,
    // so a switch can never show a stale list from the old profile.
    home.tasks.clear();
    home.tasksFromReplica.clear();

    // Set currentProfile before reloading: the TW2 path builds its storage
    // path from it, and the TaskChampion/replica paths resolve the profile
    // from the `current-profile` file written above.
    currentProfile.value = _profiles.getCurrentProfile()!;

    await home.refreshTaskList();
  }

  String getMode(String profile) {
    return _profiles.getMode(profile) ?? 'TW2';
  }

  void changeModeTo(String profile, String mode) {
    _profiles.setModeTo(profile, mode);
    // Only refresh the live app state (HomeController's mode flags, task
    // list, etc.) when the profile whose mode just changed is the one
    // actually active. selectProfile() unconditionally clears
    // HomeController.tasks as a side effect, so calling it for an unrelated,
    // inactive profile would wipe the currently-active profile's visible
    // task list even though nothing about it changed.
    if (profile == currentProfile.value) {
      selectProfile(profile);
    }
    profilesMap.value = _profiles.profilesMap();
  }

  Map<String, String?> getTaskcCreds(String profile) {
    return _profiles.getTaskcCreds(profile);
  }

  void setTaskcCreds(
      String profile, String clientId, String clientSecret, String apiUrl) {
    _profiles.setTaskcCreds(profile, clientId, clientSecret, apiUrl);
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
