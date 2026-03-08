import 'dart:ffi';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrintSynchronously;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/services/deep_link_service.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/debug_logger/log_databse_helper.dart';
import 'package:taskwarrior/app/utils/themes/dark_theme.dart';
import 'package:taskwarrior/app/utils/themes/light_theme.dart';
import 'package:taskwarrior/rust_bridge/frb_generated.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

import 'app/routes/app_pages.dart';

LogDatabaseHelper _logDatabaseHelper = LogDatabaseHelper();

ExternalLibrary loadNativeLibrary() {
  if (kIsWeb) {
    throw UnsupportedError("Native libraries are not supported on Web");
  }

  if (Platform.isIOS) {
    return ExternalLibrary.open('Frameworks/tc_helper.framework/tc_helper');
  } else if (Platform.isAndroid) {
    return ExternalLibrary.open('libtc_helper.so');
  } else if (Platform.isMacOS) {
    return ExternalLibrary.open('tc_helper.framework/tc_helper');
  } else if (Platform.isLinux) {
    return ExternalLibrary.open('libtc_helper.so');
  } else if (Platform.isWindows) { // Add Windows back in!
    return ExternalLibrary.open('tc_helper.dll');
  }
  throw UnsupportedError(
      'Platform ${Platform.operatingSystem} is not supported');
}

void main() async { 
  if (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  WidgetsFlutterBinding.ensureInitialized();
 
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null) {
      debugPrintSynchronously(message, wrapWidth: wrapWidth);
      _logDatabaseHelper.insertLog(message);
    }
  };
  debugPrint("🚀 BOOT: main() started");

  final lib = loadNativeLibrary();
  await RustLib.init(externalLibrary: lib);
  await AppSettings.init();
  
  await Get.putAsync<DeepLinkService>(() async {
    final service = DeepLinkService();
    await service.init();
    return service;
  });
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
