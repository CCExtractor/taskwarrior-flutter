import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/constants/onboarding_screen_content.dart';

void main() {
  group('Onboarding Screen Content', () {
    test('should contain three onboarding items', () {
      expect(contents.length, 3);
    });

    test('should have valid content for each onboarding item', () {
      for (var content in contents) {
        expect(content.title.isNotEmpty, true);
        expect(content.image.isNotEmpty, true);
        expect(content.colors, isA<Color>());
        expect(content.desc.isNotEmpty, true);
      }
    });

    test('should match the expected titles', () {
      expect(contents[0].title, "Welcome to Taskwarrior");
      expect(contents[1].title, "Powerful Reporting");
      expect(contents[2].title, "Sync Across Devices");
    });
  });
}
