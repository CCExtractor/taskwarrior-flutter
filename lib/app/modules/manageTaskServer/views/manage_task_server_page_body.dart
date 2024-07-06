// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/manageTaskServer/controllers/manage_task_server_controller.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/models/storage/set_config.dart';
import 'package:taskwarrior/app/modules/manageTaskServer/views/pem_widget.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';

import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

class ManageTaskServerPageBody extends StatelessWidget {
  final ManageTaskServerController controller;
  const ManageTaskServerPageBody({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    controller.initManageTaskServerPageTour();
    controller.showManageTaskServerPageTour(context);
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
                  "Configure TASKRC",
                  style: TextStyle(
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.white
                        : TaskWarriorColors.black,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: AppSettings.isDarkMode
                          ? TaskWarriorColors.kdialogBackGroundColor
                          : TaskWarriorColors.kLightDialogBackGroundColor,
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
                                          'Configure TaskRc',
                                          style: TextStyle(
                                            fontWeight: TaskWarriorFonts.bold,
                                            color: AppSettings.isDarkMode
                                                ? TaskWarriorColors.white
                                                : TaskWarriorColors.black,
                                          ),
                                        ),
                                        Text(
                                          'Paste the taskrc content or select taskrc file',
                                          style: TextStyle(
                                            color: AppSettings.isDarkMode
                                                ? TaskWarriorColors.white
                                                : TaskWarriorColors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: SizedBox(
                                            height: Get.height * 0.15,
                                            child: TextField(
                                              style: TextStyle(
                                                  color: AppSettings.isDarkMode
                                                      ? TaskWarriorColors.white
                                                      : TaskWarriorColors
                                                          .black),
                                              controller: controller
                                                  .taskrcContentController,
                                              maxLines: 8,
                                              decoration: InputDecoration(
                                                  counterStyle: TextStyle(
                                                      color:
                                                          AppSettings.isDarkMode
                                                              ? TaskWarriorColors
                                                                  .white
                                                              : TaskWarriorColors
                                                                  .black),
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
                                                  labelStyle:
                                                      GoogleFonts.poppins(
                                                          color: AppSettings
                                                                  .isDarkMode
                                                              ? TaskWarriorColors
                                                                  .white
                                                              : TaskWarriorColors
                                                                  .black),
                                                  labelText:
                                                      'Paste your taskrc contents here'),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Or",
                                          style: TextStyle(
                                            color: AppSettings.isDarkMode
                                                ? TaskWarriorColors.white
                                                : TaskWarriorColors.black,
                                          ),
                                        ),
                                        FilledButton.tonal(
                                          style: ButtonStyle(
                                              backgroundColor: AppSettings
                                                      .isDarkMode
                                                  ? WidgetStateProperty.all<
                                                          Color>(
                                                      TaskWarriorColors.black)
                                                  : WidgetStateProperty.all<
                                                          Color>(
                                                      TaskWarriorColors.white)),
                                          onPressed: () async {
                                            await setConfig(
                                              storage: controller.storage,
                                              key: 'TASKRC',
                                            );
                                            setState(() {});
                                            Get.back();
                                          },
                                          child: Text(
                                            'Select TASKRC file',
                                            style: TextStyle(
                                              color: AppSettings.isDarkMode
                                                  ? TaskWarriorColors.white
                                                  : TaskWarriorColors.black,
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
                              ? "Set TaskRc"
                              : "Taskrc file is verified",
                          style: TextStyle(
                            color: AppSettings.isDarkMode
                                ? TaskWarriorColors.white
                                : TaskWarriorColors.black,
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppSettings.isDarkMode
                                ? TaskWarriorColors
                                    .kLightSecondaryBackgroundColor
                                : TaskWarriorColors.ksecondaryBackgroundColor,
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
                                    color: AppSettings.isDarkMode
                                        ? TaskWarriorColors.black
                                        : TaskWarriorColors.white,
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
                            color: AppSettings.isDarkMode
                                ? TaskWarriorColors.white
                                : TaskWarriorColors.black,
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
                                          color: AppSettings.isDarkMode
                                              ? TaskWarriorColors.white
                                              : TaskWarriorColors.black,
                                        ),
                                      )
                                    : Text(
                                        '${controller.server}',
                                        style: TextStyle(
                                          color: AppSettings.isDarkMode
                                              ? TaskWarriorColors.white
                                              : TaskWarriorColors.black,
                                        ),
                                      ),
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: AppSettings.isDarkMode
                                        ? TaskWarriorColors
                                            .kLightSecondaryBackgroundColor
                                        : TaskWarriorColors
                                            .ksecondaryBackgroundColor,
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
                                            color: AppSettings.isDarkMode
                                                ? TaskWarriorColors.black
                                                : TaskWarriorColors.white,
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
                            color: AppSettings.isDarkMode
                                ? TaskWarriorColors.white
                                : TaskWarriorColors.black,
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
                                          color: AppSettings.isDarkMode
                                              ? TaskWarriorColors.white
                                              : TaskWarriorColors.black,
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
                                              color: AppSettings.isDarkMode
                                                  ? TaskWarriorColors.white
                                                  : TaskWarriorColors.black,
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
                                      color: AppSettings.isDarkMode
                                          ? TaskWarriorColors
                                              .kLightPrimaryBackgroundColor
                                          : TaskWarriorColors
                                              .kprimaryBackgroundColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: controller.credentials == null
                                        ? Icon(
                                            Icons.chevron_right_rounded,
                                            color: AppSettings.isDarkMode
                                                ? TaskWarriorColors.black
                                                : TaskWarriorColors.white,
                                          )
                                        : Icon(
                                            controller.hideKey.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: AppSettings.isDarkMode
                                                ? TaskWarriorColors.green
                                                : TaskWarriorColors.green,
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
                        ? "Configure your certificate"
                        : pem == "taskd.key"
                            ? "Configure TaskServer key"
                            : pem == "taskd.ca"
                                ? "Configure Server Certificate"
                                : "Configure Server Certificate",
                    listTileTitle: pem == "taskd.certificate"
                        ? "Select Certificate"
                        : pem == "taskd.key"
                            ? "Select key"
                            : pem == "taskd.ca"
                                ? "Select Certificate"
                                : "Select Certificate",
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
