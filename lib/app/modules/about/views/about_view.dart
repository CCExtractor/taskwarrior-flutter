import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:taskwarrior/app/modules/about/views/about_page_app_bar.dart';
import 'package:taskwarrior/app/modules/about/views/about_page_body.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

import '../controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});
  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Scaffold(
      appBar: AboutPageAppBar(aboutController: controller,),
      backgroundColor: tColors.primaryBackgroundColor,
      body: AboutPageBody(
        aboutController: controller,
      ),
    );
  }
}
