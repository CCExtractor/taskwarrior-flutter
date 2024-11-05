import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.init();

  // await Permission.notification.isDenied.then((value) {
  //   if (value) {
  //     Permission.notification.request();
  //   }
  // });
  if (await Permission.notification.isDenied) {
    if (await Permission.notification.request().isGranted) {
      print("Notification permission granted");
    } else {
      print("Notification permission denied");
    }
  }

  if (await Permission.storage.isDenied) {
    if (await Permission.storage.request().isGranted) {
      print("Storage permission granted");
    } else {
      print("Storage permission denied");
    }
  }

  if (await Permission.manageExternalStorage.isDenied) {
    if (await Permission.manageExternalStorage.request().isGranted) {
      print("Manage external storage permission granted");
    } else {
      print("Manage external storage permission denied");
    }
  }
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
