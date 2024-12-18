import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:taskwarrior/app/modules/about/controllers/about_controller.dart';
import 'package:taskwarrior/app/utils/gen/assets.gen.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';

class AboutPageBody extends StatelessWidget {
  final AboutController aboutController;
  const AboutPageBody({required this.aboutController, super.key});

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    String introduction =
        SentenceManager(currentLanguage: aboutController.selectedLanguage.value)
            .sentences
            .aboutPageProjectDescription;

    return Padding(
      padding: EdgeInsets.only(
          top: Get.height * 0.01,
          left: Get.width * 0.02,
          right: Get.width * 0.02),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: Get.height * 0.02,
            ),
            SizedBox(
                child: SvgPicture.asset(
              Assets.svg.logo.path,
              height: Get.height * 0.2,
              width: Get.width * 1,
            )),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Text(
              "Taskwarrior",
              style: TextStyle(
                fontFamily: FontFamily.poppins,
                fontWeight: TaskWarriorFonts.bold,
                fontSize: TaskWarriorFonts.fontSizeExtraLarge,
                color: tColors.primaryTextColor,
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<String>(
                  future: getAppInfo(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final appInfoLines = snapshot.data!.split(' ');

                      return Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Version: ',
                                  style: TextStyle(
                                    fontFamily: FontFamily.poppins,
                                    fontWeight: TaskWarriorFonts.bold,
                                    fontSize: TaskWarriorFonts.fontSizeMedium,
                                    color: tColors.primaryTextColor,
                                  ),
                                ),
                                TextSpan(
                                  text: appInfoLines[1],
                                  style: TextStyle(
                                    fontFamily: FontFamily.poppins,
                                    fontSize: TaskWarriorFonts.fontSizeMedium,
                                    color: tColors.primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.85,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Package: ',
                                      style: TextStyle(
                                        fontFamily: FontFamily.poppins,
                                        fontWeight: TaskWarriorFonts.bold,
                                        fontSize:
                                            TaskWarriorFonts.fontSizeMedium,
                                        color: tColors.primaryTextColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: appInfoLines[0],
                                      style: TextStyle(
                                        fontFamily: FontFamily.poppins,
                                        fontSize:
                                            TaskWarriorFonts.fontSizeMedium,
                                        color: tColors.primaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.05,
            ),
            Text(
              introduction,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontFamily.poppins,
                fontWeight: TaskWarriorFonts.medium,
                fontSize: TaskWarriorFonts.fontSizeSmall,
                color: tColors.primaryTextColor,
              ),
            ),
            SizedBox(
              height: Get.height * 0.06,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: Get.width * 0.4,
                  height: Get.height * 0.05,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tColors.secondaryTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      // Launch GitHub URL.

                      String url =
                          "https://github.com/CCExtractor/taskwarrior-flutter";
                      if (!await launchUrl(Uri.parse(url))) {
                        throw Exception('Could not launch $url');
                      }
                    },
                    icon: SvgPicture.asset(Assets.svg.github.path,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                            tColors.secondaryBackgroundColor!,
                            BlendMode.srcIn)),
                    label: Text(
                      "GitHub",
                      style: TextStyle(
                        fontFamily: FontFamily.poppins,
                        fontWeight: TaskWarriorFonts.medium,
                        fontSize: TaskWarriorFonts.fontSizeSmall,
                        color: tColors.secondaryBackgroundColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.4,
                  height: Get.height * 0.05,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tColors.secondaryTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      String url = "https://ccextractor.org/";
                      if (!await launchUrl(Uri.parse(url))) {
                        throw Exception('Could not launch $url');
                      }
                    },
                    icon: SvgPicture.asset(Assets.svg.link.path,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                            tColors.secondaryBackgroundColor!,
                            BlendMode.srcIn
                            )
                        ),
                    label: Text(
                      "CCExtractor",
                      style: TextStyle(
                        fontFamily: FontFamily.poppins,
                        fontWeight: TaskWarriorFonts.medium,
                        fontSize: TaskWarriorFonts.fontSizeSmall,
                        color: tColors.secondaryBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.04,
            ),
            Text(
              SentenceManager(
                      currentLanguage: aboutController.selectedLanguage.value)
                  .sentences
                  .aboutPageGitHubLink,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontFamily.poppins,
                fontWeight: TaskWarriorFonts.semiBold,
                fontSize: TaskWarriorFonts.fontSizeMedium,
                color: tColors.primaryTextColor,
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> getAppInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  return '${packageInfo.packageName} ${packageInfo.version}';
}
