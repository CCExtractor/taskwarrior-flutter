import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/models/models.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel onboardingModel;
  const OnboardingPage({super.key, required this.onboardingModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          children: [
            SizedBox(
              height: (Get.height >= 840) ? 120 : 90,
            ),
            SvgPicture.asset(
              onboardingModel.image,
              height: Get.width / 100 * 30,
            ),
            SizedBox(
              height: (Get.height >= 840) ? 60 : 30,
            ),
            Text(
              onboardingModel.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: TaskWarriorFonts.semiBold,
                fontFamily: FontFamily.poppins,
                fontSize: (Get.width <= 550) ? 30 : 35,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: Get.height * 2 / 100,
            ),
            Text(
              onboardingModel.desc,
              style: TextStyle(
                fontWeight: TaskWarriorFonts.light,
                fontSize: (Get.width <= 550) ? 17 : 17,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: Get.height * 2 / 100,
            )
          ],
        ),
      ),
    );
  }
}
