import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

class OnboardingPageNextButton extends StatelessWidget {
  final PageController pageController;
  const OnboardingPageNextButton({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              pageController.jumpToPage(2);
            },
            style: TextButton.styleFrom(
              elevation: 0,
              textStyle: TextStyle(
                fontWeight: TaskWarriorFonts.semiBold,
                fontSize: (Get.width <= 550) ? 13 : 17,
              ),
            ),
            child: Text(
              SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                  .sentences
                  .onboardingSkip,
              style: TextStyle(
                fontWeight: TaskWarriorFonts.bold,
                color: TaskWarriorColors.black,
                fontFamily: FontFamily.poppins,
                fontSize: (Get.width <= 550) ? 12 : 12,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              pageController.nextPage(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TaskWarriorColors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 0,
              padding: (Get.width <= 550)
                  ? const EdgeInsets.symmetric(horizontal: 30, vertical: 20)
                  : const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              textStyle: TextStyle(fontSize: (Get.width <= 550) ? 13 : 17),
            ),
            child: Text(
              SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                  .sentences
                  .onboardingNext,
              style: TextStyle(
                fontWeight: TaskWarriorFonts.light,
                color: TaskWarriorColors.white,
                fontFamily: FontFamily.poppins,
                fontSize: (Get.width <= 550) ? 12 : 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
