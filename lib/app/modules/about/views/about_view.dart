import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:taskwarrior/app/modules/about/views/about_page_app_bar.dart';
import 'package:taskwarrior/app/modules/about/views/about_page_body.dart';

import '../controllers/about_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AboutPageAppBar(),
      backgroundColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.white,
      body: const AboutPageBody(),
    );
  }
}
