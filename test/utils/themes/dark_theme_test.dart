import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/themes/dark_theme.dart';

void main() {
  group('darkTheme', () {
    test('darkTheme has correct brightness', () {
      expect(darkTheme.brightness, Brightness.dark);
    });
  });
}
