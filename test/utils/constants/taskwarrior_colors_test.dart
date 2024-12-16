import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/constants/palette.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';

void main() {
  group('TaskWarriorColors', () {
    test('should contain the correct normal colors', () {
      expect(TaskWarriorColors.red, Colors.red);
      expect(TaskWarriorColors.green, Colors.green);
      expect(TaskWarriorColors.yellow, Colors.yellow);
      expect(TaskWarriorColors.white, Colors.white);
      expect(TaskWarriorColors.black, Colors.black);
      expect(TaskWarriorColors.grey, Colors.grey);
      expect(TaskWarriorColors.lightGrey, Colors.grey[600]);
      expect(TaskWarriorColors.purple, Colors.purple);
      expect(TaskWarriorColors.borderColor, Colors.grey.shade300);
      expect(TaskWarriorColors.deepPurpleAccent, Colors.deepPurpleAccent);
      expect(TaskWarriorColors.deepPurple, Colors.deepPurple);
    });

    test('should contain the correct dark theme colors', () {
      expect(
          TaskWarriorColors.kprimaryBackgroundColor, Palette.kToDark.shade200);
      expect(TaskWarriorColors.ksecondaryBackgroundColor,
          const Color.fromARGB(255, 48, 46, 46));
      expect(TaskWarriorColors.kprimaryTextColor, Colors.white);
      expect(TaskWarriorColors.ksecondaryTextColor, Colors.white);
      expect(
          TaskWarriorColors.kprimaryDisabledTextColor, const Color(0xff595f6b));
      expect(TaskWarriorColors.kdialogBackGroundColor,
          const Color.fromARGB(255, 25, 25, 25));
    });

    test('should contain the correct light theme colors', () {
      expect(TaskWarriorColors.kLightPrimaryBackgroundColor, Colors.white);
      expect(TaskWarriorColors.kLightSecondaryBackgroundColor,
          const Color.fromARGB(255, 220, 216, 216));
      expect(TaskWarriorColors.kLightPrimaryTextColor, Colors.black);
      expect(TaskWarriorColors.kLightSecondaryTextColor,
          const Color.fromARGB(255, 48, 46, 46));
      expect(TaskWarriorColors.kLightPrimaryDisabledTextColor,
          const Color(0xffACACAB));
      expect(TaskWarriorColors.kLightDialogBackGroundColor, Colors.white);
    });
  });
}
