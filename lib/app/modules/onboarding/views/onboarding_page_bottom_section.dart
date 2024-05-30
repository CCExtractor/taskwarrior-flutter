import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:taskwarrior/app/modules/onboarding/views/onboarding_page_start_button.dart';
import 'package:taskwarrior/app/modules/onboarding/views/onborading_page_animated_container.dart';
import 'package:taskwarrior/app/modules/onboarding/views/onborading_page_next_button.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';

class OnboardingPageBottomSection extends StatelessWidget {
  final OnboardingController controller;
  final PageController pageController;
  const OnboardingPageBottomSection({super.key, required this.controller,required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            contents.length,
            (int index) => OnboardingPageAnimatedContainer(
              controller: controller,
              index: index,
            ),
          ),
        ),
        controller.getCurrentPage + 1 == contents.length
            ? OnboardingPageStartButton(controller: controller)
            : OnboardingPageNextButton(
                pageController: pageController,
              ),
      ],
    );
  }
}
