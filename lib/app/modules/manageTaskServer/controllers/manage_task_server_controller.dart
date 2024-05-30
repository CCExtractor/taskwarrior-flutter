// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:taskwarrior/app/models/storage.dart';
import 'package:taskwarrior/app/models/storage/set_config.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/home_path/home_path.dart' as rc;
import 'package:taskwarrior/app/utils/taskserver/taskserver.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

class ManageTaskServerController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();
  final SplashController splashController = Get.find<SplashController>();
  late RxString profile;
  late Storage storage;
  late RxString alias;
  late Server? server;
  late Credentials? credentials;
  final TextEditingController taskrcContentController = TextEditingController();
  RxBool isTaskDServerActive = true.obs;
  RxBool hideKey = true.obs;

  @override
  void onInit() {
    super.onInit();
    storage = homeController.storage;
    profile.value = storage.profile.uri.pathSegments
        .lastWhere((segment) => segment.isNotEmpty);
    alias = RxString(splashController.profilesMap[profile.value] ?? '');
    var contents = rc.Taskrc(storage.home.home).readTaskrc();
    if (contents != null) {
      server = Taskrc.fromString(contents).server;
      credentials = Taskrc.fromString(contents).credentials;
    }
    if (contents != null) {
      server = Taskrc.fromString(contents).server;
      credentials = Taskrc.fromString(contents).credentials;
    }
    configureCredentialString();
    update();
  }

  Future<void> setConfigurationFromFixtureForDebugging() async {
    try {
      var contents = await rootBundle.loadString('assets/.taskrc');
      rc.Taskrc(storage.home.home).addTaskrc(contents);
      var taskrc = Taskrc.fromString(contents);
      server = taskrc.server;
      credentials = taskrc.credentials;
      for (var entry in {
        'taskd.certificate': '.task/first_last.cert.pem',
        'taskd.key': '.task/first_last.key.pem',
        'taskd.ca': '.task/ca.cert.pem',
        // 'server.cert': '.task/server.cert.pem',
      }.entries) {
        var contents = await rootBundle.loadString('assets/${entry.value}');
        storage.guiPemFiles.addPemFile(
          key: entry.key,
          contents: contents,
          name: entry.value.split('/').last,
        );
      }
      update();
    } catch (e) {
      logError(e);
    }
  }

  /// The [setConfig] function is used to set the configuration of the TaskServer from the clipboard
  void setContent(BuildContext context) async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    taskrcContentController.text = clipboardData?.text ?? '';

    // Check if the clipboard data is not empty
    if (taskrcContentController.text.isNotEmpty) {
      // Add the clipboard data to the taskrc file
      storage.taskrc.addTaskrc(taskrcContentController.text);

      // Read the contents of the taskrc file
      var contents = rc.Taskrc(storage.home.home).readTaskrc();

      // Check if the contents were successfully read
      if (contents != null) {
        // Parse the contents into a Taskrc object
        var taskrc = Taskrc.fromString(contents);

        // Check if the server and credentials are present in the Taskrc object
        if (taskrc.server != null && taskrc.credentials != null) {
          // Update the server and credentials variables

          server = taskrc.server;
          credentials = taskrc.credentials;
          update();

          // Handle the case when server or credentials are missing in the Taskrc object
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Success: Server or credentials are verified in taskrc file',
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
              ),
              backgroundColor: AppSettings.isDarkMode
                  ? TaskWarriorColors.ksecondaryBackgroundColor
                  : TaskWarriorColors.kLightSecondaryBackgroundColor,
              duration: const Duration(seconds: 2)));
        } else {
          Navigator.pop(context);
          // Handle the case when server or credentials are missing in the Taskrc object
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Error: Server or credentials are missing in taskrc file',
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
              ),
              backgroundColor: AppSettings.isDarkMode
                  ? TaskWarriorColors.ksecondaryBackgroundColor
                  : TaskWarriorColors.kLightSecondaryBackgroundColor,
              duration: const Duration(seconds: 2)));
        }
      } else {
        Navigator.pop(context);

        // Handle the case when there is an error reading the taskrc file
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Error: Failed to read taskrc file',
              style: TextStyle(
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.white
                    : TaskWarriorColors.black,
              ),
            ),
            // backgroundColor: AppSettings.isDarkMode
            //     ? TaskWarriorColors.ksecondaryBackgroundColor
            //     : TaskWarriorColors.kLightSecondaryBackgroundColor,
            duration: const Duration(seconds: 2)));
      }
    }
  }

  RxString? credentialsString = RxString('');

  void configureCredentialString() {
    if (credentials != null) {
      String key;
      if (hideKey.value) {
        key = credentials!.key.replaceAll(RegExp(r'[0-9a-f]'), '*');
      } else {
        key = credentials!.key;
      }

      credentialsString!.value =
          '${credentials!.org}/${credentials!.user}/$key';

      if (credentialsString!.value.isNotEmpty && server.toString().isNotEmpty) {
        //print(credentialsString.value);
        taskrcContentController.text =
            "taskd.server=$server\ntaskd.credentials=${credentials!.org}/${credentials!.user}/$key";

        isTaskDServerActive.value = false;
      }
    }
  }

  void onTapPEMWidget(String pem, Storage storagePem) {
    (pem == 'server.cert')
        ? () {
            storagePem.guiPemFiles.removeServerCert();
            Get.find<SplashController>().update();
          }
        : () async {
            await setConfig(
              storage: storagePem,
              key: pem,
            );
            update();
          };
  }

  void onLongPressPEMWidget(String pem, String? name) {
    (pem != 'server.cert' && name != null)
        ? () {
            storage.guiPemFiles.removePemFile(pem);
            update();
          }
        : null;
  }
}
