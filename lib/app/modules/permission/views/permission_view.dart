import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/permission/views/permission_section.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import '../controllers/permission_controller.dart';

class PermissionView extends GetView<PermissionController> {
  const PermissionView({super.key});

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/home');
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: tColors.primaryBackgroundColor,
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
                        color: tColors.primaryTextColor,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Icon(
                  Icons.security,
                  size: 64,
                  color: tColors.primaryTextColor,
                ),
                const SizedBox(height: 32),
                const PermissionSection(
                    icon: Icons.folder_outlined,
                    title: 'Storage Permission',
                    description:
                        'We use storage access to save your tasks, preferences, '
                        'and app data securely on your device. This ensures that you can '
                        'pick up where you left off seamlessly, even offline.'),
                const SizedBox(height: 24),
                const PermissionSection(
                    icon: Icons.notifications_outlined,
                    title: 'Notification Permission',
                    description:
                        'Notifications keep you updated with important reminders '
                        'and updates, ensuring you stay on top of your tasks effortlessly.'),
                const SizedBox(height: 24),
                Text(
                  'Your privacy is our top priority. We never access or share your '
                  'personal files or data without your consent.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: tColors.primaryTextColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.requestPermissions,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: tColors.primaryBackgroundColor,
                        foregroundColor: tColors.primaryTextColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? CircularProgressIndicator(
                              color: tColors.primaryBackgroundColor,
                            )
                          : Text(
                              'Grant Permissions',
                              style: TextStyle(
                                color: tColors.primaryTextColor,
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
                          color: tColors.primaryTextColor,
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
