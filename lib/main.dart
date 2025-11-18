import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/debug_logger/log_databse_helper.dart';
import 'package:taskwarrior/app/utils/themes/dark_theme.dart';
import 'package:taskwarrior/app/utils/themes/light_theme.dart';
import 'package:taskwarrior/app/utils/notifications/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app/routes/app_pages.dart';

LogDatabaseHelper _logDatabaseHelper = LogDatabaseHelper();

void main() async {
  // Required before using async in main
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logging
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null) {
      debugPrintSynchronously(message, wrapWidth: wrapWidth);
      _logDatabaseHelper.insertLog(message);
    }
  };

  // Load App Settings (theme, language, etc.)
  await AppSettings.init();

  // Initialize timezone for scheduled notifications
  tz.initializeTimeZones();

  // Initialize local notifications (must be before runApp)
  await NotificationService.initialize();

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
