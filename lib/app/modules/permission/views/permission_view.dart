import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import '../controllers/permission_controller.dart';

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
                  'Why We Need Your Permission',
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
                _buildPermissionSection(
                  context,
                  icon: Icons.folder_outlined,
                  title: 'Storage Permission',
                  description:
                      'We use storage access to save your tasks, preferences, '
                      'and app data securely on your device. This ensures that you can '
                      'pick up where you left off seamlessly, even offline.',
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 24),
                _buildPermissionSection(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'Notification Permission',
                  description:
                      'Notifications keep you updated with important reminders '
                      'and updates, ensuring you stay on top of your tasks effortlessly.',
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 24),
                Text(
                  'Your privacy is our top priority. We never access or share your '
                  'personal files or data without your consent.',
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
                              'Grant Permissions',
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
                    'You can manage your permissions anytime later in Settings',
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

  Widget _buildPermissionSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkMode
              ? TaskWarriorColors.ksecondaryBackgroundColor
              : TaskWarriorColors.borderColor,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode
            ? TaskWarriorColors.kdialogBackGroundColor
            : TaskWarriorColors.kLightDialogBackGroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: TaskWarriorColors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? TaskWarriorColors.kprimaryTextColor
                            : TaskWarriorColors.kLightPrimaryTextColor,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode
                      ? TaskWarriorColors.ksecondaryTextColor
                      : TaskWarriorColors.kLightSecondaryTextColor,
                ),
          ),
        ],
      ),
    );
  }
}
