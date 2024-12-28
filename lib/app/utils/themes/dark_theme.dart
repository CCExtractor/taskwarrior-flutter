import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  dialogBackgroundColor: TaskWarriorColors.kdialogBackGroundColor,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: TaskWarriorColors.white,
    onPrimary: TaskWarriorColors.black,
    secondary: TaskWarriorColors.grey,
    onSecondary: TaskWarriorColors.white,
    error: TaskWarriorColors.red,
    onError: TaskWarriorColors.black,
    surface: TaskWarriorColors.black,
    onSurface: TaskWarriorColors.white,
  ),
  timePickerTheme: TimePickerThemeData(
    dayPeriodColor: TaskWarriorColors.lightGrey
  ),
  extensions: [
    TaskWarriorColors.darkTheme
  ]
);