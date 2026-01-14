import 'dart:ffi';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// 1. Add this import
import 'package:taskwarrior/app/services/deep_link_service.dart';

import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/debug_logger/log_databse_helper.dart';
import 'package:taskwarrior/app/utils/themes/dark_theme.dart';
import 'package:taskwarrior/app/utils/themes/light_theme.dart';
import 'package:taskwarrior/rust_bridge/frb_generated.dart';
import 'app/routes/app_pages.dart';

LogDatabaseHelper _logDatabaseHelper = LogDatabaseHelper();

DynamicLibrary loadNativeLibrary() {
  if (Platform.isIOS) {
    return DynamicLibrary.open('Frameworks/tc_helper.framework/tc_helper');
  } else if (Platform.isAndroid) {
    return DynamicLibrary.open('libtc_helper.so');
  } else if (Platform.isMacOS) {
    return DynamicLibrary.open('tc_helper.framework/tc_helper');
  }
  throw UnsupportedError(
      'Platform ${Platform.operatingSystem} is not supported');
}

void main() async {
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null) {
      debugPrintSynchronously(message, wrapWidth: wrapWidth);
      _logDatabaseHelper.insertLog(message);
    }
  };

  loadNativeLibrary();
  await RustLib.init();

  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.init();

  Get.put<DeepLinkService>(DeepLinkService(), permanent: true);
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
