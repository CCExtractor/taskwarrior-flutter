import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';

void main() {
  group('TaskWarriorFonts', () {
    test('should contain the correct font weights', () {
      expect(TaskWarriorFonts.thin, FontWeight.w100);
      expect(TaskWarriorFonts.extraLight, FontWeight.w200);
      expect(TaskWarriorFonts.light, FontWeight.w300);
      expect(TaskWarriorFonts.regular, FontWeight.w400);
      expect(TaskWarriorFonts.medium, FontWeight.w500);
      expect(TaskWarriorFonts.semiBold, FontWeight.w600);
      expect(TaskWarriorFonts.bold, FontWeight.w700);
      expect(TaskWarriorFonts.extraBold, FontWeight.w800);
      expect(TaskWarriorFonts.black, FontWeight.w900);
    });

    test('should contain the correct font sizes', () {
      expect(TaskWarriorFonts.fontSizeSmall, 12.0);
      expect(TaskWarriorFonts.fontSizeMedium, 16.0);
      expect(TaskWarriorFonts.fontSizeLarge, 20.0);
      expect(TaskWarriorFonts.fontSizeExtraLarge, 24.0);
    });
  });
}
