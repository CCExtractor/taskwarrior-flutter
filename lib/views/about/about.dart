import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';
import 'package:taskwarrior/widgets/pallete.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String introduction =
      "This project aims to build an app for Taskwarrior. It is your task management app across all platforms. It helps you manage your tasks and filter them as per your needs.";

  @override
  Widget build(BuildContext context) {
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
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
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
                        final appInfoLines = snapshot.data!.split(' ');

                        return Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Version: ',
                                    style: GoogleFonts.firaMono(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppSettings.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: appInfoLines[1],
                                    style: GoogleFonts.firaMono(
                                      fontSize: 15,
                                      color: AppSettings.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Package: ',
                                    style: GoogleFonts.firaMono(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppSettings.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: appInfoLines[0],
                                    style: GoogleFonts.firaMono(
                                      fontSize: 15,
                                      color: AppSettings.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
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
                height: 5.h,
              ),
              Text(
                introduction,
                textAlign: TextAlign.center,
                style: GoogleFonts.firaMono(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(
                height: 6.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 40.w,
                    height: 5.h,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppSettings.isDarkMode
                            ? const Color.fromARGB(255, 220, 216, 216)
                            : const Color.fromARGB(255, 48, 46, 46),
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
                      icon: SvgPicture.asset("assets/svg/github.svg",
                          width: 15.sp,
                          height: 15.sp,
                          colorFilter: ColorFilter.mode(
                              AppSettings.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                              BlendMode.srcIn)),
                      label: Text(
                        "GitHub",
                        style: GoogleFonts.firaMono(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AppSettings.isDarkMode
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40.w,
                    height: 5.h,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppSettings.isDarkMode
                            ? const Color.fromARGB(255, 220, 216, 216)
                            : const Color.fromARGB(255, 48, 46, 46),
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
                      icon: SvgPicture.asset("assets/svg/link.svg",
                          width: 15.sp,
                          height: 15.sp,
                          colorFilter: ColorFilter.mode(
                              AppSettings.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                              BlendMode.srcIn)),
                      label: Text(
                        "CCExtractor",
                        style: GoogleFonts.firaMono(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AppSettings.isDarkMode
                              ? Colors.black
                              : Colors.white,
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
                "Eager to enhance this project? Visit our GitHub repository.",
                textAlign: TextAlign.center,
                style: GoogleFonts.firaMono(
                  fontWeight: FontWeight.w600,
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
