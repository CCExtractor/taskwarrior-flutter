// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';
import 'package:taskwarrior/app/utils/taskserver/taskserver.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

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
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(days: 1),
        backgroundColor: tColors.secondaryBackgroundColor,
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: tColors.primaryTextColor,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              message,
              style: TextStyle(
                color: tColors.primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResultSnackBar(BuildContext context, String message, bool isError) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: tColors.secondaryBackgroundColor,
        content: Text(
          message,
          style: TextStyle(
            color: tColors.primaryTextColor,
          ),
        ),
        action: isError
            ? SnackBarAction(
                label: SentenceManager(
                        currentLanguage: controller.selectedLanguage.value)
                    .sentences
                    .homePageSetup,
                onPressed: () {
                  if (controller.taskchampion.value ||
                      controller.taskReplica.value) {
                    Get.toNamed(Routes.MANAGE_TASK_CHAMPION_CREDS);
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
                    message: SentenceManager(
                            currentLanguage: controller.selectedLanguage.value)
                        .sentences
                        .homePageCancelSearchTooltip,
                    child: Icon(Icons.cancel, color: TaskWarriorColors.white))
                : Tooltip(
                    message: SentenceManager(
                            currentLanguage: controller.selectedLanguage.value)
                        .sentences
                        .homePageSearchTooltip,
                    child: Icon(Icons.search, color: TaskWarriorColors.white)),
            onPressed: controller.toggleSearch,
          ),
        ),
        Builder(
          builder: (context) => Obx(() => IconButton(
                key: controller.refreshKey,
                icon: !controller.isRefreshing.value
                    ? Icon(Icons.refresh, color: TaskWarriorColors.white)
                    : const _SpinningIcon(),
                onPressed: controller.isRefreshing.value
                    ? null
                    : () async {
                        debugPrint("Refresh button pressed");
                        if (controller.taskReplica.value) {
                          var c = await CredentialsStorage.getClientId();
                          var e =
                              await CredentialsStorage.getEncryptionSecret();
                          debugPrint(
                              "controller.taskReplica.value ${controller.taskReplica.value} Replica Credentials: c=$c e=$e");
                          if (c == null || e == null) {
                            _showResultSnackBar(
                                context,
                                SentenceManager(
                                        currentLanguage:
                                            controller.selectedLanguage.value)
                                    .sentences
                                    .homePageTaskWarriorNotConfigured,
                                true);
                            return;
                          }
                          debugPrint("Refreshing Replica tasks");
                          controller.isRefreshing.value = true;
                          try {
                            await controller.refreshReplicaTasks();
                            _showResultSnackBar(
                                context, 'Sync Completed', false);
                          } catch (e) {
                            debugPrint('Error refreshing replica tasks: $e');
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
                          return;
                        }

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
                                  context, 'Sync Completed', false);
                            } catch (e) {
                              debugPrint('Error refreshing tasks: $e');
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
                              _showResultSnackBar(
                                  context, 'Sync Completed', false);
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

class _SpinningIcon extends StatefulWidget {
  const _SpinningIcon();

  @override
  State<_SpinningIcon> createState() => _SpinningIconState();
}

class _SpinningIconState extends State<_SpinningIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(Icons.refresh, color: TaskWarriorColors.white),
    );
  }
}
