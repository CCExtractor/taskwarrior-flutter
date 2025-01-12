import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';

class OnboardingPageStartButton extends StatelessWidget {
  final OnboardingController controller;
  const OnboardingPageStartButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: ElevatedButton(
        onPressed: () {
          controller.markOnboardingAsCompleted();
          Get.offNamed(Routes.PERMISSION);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: TaskWarriorColors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: (Get.width <= 550)
              ? const EdgeInsets.symmetric(horizontal: 100, vertical: 20)
              : EdgeInsets.symmetric(horizontal: Get.width * 0.2, vertical: 25),
          textStyle: TextStyle(
            fontFamily: FontFamily.poppins,
            fontSize: (Get.width <= 550) ? 13 : 17,
          ),
        ),
        child: Text(
          "Start",
          style: TextStyle(
            fontWeight: TaskWarriorFonts.light,
            fontSize: (Get.width <= 550) ? 17 : 17,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
