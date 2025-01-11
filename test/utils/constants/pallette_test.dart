import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/constants/palette.dart';
import 'package:flutter/material.dart';

void main() {
  group('Palette', () {
    test('kToDark should be a MaterialColor', () {
      expect(Palette.kToDark, isA<MaterialColor>());
    });

    test('kToDark should contain the correct color values', () {
      expect(Palette.kToDark[50], const Color(0xff1e1e1e));
      expect(Palette.kToDark[100], const Color(0xff1a1a1a));
      expect(Palette.kToDark[200], const Color(0xff171717));
      expect(Palette.kToDark[300], const Color(0xff141414));
      expect(Palette.kToDark[400], const Color(0xff111111));
      expect(Palette.kToDark[500], const Color(0xff0d0d0d));
      expect(Palette.kToDark[600], const Color(0xff0a0a0a));
      expect(Palette.kToDark[700], const Color(0xff070707));
      expect(Palette.kToDark[800], const Color(0xff030303));
      expect(Palette.kToDark[900], const Color(0xff000000));
    });
  });
}
