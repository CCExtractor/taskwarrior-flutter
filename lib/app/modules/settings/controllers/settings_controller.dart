// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';

import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:path/path.dart' as path;

import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class SettingsController extends GetxController {
  RxBool isMovingDirectory = false.obs;

  Rx<SupportedLanguage> selectedLanguage = AppSettings.selectedLanguage.obs;
  RxString baseDirectory = "".obs;

  void setSelectedLanguage(SupportedLanguage language) async {
    await SelectedLanguage.saveSelectedLanguage(language);
    selectedLanguage.value = language;
    AppSettings.selectedLanguage = language;
    Get.find<HomeController>().selectedLanguage.value = language;
  }

  Future<String> getBaseDirectory() async {
    SplashController profilesWidget = Get.find<SplashController>();
    Directory baseDir = profilesWidget.baseDirectory();
    Directory defaultDirectory = await profilesWidget.getDefaultDirectory();
    if (baseDir.path == defaultDirectory.path) {
      return 'Default';
    } else {
      return baseDir.path;
    }
  }

  void pickDirectory(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    FilePicker.platform.getDirectoryPath().then((value) async {
      if (value != null) {
        isMovingDirectory.value = true;
        update();
        // InheritedProfiles profilesWidget = ProfilesWidget.of(context);
        var profilesWidget = Get.find<SplashController>();
        Directory source = profilesWidget.baseDirectory();
  Directory destination = Directory(value);
        moveDirectory(source.path, destination.path).then((value) async {
          isMovingDirectory.value = false;
          update();
          if (value == "same") {
            return;
            } else if (value == "success") {
            profilesWidget.setBaseDirectory(destination);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('baseDirectory', destination.path);
            baseDirectory.value = destination.path;
              Get.snackbar(
                'Success',
                'Base directory moved successfully',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
            } else {
              Get.dialog(
                Utils.showAlertDialog(
                  title: Text(
                    'Error',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: TaskWarriorFonts.fontSizeMedium,
                      color: tColors.primaryTextColor,
                    ),
                  ),
                  content: Text(
                    value == "nested"
                        ? "Cannot move to a nested directory"
                        : value == "not-empty"
                            ? "Destination directory is not empty"
                            : value == "not-permitted"
                                ? "Selected folder can't be written to (Android SAF). Please choose a different folder."
                                : "An error occurred",
                    style: GoogleFonts.poppins(
                      color: TaskWarriorColors.grey,
                      fontSize: TaskWarriorFonts.fontSizeSmall,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'OK',
                        style: GoogleFonts.poppins(
                          color: tColors.primaryTextColor,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
        });
      }
    });
  }

  Future<String> moveDirectory(String fromDirectory, String toDirectory) async {
    if (path.canonicalize(fromDirectory) == path.canonicalize(toDirectory)) {
      return "same";
    }

    if (path.isWithin(fromDirectory, toDirectory)) {
      return "nested";
    }

  Directory toDir = Directory(toDirectory);
  // Ensure destination exists before checking contents
  await toDir.create(recursive: true);
    final length = await toDir.list().length;
    if (length > 0) {
      return "not-empty";
    }

    // Preflight: on Android, check that we can actually write to the chosen directory
    // to avoid crashing with Operation not permitted when a SAF tree URI was selected.
    try {
      final testFile = File(path.join(toDirectory, ".tw_write_test"));
      await toDir.create(recursive: true);
      await testFile.writeAsString("ok");
      await testFile.delete();
    } on FileSystemException catch (e) {
      // Map common permission error to a friendly status
      if (e.osError?.errorCode == 1 ||
          (e.osError?.message.toLowerCase().contains("operation not permitted") ?? false)) {
        return "not-permitted";
      }
      return "error";
    } catch (_) {
      return "error";
    }

    try {
      await moveDirectoryRecurse(fromDirectory, toDirectory);
      return "success";
    } on FileSystemException catch (e) {
      if (e.osError?.errorCode == 1 ||
          (e.osError?.message.toLowerCase().contains("operation not permitted") ?? false)) {
        return "not-permitted";
      }
      return "error";
    } catch (_) {
      return "error";
    }
  }

  // ... no hardcoded SAF path mapping; rely on guard and proper APIs if enabled in future

  Future<void> moveDirectoryRecurse(
      String fromDirectory, String toDirectory) async {
    Directory fromDir = Directory(fromDirectory);
    Directory toDir = Directory(toDirectory);

    // Create the toDirectory if it doesn't exist
    await toDir.create(recursive: true);

    // Loop through each file and directory and move it to the toDirectory
    await for (final entity in fromDir.list()) {
      // Skip flutter runtime assets – they should not be moved
      final relativePath = path.relative(entity.path, from: fromDirectory);
      if (relativePath.split(path.separator).contains('flutter_assets')) {
        continue;
      }
      if (entity is File) {
        // If it's a file, move it to the toDirectory
        File file = entity;
        String newPath = path.join(toDirectory, relativePath);
        await File(newPath).writeAsBytes(await file.readAsBytes());
        await file.delete();
      } else if (entity is Directory) {
        // If it's a directory, create it in the toDirectory and recursively move its contents
        Directory dir = entity;
        String newPath = path.join(toDirectory, relativePath);
        Directory newDir = Directory(newPath);
        await newDir.create(recursive: true);
        await moveDirectoryRecurse(dir.path, newPath);
        await dir.delete();
      }
    }
  }

  RxBool isSyncOnStartActivel = false.obs;
  RxBool isSyncOnTaskCreateActivel = false.obs;
  RxBool delaytask = false.obs;
  RxBool taskchampion = false.obs;
  RxBool isDarkModeOn = false.obs;

  void initDarkMode() {
    isDarkModeOn.value = AppSettings.isDarkMode;
  }

  @override
  void onInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isSyncOnStartActivel.value = prefs.getBool('sync-onStart') ?? false;
    isSyncOnTaskCreateActivel.value =
        prefs.getBool('sync-OnTaskCreate') ?? false;
    delaytask.value = prefs.getBool('delaytask') ?? false;
    taskchampion.value = prefs.getBool('settings_taskc') ?? false;
    initDarkMode();
    baseDirectory.value = await getBaseDirectory();
    super.onInit();
  }
}
