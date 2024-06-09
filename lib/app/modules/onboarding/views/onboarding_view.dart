import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/onboarding/views/onboarding_page.dart';
import 'package:taskwarrior/app/modules/onboarding/views/onboarding_page_bottom_section.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    double height = Get.height;

    PageController pageController = PageController();
    return Obx(() => Scaffold(
          backgroundColor: contents[controller.getCurrentPage].colors,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: pageController,
                    onPageChanged: (value) {
                      controller.setCurrentPage(value);
                    },
                    itemCount: contents.length,
                    itemBuilder: (context, i) {
                      return OnboardingPage(onboardingModel: contents[i]);
                    },
                  ),
                ),
                SizedBox(
                  height: height * 5 / 100,
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: OnboardingPageBottomSection(
                      controller: controller,
                      pageController: pageController,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),);
  }
}
