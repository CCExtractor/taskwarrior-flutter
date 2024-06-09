import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';

class OnboardingPageAnimatedContainer extends StatelessWidget {
  final OnboardingController controller;
  final int index;
  const OnboardingPageAnimatedContainer(
      {super.key, required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        color: TaskWarriorColors.black,
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: controller.getCurrentPage == index ? 20 : 10,
    );
  }
}
