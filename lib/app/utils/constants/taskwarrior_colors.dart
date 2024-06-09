// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/constants/palette.dart';

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
}
