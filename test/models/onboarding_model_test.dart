import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/onboarding_model.dart';

void main() {
  group('OnboardingModel', () {
    late OnboardingModel model;

    setUp(() {
      model = OnboardingModel(
        title: 'Welcome',
        image: 'assets/images/welcome.png',
        desc: 'Welcome to the app!',
        colors: Colors.blue,
      );
    });

    test('should correctly initialize with given parameters', () {
      expect(model.title, 'Welcome');
      expect(model.image, 'assets/images/welcome.png');
      expect(model.desc, 'Welcome to the app!');
      expect(model.colors, Colors.blue);
    });
  });
}
