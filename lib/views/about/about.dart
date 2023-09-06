// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:promts/controllers/fetchGithubApi.dart';
// import 'package:promts/models/model_theme.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
// import 'package:flutter_social_button/flutter_social_button.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';
import 'package:taskwarrior/widgets/pallete.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  String introduction =
      "Hi there! MABUD here. I am a CS student with a passion for building beautiful and functional applications. I have used OPEN API and Flutter to build this app. I am open to any suggestions and feedbacks.Contributions are always welcomed :)";

//   var controller = Get.put(ContributorController());

  @override
  Widget build(BuildContext context) {
    // var controller = Get.put(ContributorController());
    var color =
        AppSettings.isDarkMode ? Colors.white : Palette.kToDark.shade200;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Palette.kToDark.shade200,
        title: const Text(
          'About',
          style: TextStyle(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            color: Appcolors.white,
          ),
        ),
      ),
      backgroundColor:
          AppSettings.isDarkMode ? Palette.kToDark.shade200 : Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 1.h, left: 2.w, right: 2.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  child: SvgPicture.asset(
                "assets/svg/logo.svg",
                height: 20.h,
                width: 100.w,
              )),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "Taskwarrior",
                style: GoogleFonts.firaMono(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(
                height: 2.h,
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
                        // Split the app info into lines
                        final appInfoLines = snapshot.data!.split(' ');
                        return Column(
                          children: [
                            Text(
                              'Version: ${appInfoLines[1]}', // Display app version (second part)
                              style: GoogleFonts.firaMono(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: AppSettings.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              'Package: ${appInfoLines[0]}', // Display package name (first part)
                              style: GoogleFonts.firaMono(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: AppSettings.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
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
                height: 2.h,
              ),
              Text(
                introduction,
                style: GoogleFonts.firaMono(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "For any further queries contact me through:",
                style: GoogleFonts.firaMono(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 40.w, // <-- Button Width
                    height: 5.h, // <-- Button height
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        // primary: HexColor("#202020"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                      onPressed: () async {
                        //   String url = "https://github.com/Pavel401";
                        //   if (!await launchUrl(Uri.parse(url))) {
                        //     throw Exception('Could not launch $url');
                        //   }
                      },
                      icon: SvgPicture.asset(
                        "assets/svg/github.svg",
                        width: 24.sp,
                        height: 24.sp,
                      ),
                      label: Text(
                        "GitHub",
                        style: GoogleFonts.firaMono(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AppSettings.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40.w, // <-- Button Width
                    height: 5.h, // <-- Button height
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                      onPressed: () async {
                        //   String url =
                        //       "https://www.linkedin.com/in/sk-mabud-alam-444a87133/";
                        //   if (!await launchUrl(Uri.parse(url))) {
                        //     throw Exception('Could not launch $url');
                        //   }
                      },
                      icon: SvgPicture.asset(
                        "assets/svg/github.svg",
                        width: 24.sp,
                        height: 24.sp,
                      ),
                      label: Text(
                        "LinkedIN",
                        style: GoogleFonts.firaMono(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AppSettings.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "All the contributors are listed below:",
                style: GoogleFonts.firaMono(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Text(
                "Contribute on github to get your name here",
                style: GoogleFonts.firaMono(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> getAppInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  return '${packageInfo.packageName} ${packageInfo.version}';
}
