// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/constants/palette.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class TaskWarriorColors {
  // Normal Colors
  static Color red = Colors.red;
  static Color green = Colors.green;
  static Color yellow = Colors.yellow;
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color grey = Colors.grey;
  static Color? lightGrey = Colors.grey[600];
  static Color purple = Colors.purple;
  static Color borderColor = Colors.grey.shade300;
  static Color deepPurpleAccent = Colors.deepPurpleAccent;
  static Color deepPurple = Colors.deepPurple;

  // colors irrespective of theme
  static Color appBarColor = const Color(0xFF000000);
  static Color appBarTextColor = white;
  static Color appBarUnSelectedIconsColorForReports = const Color(0xFF48454E);

  // Dark Theme Color Palette
  static Color kprimaryBackgroundColor = Palette.kToDark.shade200;
  static Color ksecondaryBackgroundColor =
      const Color.fromARGB(255, 48, 46, 46);
  static Color kprimaryTextColor = Colors.white;
  static Color ksecondaryTextColor = Colors.white;
  static Color kprimaryDisabledTextColor = const Color(0xff595f6b);
  static Color kdialogBackGroundColor = const Color.fromARGB(255, 25, 25, 25);

  // Light Theme Color Palette
  static Color kLightPrimaryBackgroundColor = Colors.white;
  static Color kLightSecondaryBackgroundColor =
      const Color.fromARGB(255, 220, 216, 216);
  static Color kLightPrimaryTextColor = Colors.black;
  static Color kLightSecondaryTextColor = const Color.fromARGB(255, 48, 46, 46);
  static Color kLightPrimaryDisabledTextColor = const Color(0xffACACAB);
  static Color kLightDialogBackGroundColor = Colors.white;
  static TaskwarriorColorTheme darkTheme = TaskwarriorColorTheme(
    dialogBackgroundColor: kdialogBackGroundColor, 
    primaryBackgroundColor: kprimaryBackgroundColor, 
    primaryDisabledTextColor: kprimaryDisabledTextColor, 
    primaryTextColor: kprimaryTextColor, 
    secondaryBackgroundColor: ksecondaryBackgroundColor, 
    secondaryTextColor: ksecondaryTextColor,
    dividerColor: const Color.fromARGB(255, 192, 192, 192),
    purpleShade: deepPurpleAccent,
    greyShade: grey,
    icons: Icons.dark_mode,
    dimCol: const Color.fromARGB(137, 248, 248, 248)
  );
  static TaskwarriorColorTheme lightTheme = TaskwarriorColorTheme(
    dialogBackgroundColor: kLightDialogBackGroundColor, 
    primaryBackgroundColor: kLightPrimaryBackgroundColor, 
    primaryDisabledTextColor: kLightPrimaryDisabledTextColor, 
    primaryTextColor: kLightPrimaryTextColor, 
    secondaryBackgroundColor: kLightSecondaryBackgroundColor, 
    secondaryTextColor: kLightSecondaryTextColor,
    dividerColor: kprimaryBackgroundColor,
    purpleShade: deepPurple,
    greyShade: lightGrey,
    icons: Icons.light_mode,
    dimCol: const Color.fromARGB(136, 17, 17, 17)
  );
}
