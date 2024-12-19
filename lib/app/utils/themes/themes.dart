import 'dart:ui';

import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';

export 'dark_theme.dart';
export 'light_theme.dart';

class AppColor {
  static Color currentAppThemeColor=
   AppSettings.isDarkMode
        ?TaskWarriorColors.kprimaryBackgroundColor
        : TaskWarriorColors.kLightPrimaryBackgroundColor;
  
}
