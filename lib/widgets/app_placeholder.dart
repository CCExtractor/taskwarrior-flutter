import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/widgets/pallete.dart';

class AppSetupPlaceholder extends StatelessWidget {
  const AppSetupPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor:
            AppSettings.isDarkMode ? Palette.kToDark.shade200 : Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  child: SvgPicture.asset(
                "assets/svg/logo.svg",
                height: 100,
                width: double.infinity,
              )),
              const SizedBox(height: 30.0),
              const CircularProgressIndicator(),
              const SizedBox(height: 16.0),
              Text(
                "Setting up the app...",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
