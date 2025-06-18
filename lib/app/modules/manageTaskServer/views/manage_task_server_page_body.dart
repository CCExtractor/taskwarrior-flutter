// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/manageTaskServer/controllers/manage_task_server_controller.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/models/storage/set_config.dart';
import 'package:taskwarrior/app/modules/manageTaskServer/views/pem_widget.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class ManageTaskServerPageBody extends StatelessWidget {
  final ManageTaskServerController controller;
  const ManageTaskServerPageBody({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    controller.initManageTaskServerPageTour();
    controller.showManageTaskServerPageTour(context);
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            key: controller.configureTaskRC,
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .manageTaskServerPageConfigureTASKRC,
                  style: TextStyle(
                    color: tColors.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: tColors.dialogBackgroundColor,
                      builder: (context) {
                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            // double heightOfModalBottomSheet =
                            //     MediaQuery.of(context).size.height * 0.6;

                            return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: Wrap(
                                children: [
                                  Container(
                                    // height: heightOfModalBottomSheet,
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: const BoxDecoration(
                                      // color: tileColor,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16.0)),
                                    ),

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          SentenceManager(
                                                  currentLanguage: AppSettings
                                                      .selectedLanguage)
                                              .sentences
                                              .manageTaskServerPageConfigureTaskRCDialogueBoxTitle,
                                          style: TextStyle(
                                            fontWeight: TaskWarriorFonts.bold,
                                            color: tColors.primaryTextColor,
                                          ),
                                        ),
                                        Text(
                                          SentenceManager(
                                                  currentLanguage: AppSettings
                                                      .selectedLanguage)
                                              .sentences
                                              .manageTaskServerPageConfigureTaskRCDialogueBoxSubtitle,
                                          style: TextStyle(
                                            color: tColors.primaryTextColor,
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: SizedBox(
                                            height: Get.height * 0.15,
                                            child: TextField(
                                              style: TextStyle(
                                                  color: tColors.primaryTextColor
                                                  ),
                                              controller: controller
                                                  .taskrcContentController,
                                              maxLines: 8,
                                              decoration: InputDecoration(
                                                counterStyle: TextStyle(
                                                    color: tColors.primaryTextColor
                                                  ),
                                                suffixIconConstraints:
                                                    const BoxConstraints(
                                                  maxHeight: 24,
                                                  maxWidth: 24,
                                                ),
                                                isDense: true,
                                                suffix: IconButton(
                                                  onPressed: () async {
                                                    controller
                                                        .setContent(context);
                                                  },
                                                  icon: const Icon(
                                                      Icons.content_paste),
                                                ),
                                                border:
                                                  const OutlineInputBorder(),
                                                  labelStyle: GoogleFonts.poppins(
                                                    color:tColors.primaryTextColor,
                                                  ),
                                                labelText: SentenceManager(
                                                        currentLanguage:
                                                            AppSettings
                                                                .selectedLanguage
                                                    )
                                                    .sentences
                                                    .manageTaskServerPageConfigureTaskRCDialogueBoxInputFieldText,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          SentenceManager(
                                                  currentLanguage: AppSettings
                                                      .selectedLanguage)
                                              .sentences
                                              .manageTaskServerPageConfigureTaskRCDialogueBoxOr,
                                          style: TextStyle(
                                            color: tColors.primaryTextColor,
                                          ),
                                        ),
                                        FilledButton.tonal(
                                          style: ButtonStyle(
                                              backgroundColor: WidgetStateProperty.all<Color>(tColors.secondaryBackgroundColor!)
                                          ),
                                          onPressed: () async {
                                            await setConfig(
                                              storage: controller.storage,
                                              key: 'TASKRC',
                                            );
                                            setState(() {});
                                            Get.back();
                                          },
                                          child: Text(
                                            SentenceManager(
                                                    currentLanguage: AppSettings
                                                        .selectedLanguage)
                                                .sentences
                                                .manageTaskServerPageConfigureTaskRCDialogueBoxSelectTaskRC,
                                            style: TextStyle(
                                              color: tColors.primaryTextColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    //   height: MediaQuery.of(context).size.height * 0.05,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // color: tileColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: TaskWarriorColors.borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.taskrcContentController.text.isEmpty
                              ? SentenceManager(
                                      currentLanguage:
                                          AppSettings.selectedLanguage)
                                  .sentences
                                  .manageTaskServerPageSetTaskRC
                              : SentenceManager(
                                      currentLanguage:
                                          AppSettings.selectedLanguage)
                                  .sentences
                                  .manageTaskServerPageTaskRCFileIsVerified,
                          style: TextStyle(
                            color: tColors.primaryTextColor,
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: tColors.secondaryTextColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: controller
                                    .taskrcContentController.text.isNotEmpty
                                ? Icon(
                                    Icons.check,
                                    color: TaskWarriorColors.green,
                                  )
                                : Icon(
                                    Icons.chevron_right_rounded,
                                    color: tColors.secondaryBackgroundColor,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Offstage(
              offstage: controller.isTaskDServerActive.value,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TaskD Server Info",
                          style: TextStyle(
                            color: tColors.primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            //   height: MediaQuery.of(context).size.height * 0.05,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              // color: tileColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: TaskWarriorColors.borderColor,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                controller.server == null
                                    ? Text(
                                        'Not Configured',
                                        style: TextStyle(
                                          color: tColors.primaryTextColor,
                                        ),
                                      )
                                    : Text(
                                        '${controller.server}',
                                        style: TextStyle(
                                          color: tColors.primaryTextColor,
                                        ),
                                      ),
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: tColors.secondaryTextColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: controller.server != null
                                        ? Icon(
                                            Icons.check,
                                            color: TaskWarriorColors.green,
                                          )
                                        : Icon(
                                            Icons.chevron_right_rounded,
                                            color: tColors.secondaryBackgroundColor,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TaskD Server Credentials",
                          style: TextStyle(
                            color: tColors.primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            //   height: MediaQuery.of(context).size.height * 0.05,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              // color: tileColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: TaskWarriorColors.borderColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                controller.credentialsString == null
                                    ? Text(
                                        'Not Configured',
                                        style: TextStyle(
                                          color: tColors.primaryTextColor,
                                        ),
                                      )
                                    : SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            controller.credentialsString!.value,
                                            style: TextStyle(
                                              color: tColors.primaryTextColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                GestureDetector(
                                  onTap: () {
                                    controller.hideKey.value =
                                        !controller.hideKey.value;
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: tColors.primaryTextColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: controller.credentials == null
                                        ? Icon(
                                            Icons.chevron_right_rounded,
                                            color: tColors.primaryBackgroundColor,
                                          )
                                        : Icon(
                                            controller.hideKey.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: TaskWarriorColors.green,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          GetBuilder<ManageTaskServerController>(
            builder: (controller) {
              List<Widget> pemWidgets = [];
              for (var pem in [
                'taskd.certificate',
                'taskd.key',
                'taskd.ca',
                if (controller.homeController.serverCertExists.value)
                  'server.cert',
              ]) {
                pemWidgets.add(
                  PemWidget(
                    storage: controller.storage,
                    pem: pem,
                    optionString: pem == "taskd.certificate"
                        ? SentenceManager(
                                currentLanguage: AppSettings.selectedLanguage)
                            .sentences
                            .manageTaskServerPageConfigureYourCertificate
                        : pem == "taskd.key"
                            ? SentenceManager(
                                    currentLanguage:
                                        AppSettings.selectedLanguage)
                                .sentences
                                .manageTaskServerPageConfigureTaskserverKey
                            : pem == "taskd.ca"
                                ? SentenceManager(
                                        currentLanguage:
                                            AppSettings.selectedLanguage)
                                    .sentences
                                    .manageTaskServerPageConfigureServerCertificate
                                : SentenceManager(
                                        currentLanguage:
                                            AppSettings.selectedLanguage)
                                    .sentences
                                    .manageTaskServerPageConfigureServerCertificate,
                    listTileTitle: pem == "taskd.certificate"
                        ? SentenceManager(
                                currentLanguage: AppSettings.selectedLanguage)
                            .sentences
                            .manageTaskServerPageSelectCertificate
                        : pem == "taskd.key"
                            ? SentenceManager(
                                    currentLanguage:
                                        AppSettings.selectedLanguage)
                                .sentences
                                .manageTaskServerPageSelectKey
                            : pem == "taskd.ca"
                                ? SentenceManager(
                                        currentLanguage:
                                            AppSettings.selectedLanguage)
                                    .sentences
                                    .manageTaskServerPageSelectCertificate
                                : SentenceManager(
                                        currentLanguage:
                                            AppSettings.selectedLanguage)
                                    .sentences
                                    .manageTaskServerPageSelectCertificate,
                    onTapCallBack: controller.onTapPEMWidget,
                    onLongPressCallBack: controller.onLongPressPEMWidget,
                    globalKey: controller.getGlobalKey(pem),
                  ),
                );
              }
              return Column(
                children: pemWidgets,
              );
            },
          )
        ],
      ),
    );
  }
}
