import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/themes/light_theme.dart';

void main() {
  group('lightTheme', () {
    test('lightTheme has correct brightness', () {
      expect(lightTheme.brightness, Brightness.light);
    });
  });
}
