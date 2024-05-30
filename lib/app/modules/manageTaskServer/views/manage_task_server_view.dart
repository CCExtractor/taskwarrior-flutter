import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:taskwarrior/app/models/storage/client.dart';
import 'package:taskwarrior/app/models/storage/set_config.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/manageTaskServer/views/pem_widget.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/manage_task_server_controller.dart';

class ManageTaskServerView extends GetView<ManageTaskServerController> {
  const ManageTaskServerView({super.key});
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Configure TaskServer",
              style: TextStyle(
                fontFamily: FontFamily.poppins,
                color: TaskWarriorColors.white,
                fontSize: TaskWarriorFonts.fontSizeLarge,
              ),
            ),
            Text(
              controller.alias.value == ''
                  ? controller.profile.value
                  : controller.alias.value,
              // style: GoogleFonts.poppins(
              //   color: TaskWarriorColors.white,
              //   fontSize: TaskWarriorFonts.fontSizeSmall,
              // ),
              style: TextStyle(
                fontFamily: FontFamily.poppins,
                color: TaskWarriorColors.white,
                fontSize: TaskWarriorFonts.fontSizeSmall,
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
              String url =
                  "https://github.com/CCExtractor/taskwarrior-flutter?tab=readme-ov-file#taskwarrior-mobile-app";
              if (!await launchUrl(Uri.parse(url))) {
                throw Exception('Could not launch $url');
              }
            },
          ),
          if (kDebugMode)
            IconButton(
              icon: Icon(
                Icons.bug_report,
                color: TaskWarriorColors.white,
              ),
              onPressed: controller.setConfigurationFromFixtureForDebugging,
            ),
          IconButton(
            icon: Icon(
              Icons.show_chart,
              color: TaskWarriorColors.white,
            ),
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Utils.showAlertDialog(
                    title: const Text('Fetching statistics...'),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Please wait...'),
                      ],
                    ),
                  );
                },
              );

              try {
                // Fetch statistics header from storage
                var header =
                    await controller.storage.home.statistics(await client());

                // Determine the maximum key length for formatting purposes
                var maxKeyLength = header.keys
                    .map<int>((key) => (key as String).length)
                    .reduce(max);

                // Dismiss the loading dialog
                Navigator.of(context).pop();

                // Show statistics in a dialog
                await showDialog(
                  context: context,
                  builder: (context) => Utils.showAlertDialog(
                    scrollable: true,
                    title: const Text(
                      'Statistics:',
                      style: TextStyle(),
                    ),
                    content: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display each key-value pair in the statistics header
                              for (var key in header.keys.toList())
                                Text(
                                  '${'$key:'.padRight(maxKeyLength + 1)} ${header[key]}',
                                  style: const TextStyle(
                                      // color: AppSettings.isDarkMode
                                      //     ? TaskWarriorColors.white
                                      //     : TaskWarriorColors.black,
                                      ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Ok',
                          style: TextStyle(
                              // color: AppSettings.isDarkMode
                              //     ? TaskWarriorColors.white
                              //     : TaskWarriorColors.black,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              } on Exception catch (e, trace) {
                // Dismiss the loading dialog
                Navigator.of(context).pop();

                //Displaying Error message.
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      trace.toString().startsWith("#0")
                          ? "Please set up your TaskServer."
                          : e.toString(),
                      style: const TextStyle(
                          // color: AppSettings.isDarkMode
                          //     ? TaskWarriorColors.kprimaryTextColor
                          //     : TaskWarriorColors.kLightPrimaryTextColor,
                          ),
                    ),
                    // backgroundColor: AppSettings.isDarkMode
                    //     ? TaskWarriorColors.ksecondaryBackgroundColor
                    //     : TaskWarriorColors.kLightSecondaryBackgroundColor,
                    duration: const Duration(seconds: 2)));
                // Log the error and trace
                logError(e, trace);
                // Refresh the state of ProfilesWidget
              }
            },
          ),
        ],
        leading: BackButton(
          color: TaskWarriorColors.white,
        ),
      ),
      // backgroundColor: AppSettings.isDarkMode
      //     ? TaskWarriorColors.kprimaryBackgroundColor
      //     : TaskWarriorColors.kLightPrimaryBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
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
                  const Text(
                    "Configure TASKRC",
                    style: TextStyle(
                        // color: AppSettings.isDarkMode
                        //     ? TaskWarriorColors.white
                        //     : TaskWarriorColors.black,
                        ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
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
                                          const Text(
                                            'Configure TaskRc',
                                            style: TextStyle(
                                              fontWeight: TaskWarriorFonts.bold,
                                              // color: AppSettings.isDarkMode
                                              //     ? TaskWarriorColors.white
                                              //     : TaskWarriorColors.black,
                                            ),
                                          ),
                                          const Text(
                                            'Paste the taskrc content or select taskrc file',
                                            style: TextStyle(
                                                // color: AppSettings.isDarkMode
                                                //     ? TaskWarriorColors.white
                                                //     : TaskWarriorColors.black,
                                                ),
                                          ),
                                          const SizedBox(height: 16.0),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: SizedBox(
                                              height: Get.height * 0.15,
                                              child: TextField(
                                                style: const TextStyle(
                                                    // color:
                                                    //     AppSettings.isDarkMode
                                                    //         ? TaskWarriorColors
                                                    //             .white
                                                    //         : TaskWarriorColors
                                                    //             .black
                                                    ),
                                                controller: controller
                                                    .taskrcContentController,
                                                maxLines: 8,
                                                decoration: InputDecoration(
                                                    counterStyle:
                                                        const TextStyle(
                                                            // color: AppSettings.isDarkMode
                                                            //     ? TaskWarriorColors
                                                            //         .white
                                                            //     : TaskWarriorColors
                                                            //         .black
                                                            ),
                                                    suffixIconConstraints:
                                                        const BoxConstraints(
                                                      maxHeight: 24,
                                                      maxWidth: 24,
                                                    ),
                                                    isDense: true,
                                                    suffix: IconButton(
                                                      onPressed: () async {
                                                        controller.setContent(
                                                            context);
                                                      },
                                                      icon: const Icon(
                                                          Icons.content_paste),
                                                    ),
                                                    border:
                                                        const OutlineInputBorder(),
                                                    // labelStyle: GoogleFonts
                                                    //     .poppins(
                                                    //         color: AppSettings
                                                    //                 .isDarkMode
                                                    //             ? TaskWarriorColors
                                                    //                 .white
                                                    //             : TaskWarriorColors
                                                    //                 .black),
                                                    labelText:
                                                        'Paste your taskrc contents here'),
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            "Or",
                                            style: TextStyle(
                                                // color: AppSettings.isDarkMode
                                                //     ? TaskWarriorColors.white
                                                //     : TaskWarriorColors.black,
                                                ),
                                          ),
                                          FilledButton.tonal(
                                            // style: ButtonStyle(
                                            //     backgroundColor: AppSettings
                                            //             .isDarkMode
                                            //         ? MaterialStateProperty.all<
                                            //                 Color>(
                                            //             TaskWarriorColors.black)
                                            //         : MaterialStateProperty.all<
                                            //                 Color>(
                                            //             TaskWarriorColors
                                            //                 .white)),
                                            onPressed: () async {
                                              await setConfig(
                                                storage: controller.storage,
                                                key: 'TASKRC',
                                              );
                                              setState(() {});
                                              Get.back();
                                            },
                                            child: const Text(
                                              'Select TASKRC file',
                                              style: TextStyle(
                                                  // color: AppSettings.isDarkMode
                                                  //     ? TaskWarriorColors.white
                                                  //     : TaskWarriorColors.black,
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
                        border:
                            Border.all(color: TaskWarriorColors.borderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => Text(
                              controller.taskrcContentController.text.isEmpty
                                  ? "Set TaskRc"
                                  : "Taskrc file is verified",
                              style: const TextStyle(
                                  // color: AppSettings.isDarkMode
                                  //     ? TaskWarriorColors.white
                                  //     : TaskWarriorColors.black,
                                  ),
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: const BoxDecoration(
                              // color: AppSettings.isDarkMode
                              //     ? TaskWarriorColors
                              //         .kLightSecondaryBackgroundColor
                              //     : TaskWarriorColors.ksecondaryBackgroundColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: controller
                                      .taskrcContentController.text.isNotEmpty
                                  ? Icon(
                                      Icons.check,
                                      color: TaskWarriorColors.green,
                                    )
                                  : const Icon(
                                      Icons.chevron_right_rounded,
                                      // color: AppSettings.isDarkMode
                                      //     ? TaskWarriorColors.black
                                      //     : TaskWarriorColors.white,
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
                          const Text(
                            "TaskD Server Info",
                            style: TextStyle(
                                // color: AppSettings.isDarkMode
                                //     ? TaskWarriorColors.white
                                //     : TaskWarriorColors.black,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  controller.server == null
                                      ? const Text(
                                          'Not Configured',
                                          style: TextStyle(
                                              // color: AppSettings.isDarkMode
                                              //     ? TaskWarriorColors.white
                                              //     : TaskWarriorColors.black,
                                              ),
                                        )
                                      : Text(
                                          '${controller.server}',
                                          style: const TextStyle(
                                              // color: AppSettings.isDarkMode
                                              //     ? TaskWarriorColors.white
                                              //     : TaskWarriorColors.black,
                                              ),
                                        ),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: const BoxDecoration(
                                      // color: AppSettings.isDarkMode
                                      //     ? TaskWarriorColors
                                      //         .kLightSecondaryBackgroundColor
                                      //     : TaskWarriorColors
                                      //         .ksecondaryBackgroundColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: controller.server != null
                                          ? Icon(
                                              Icons.check,
                                              color: TaskWarriorColors.green,
                                            )
                                          : const Icon(
                                              Icons.chevron_right_rounded,
                                              // color: AppSettings.isDarkMode
                                              //     ? TaskWarriorColors.black
                                              //     : TaskWarriorColors.white,
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
                          const Text(
                            "TaskD Server Credentials",
                            style: TextStyle(
                                // color: AppSettings.isDarkMode
                                //     ? TaskWarriorColors.white
                                //     : TaskWarriorColors.black,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  controller.credentialsString == null
                                      ? const Text(
                                          'Not Configured',
                                          style: TextStyle(
                                              // color: AppSettings.isDarkMode
                                              //     ? TaskWarriorColors.white
                                              //     : TaskWarriorColors.black,
                                              ),
                                        )
                                      : SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              controller
                                                  .credentialsString!.value,
                                              style: const TextStyle(
                                                  // color: AppSettings.isDarkMode
                                                  //     ? TaskWarriorColors.white
                                                  //     : TaskWarriorColors.black,
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
                                      decoration: const BoxDecoration(
                                        // color: AppSettings.isDarkMode
                                        //     ? TaskWarriorColors
                                        //         .kLightPrimaryBackgroundColor
                                        //     : TaskWarriorColors
                                        //         .kprimaryBackgroundColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: controller.credentials == null
                                          ? const Icon(
                                              Icons.chevron_right_rounded,
                                              // color: AppSettings.isDarkMode
                                              //     ? TaskWarriorColors.black
                                              //     : TaskWarriorColors.white,
                                            )
                                          : Icon(
                                              controller.hideKey.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              // color: AppSettings.isDarkMode
                                              //     ? TaskWarriorColors.green
                                              //     : TaskWarriorColors.green,
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
            for (var pem in [
              'taskd.certificate',
              'taskd.key',
              'taskd.ca',
              if (homeController.serverCertExists.value) 'server.cert',
            ])
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
              ),
          ],
        ),
      ),
    );
  }
}
