import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/manage_task_champion_creds_controller.dart';

class ManageTaskChampionCredsView
    extends GetView<ManageTaskChampionCredsController> {
  const ManageTaskChampionCredsView({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("Built ManageTaskChampionCredsView");
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                  .sentences
                  .configureTaskchampion,
              style: GoogleFonts.poppins(
                color: TaskWarriorColors.white,
                fontSize: TaskWarriorFonts.fontSizeLarge,
              ),
            ),
          ],
        ),
        actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.info,
          //     color: TaskWarriorColors.white,
          //   ),
          //   onPressed: () async {
          //     String url = !controller.taskReplica.value
          //         ? "https://github.com/its-me-abhishek/ccsync"
          //         : "https://github.com/GothenburgBitFactory/taskchampion";
          //     if (!await launchUrl(Uri.parse(url))) {
          //       throw Exception('Could not launch $url');
          //     }
          //   },
          // ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TaskWarriorColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: tColors.primaryBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    style: TextStyle(color: tColors.primaryTextColor),
                    controller: controller.clientIdController,
                    decoration: InputDecoration(
                      labelText: SentenceManager(
                              currentLanguage: AppSettings.selectedLanguage)
                          .sentences
                          .ccsyncClientId,
                      labelStyle: TextStyle(color: tColors.primaryTextColor),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: TextStyle(color: tColors.primaryTextColor),
                    controller: controller.encryptionSecretController,
                    decoration: InputDecoration(
                      labelText: SentenceManager(
                              currentLanguage: AppSettings.selectedLanguage)
                          .sentences
                          .encryptionSecret,
                      labelStyle: TextStyle(color: tColors.primaryTextColor),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => TextField(
                        style: TextStyle(color: tColors.primaryTextColor),
                        controller: controller.ccsyncBackendUrlController,
                        decoration: InputDecoration(
                          labelText: controller.taskReplica.value
                              ? SentenceManager(
                                      currentLanguage:
                                          AppSettings.selectedLanguage)
                                  .sentences
                                  .taskchampionBackendUrl
                              : SentenceManager(
                                      currentLanguage:
                                          AppSettings.selectedLanguage)
                                  .sentences
                                  .ccsyncBackendUrl,
                          labelStyle:
                              TextStyle(color: tColors.primaryTextColor),
                          border: const OutlineInputBorder(),
                        ),
                      )),
                  const SizedBox(height: 20),
                  Obx(() => SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: controller.isCheckingCreds.value
                              ? null
                              : () async {
                                  int status =
                                      await controller.saveCredentials();
                                  if (status == 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                              SentenceManager(
                                                      currentLanguage:
                                                          AppSettings
                                                              .selectedLanguage)
                                                  .sentences
                                                  .credentialsSavedSuccessfully,
                                              style: TextStyle(
                                                color: tColors.primaryTextColor,
                                              ),
                                            ),
                                            backgroundColor: tColors
                                                .secondaryBackgroundColor,
                                            duration:
                                                const Duration(seconds: 2)));
                                    return;
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                            "Unable to fetch tasks with it ! Check creds",
                                            style: TextStyle(
                                              color: tColors.primaryTextColor,
                                            ),
                                          ),
                                          backgroundColor:
                                              tColors.secondaryBackgroundColor,
                                          duration:
                                              const Duration(seconds: 2)));
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TaskWarriorColors.deepPurple,
                            foregroundColor: TaskWarriorColors.white,
                            elevation: 4,
                            shadowColor:
                                TaskWarriorColors.purple.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: controller.isCheckingCreds.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : Text(
                                  SentenceManager(
                                          currentLanguage:
                                              AppSettings.selectedLanguage)
                                      .sentences
                                      .saveCredentials,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      )),
                  const SizedBox(height: 10),
                  Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .tip,
                    style: TextStyle(
                      fontSize: 15,
                      color: tColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Divider(
                      color: tColors.primaryTextColor?.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(
                    'Use CCSync for Easy Sync',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: tColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'CCSync uses TaskChampion to sync your tasks '
                    'across multiple devices seamlessly. You also '
                    'get a web dashboard to manage your tasks from '
                    'any browser.',
                    style: TextStyle(
                      fontSize: 14,
                      color: tColors.primaryTextColor?.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Login to CCSync, copy your credentials, and paste them above.',
                    style: TextStyle(
                      fontSize: 14,
                      color: tColors.primaryTextColor?.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.open_in_new,
                          color: TaskWarriorColors.purple),
                      label: Text(
                        'Open CCSync',
                        style: TextStyle(color: TaskWarriorColors.purple),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: TaskWarriorColors.purple),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () async {
                        final url = Uri.parse(
                            'https://taskwarrior-server.ccextractor.org/home');
                        if (!await launchUrl(url,
                            mode: LaunchMode.externalApplication)) {
                          throw Exception('Could not launch $url');
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Divider(
                      color: tColors.primaryTextColor?.withValues(alpha: 0.3)),
                  const SizedBox(height: 12),
                  Text(
                    'Or bring your own credentials from a self-hosted '
                    'TaskChampion sync server.',
                    style: TextStyle(
                      fontSize: 13,
                      color: tColors.primaryTextColor?.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () async {
                      final url = Uri.parse(
                          'https://github.com/GothenburgBitFactory/taskchampion-sync-server');
                      if (!await launchUrl(url,
                          mode: LaunchMode.externalApplication)) {
                        throw Exception('Could not launch $url');
                      }
                    },
                    child: Text(
                      'GothenburgBitFactory/taskchampion-sync-server',
                      style: TextStyle(
                        fontSize: 13,
                        color: TaskWarriorColors.purple,
                        decoration: TextDecoration.underline,
                        decorationColor: TaskWarriorColors.purple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
