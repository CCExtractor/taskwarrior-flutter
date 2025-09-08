import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/debug_logger/log_databse_helper.dart';
import 'package:taskwarrior/app/utils/themes/dark_theme.dart';
import 'package:taskwarrior/app/utils/themes/light_theme.dart';
import 'package:taskwarrior/rust_bridge/frb_generated.dart';
import 'app/routes/app_pages.dart';

LogDatabaseHelper _logDatabaseHelper = LogDatabaseHelper();

const buildOfTcHelperForAndroid = "libtc_helper.so";
final dyLibOfTcHelperForAndroid =
    DynamicLibrary.open(buildOfTcHelperForAndroid);

void main() async {
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null) {
      debugPrintSynchronously(message, wrapWidth: wrapWidth);
      _logDatabaseHelper.insertLog(message);
    }
  };

  await RustLib.init();

  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.init();

  runApp(
    GetMaterialApp(
      darkTheme: darkTheme,
      theme: lightTheme,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      themeMode: AppSettings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
    ),
  );
}
