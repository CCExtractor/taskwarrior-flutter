import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:taskwarrior/api_service.dart';
import 'package:taskwarrior/app/modules/home/views/home_view.dart';

import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/taskchampion/taskchampion.dart';
import 'package:taskwarrior/app/utils/taskserver/taskserver.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

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
          builder: (context) => IconButton(
            key: controller.refreshKey,
            icon: Icon(Icons.refresh, color: TaskWarriorColors.white),
            onPressed: () async {
              if (controller.taskchampion.value) {
                var c = await CredentialsStorage.getClientId();
                var e = await CredentialsStorage.getEncryptionSecret();
                if (c != null && e != null) {
                  try {
                    List<Tasks> tasks = await fetchTasks(c, e);
                    print(tasks.toList());
                    await updateTasksInDatabase(tasks);
                    print('Tasks updated successfully');
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const HomeView(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ));
                  } catch (e) {
                    print('Failed to update tasks: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppSettings.isDarkMode
                            ? TaskWarriorColors.ksecondaryBackgroundColor
                            : TaskWarriorColors.kLightSecondaryBackgroundColor,
                        content: Text(
                          SentenceManager(
                                  currentLanguage:
                                      controller.selectedLanguage.value)
                              .sentences
                              .homePageTaskWarriorNotConfigured,
                          style: TextStyle(
                            color: AppSettings.isDarkMode
                                ? TaskWarriorColors.white
                                : TaskWarriorColors.black,
                          ),
                        ),
                        action: SnackBarAction(
                          label: SentenceManager(
                                  currentLanguage:
                                      controller.selectedLanguage.value)
                              .sentences
                              .homePageSetup,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const ManageTaskChampionCreds(),
                                )).then((value) {});
                          },
                          textColor: TaskWarriorColors.purple,
                        ),
                      ),
                    );
                  }
                } else if (c == null || e == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppSettings.isDarkMode
                          ? TaskWarriorColors.ksecondaryBackgroundColor
                          : TaskWarriorColors.kLightSecondaryBackgroundColor,
                      content: Text(
                        SentenceManager(
                                currentLanguage:
                                    controller.selectedLanguage.value)
                            .sentences
                            .homePageTaskWarriorNotConfigured,
                        style: TextStyle(
                          color: AppSettings.isDarkMode
                              ? TaskWarriorColors.white
                              : TaskWarriorColors.black,
                        ),
                      ),
                      action: SnackBarAction(
                        label: SentenceManager(
                                currentLanguage:
                                    controller.selectedLanguage.value)
                            .sentences
                            .homePageSetup,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ManageTaskChampionCreds(),
                              )).then((value) {});
                        },
                        textColor: TaskWarriorColors.purple,
                      ),
                    ),
                  );
                }
              } else {
                if (server != null || credentials != null) {
                  controller.synchronize(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Obx(
                        () => Text(
                          SentenceManager(
                                  currentLanguage:
                                      controller.selectedLanguage.value)
                              .sentences
                              .homePageTaskWarriorNotConfigured,
                          style: TextStyle(
                            color: AppSettings.isDarkMode
                                ? TaskWarriorColors.white
                                : TaskWarriorColors.black,
                          ),
                        ),
                      ),
                      action: SnackBarAction(
                        label: SentenceManager(
                                currentLanguage:
                                    controller.selectedLanguage.value)
                            .sentences
                            .homePageSetup,
                        onPressed: () {
                          Get.toNamed(Routes.MANAGE_TASK_SERVER);
                        },
                        textColor: TaskWarriorColors.purple,
                      ),
                    ),
                  );
                }
              }
            },
          ),
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
