import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/permission/views/permission_section.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import '../controllers/permission_controller.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

class PermissionView extends GetView<PermissionController> {
  const PermissionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/home');
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.kLightPrimaryBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .permissionPageTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? TaskWarriorColors.kprimaryTextColor
                            : TaskWarriorColors.kLightPrimaryTextColor,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Icon(
                  Icons.security,
                  size: 64,
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.black
                      : TaskWarriorColors.white,
                ),
                const SizedBox(height: 32),
                PermissionSection(
                  icon: Icons.folder_outlined,
                  title: SentenceManager(
                          currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .storagePermissionTitle,
                  description: SentenceManager(
                          currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .storagePermissionDescription,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 24),
                PermissionSection(
                  icon: Icons.notifications_outlined,
                  title: SentenceManager(
                          currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .notificationPermissionTitle,
                  description: SentenceManager(
                          currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .notificationPermissionDescription,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 24),
                Text(
                  SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .privacyStatement,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.black
                            : TaskWarriorColors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.requestPermissions,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: AppSettings.isDarkMode
                            ? TaskWarriorColors.black
                            : TaskWarriorColors.white,
                        foregroundColor: AppSettings.isDarkMode
                            ? TaskWarriorColors.kprimaryTextColor
                            : TaskWarriorColors.kLightPrimaryTextColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? CircularProgressIndicator(
                              color: AppSettings.isDarkMode
                                  ? TaskWarriorColors.black
                                  : TaskWarriorColors.white,
                            )
                          : Text(
                              SentenceManager(
                                      currentLanguage:
                                          AppSettings.selectedLanguage)
                                  .sentences
                                  .grantPermissions,
                              style: TextStyle(
                                color: AppSettings.isDarkMode
                                    ? TaskWarriorColors.kprimaryTextColor
                                    : TaskWarriorColors.kLightPrimaryTextColor,
                                fontSize: 16,
                              ),
                            ),
                    )),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => controller.gotoHome(),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(TaskWarriorColors.grey),
                  ),
                  child: Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .managePermissionsLater,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppSettings.isDarkMode
                              ? TaskWarriorColors.black
                              : TaskWarriorColors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
