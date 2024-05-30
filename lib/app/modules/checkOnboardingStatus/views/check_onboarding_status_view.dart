import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/home/views/home_view.dart';
import 'package:taskwarrior/app/modules/onboarding/views/onboarding_view.dart';

import '../controllers/check_onboarding_status_controller.dart';

class CheckOnboardingStatusView
    extends GetView<CheckOnboardingStatusController> {
  const CheckOnboardingStatusView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.hasCompletedOnboardingStatus
          ? const HomeView()
          : const OnboardingView(),
    );
  }
}
