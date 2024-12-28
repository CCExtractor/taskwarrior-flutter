import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  dialogBackgroundColor: TaskWarriorColors.kLightDialogBackGroundColor,
  colorScheme:  ColorScheme(
      brightness: Brightness.light,
      primary: TaskWarriorColors.black,
      onPrimary: TaskWarriorColors.white,
      secondary: TaskWarriorColors.white,
      onSecondary: TaskWarriorColors.black,
      error: TaskWarriorColors.red,
      onError: TaskWarriorColors.white,
      surface: TaskWarriorColors.white,
      onSurface: TaskWarriorColors.black,
  ),
  timePickerTheme: TimePickerThemeData(
    dayPeriodColor: TaskWarriorColors.grey
  ),
  extensions: [
    TaskWarriorColors.lightTheme
  ]
);
