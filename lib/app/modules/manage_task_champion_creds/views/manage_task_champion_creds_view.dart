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
          IconButton(
            icon: Icon(
              Icons.info,
              color: TaskWarriorColors.white,
            ),
            onPressed: () async {
              String url = "https://github.com/its-me-abhishek/ccsync";
              if (!await launchUrl(Uri.parse(url))) {
                throw Exception('Could not launch $url');
              }
            },
          ),
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
                  TextField(
                    style: TextStyle(color: tColors.primaryTextColor),
                    controller: controller.ccsyncBackendUrlController,
                    decoration: InputDecoration(
                      labelText: SentenceManager(
                              currentLanguage: AppSettings.selectedLanguage)
                          .sentences
                          .ccsyncBackendUrl,
                      labelStyle: TextStyle(color: tColors.primaryTextColor),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() => Center(
                          child: ElevatedButton(
                        onPressed: controller.isCheckingCreds.value
                            ? null
                            : () async {
                                int status = await controller.saveCredentials();
                                if (status == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                            SentenceManager(
                                                    currentLanguage: AppSettings
                                                        .selectedLanguage)
                                                .sentences
                                                .credentialsSavedSuccessfully,
                                            style: TextStyle(
                                              color: tColors.primaryTextColor,
                                            ),
                                          ),
                                          backgroundColor:
                                              tColors.secondaryBackgroundColor,
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
                                        duration: const Duration(seconds: 2)));
                              },
                        child: controller.isCheckingCreds.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Color.fromARGB(255, 83, 83, 83),
                                  strokeWidth: 2.0,
                                ),
                              )
                            : Text(SentenceManager(
                                    currentLanguage:
                                        AppSettings.selectedLanguage)
                                .sentences
                                .saveCredentials),
                      ))),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
