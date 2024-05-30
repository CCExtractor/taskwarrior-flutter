import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/gen/assets.gen.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                child: SvgPicture.asset(
              Assets.svg.logo.path,
              height: 100,
              width: double.infinity,
            )),
            const SizedBox(height: 30.0),
            const CircularProgressIndicator(),
            const SizedBox(height: 16.0),
            const Text(
              "Setting up the app...",
              style: TextStyle(
                fontFamily: FontFamily.poppins,
                fontSize: TaskWarriorFonts.fontSizeLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
