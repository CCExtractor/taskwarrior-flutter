import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

import 'app/routes/app_pages.dart';
import 'app/utils/app_settings/app_settings.dart';
import 'app/utils/themes/dark_theme.dart';
import 'app/utils/themes/light_theme.dart';

// Controllers
import 'app/modules/splash/controllers/splash_controller.dart';

// Rust bridge (safe init)
import 'rust_bridge/frb_generated.dart';


DynamicLibrary? loadNativeLibrarySafe() {
  try {
    if (Platform.isAndroid) {
      return DynamicLibrary.open('libtc_helper.so');
    } else if (Platform.isIOS) {
      return DynamicLibrary.open(
          'Frameworks/tc_helper.framework/tc_helper');
    } else if (Platform.isMacOS) {
      return DynamicLibrary.open(
          'tc_helper.framework/tc_helper');
    } else {
      debugPrint('⚠ Native Taskwarrior disabled (desktop / UI-only)');
      return null;
    }
  } catch (e) {
    debugPrint('⚠ Native Taskwarrior not available: $e');
    return null;
  }
}

Future<void> main() async {
  /// Required before any plugin or GetX usage
  WidgetsFlutterBinding.ensureInitialized();

  /// Init app settings (theme, prefs)
  await AppSettings.init();

  /// Load native lib (optional)
  loadNativeLibrarySafe();

  /// Init Rust (safe)
  try {
    await RustLib.init();
  } catch (_) {
    debugPrint('⚠ Rust backend disabled (UI-only mode)');
  }


  /// Register SplashController BEFORE runApp
  Get.put<SplashController>(
    SplashController(),
    permanent: true,
  );

  runApp(const TaskwarriorApp());
}

class TaskwarriorApp extends StatelessWidget {
  const TaskwarriorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Taskwarrior',
      debugShowCheckedModeBanner: false,

      /// Routes
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      /// Themes
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode:
          AppSettings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
