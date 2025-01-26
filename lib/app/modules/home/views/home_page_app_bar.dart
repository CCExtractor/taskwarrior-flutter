// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';
import 'package:taskwarrior/app/utils/taskchampion/taskchampion.dart';
import 'package:taskwarrior/app/utils/taskserver/taskserver.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

import '../controllers/home_controller.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HomeController controller;
  final Server? server;
  final Credentials? credentials;
  const HomePageAppBar(
      {required this.server,
      required this.credentials,
      required this.controller,
      super.key});

  void _showLoadingSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(days: 1),
        backgroundColor: AppSettings.isDarkMode
            ? TaskWarriorColors.ksecondaryBackgroundColor
            : TaskWarriorColors.kLightSecondaryBackgroundColor,
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.white
                    : TaskWarriorColors.black,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              message,
              style: TextStyle(
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.white
                    : TaskWarriorColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResultSnackBar(BuildContext context, String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppSettings.isDarkMode
            ? TaskWarriorColors.ksecondaryBackgroundColor
            : TaskWarriorColors.kLightSecondaryBackgroundColor,
        content: Text(
          message,
          style: TextStyle(
            color: AppSettings.isDarkMode
                ? TaskWarriorColors.white
                : TaskWarriorColors.black,
          ),
        ),
        action: isError
            ? SnackBarAction(
                label: SentenceManager(
                        currentLanguage: controller.selectedLanguage.value)
                    .sentences
                    .homePageSetup,
                onPressed: () {
                  if (controller.taskchampion.value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ManageTaskChampionCreds(),
                        )).then((value) {});
                  } else {
                    Get.toNamed(Routes.MANAGE_TASK_SERVER);
                  }
                },
                textColor: TaskWarriorColors.purple,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
      surfaceTintColor: TaskWarriorColors.kprimaryBackgroundColor,
      title: Center(
        child: Obx(
          () => Text(
            SentenceManager(currentLanguage: controller.selectedLanguage.value)
                .sentences
                .homePageTitle,
            style: TextStyle(
                fontFamily: FontFamily.poppins, color: TaskWarriorColors.white),
          ),
        ),
      ),
      actions: [
        Obx(
          () => IconButton(
            key: controller.searchKey1,
            icon: (controller.searchVisible.value)
                ? Tooltip(
                    message: 'Cancel',
                    child: Icon(Icons.cancel, color: TaskWarriorColors.white))
                : Tooltip(
                    message: 'Search',
                    child: Icon(Icons.search, color: TaskWarriorColors.white)),
            onPressed: controller.toggleSearch,
          ),
        ),
        Builder(
          builder: (context) => Obx(() => IconButton(
                key: controller.refreshKey,
                icon: Icon(Icons.refresh, color: TaskWarriorColors.white),
                onPressed: controller.isRefreshing.value
                    ? null
                    : () async {
                        if (controller.taskchampion.value) {
                          var c = await CredentialsStorage.getClientId();
                          var e =
                              await CredentialsStorage.getEncryptionSecret();
                          if (c != null && e != null) {
                            try {
                              controller.isRefreshing.value = true;
                              _showLoadingSnackBar(
                                  context,
                                  SentenceManager(
                                          currentLanguage:
                                              controller.selectedLanguage.value)
                                      .sentences
                                      .homePageFetchingTasks);

                              await controller.refreshTasks(c, e);

                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();

                              _showResultSnackBar(
                                  context,
                                  SentenceManager(
                                          currentLanguage:
                                              controller.selectedLanguage.value)
                                      .sentences
                                      .homePageFetchingTasks,
                                  false);
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              _showResultSnackBar(
                                  context,
                                  SentenceManager(
                                          currentLanguage:
                                              controller.selectedLanguage.value)
                                      .sentences
                                      .homePageTaskWarriorNotConfigured,
                                  true);
                            } finally {
                              controller.isRefreshing.value = false;
                            }
                          } else if (c == null || e == null) {
                            _showResultSnackBar(
                                context,
                                SentenceManager(
                                        currentLanguage:
                                            controller.selectedLanguage.value)
                                    .sentences
                                    .homePageTaskWarriorNotConfigured,
                                true);
                          }
                        } else {
                          if (server != null || credentials != null) {
                            controller.isRefreshing.value = true;
                            try {
                              await controller.synchronize(context, true);
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              _showResultSnackBar(
                                  context,
                                  SentenceManager(
                                          currentLanguage:
                                              controller.selectedLanguage.value)
                                      .sentences
                                      .homePageTaskWarriorNotConfigured,
                                  true);
                            } finally {
                              controller.isRefreshing.value = false;
                            }
                          } else {
                            _showResultSnackBar(
                                context,
                                SentenceManager(
                                        currentLanguage:
                                            controller.selectedLanguage.value)
                                    .sentences
                                    .homePageTaskWarriorNotConfigured,
                                true);
                          }
                        }
                      },
              )),
        ),
        Builder(
          builder: (context) => IconButton(
            key: controller.filterKey,
            icon: Obx(
              () => Tooltip(
                message: SentenceManager(
                        currentLanguage: controller.selectedLanguage.value)
                    .sentences
                    .homePageFilter,
                child: Icon(Icons.filter_list, color: TaskWarriorColors.white),
              ),
            ),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      ],
      leading: Builder(
        builder: (context) => IconButton(
          key: controller.menuKey,
          icon: Obx(
            () => Tooltip(
                message: SentenceManager(
                        currentLanguage: controller.selectedLanguage.value)
                    .sentences
                    .homePageMenu,
                child: Icon(Icons.menu, color: TaskWarriorColors.white)),
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
