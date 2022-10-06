import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

class AppSettings {
  static bool isDarkMode =
      (SchedulerBinding.instance.window.platformBrightness == Brightness.dark);
}
