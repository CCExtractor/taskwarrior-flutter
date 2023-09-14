import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/controller/onboarding_controller.dart';
import 'package:taskwarrior/views/Onboarding/Model/onboarding_contents.dart';
import 'package:taskwarrior/views/Onboarding/Components/size_config.dart';
import 'package:taskwarrior/views/home/home.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;

  AnimatedContainer _buildDots({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: Color(0xFF000000),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return Scaffold(
      backgroundColor: contents[_currentPage].colors,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return _buildOnboardingPage(contents[i], width, height);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: _buildBottomSection(width),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(
      OnboardingModel content, double width, double height) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          SvgPicture.asset(
            content.image,
            height: SizeConfig.blockV! * 30,
          ),
          SizedBox(
            height: (height >= 840) ? 60 : 30,
          ),
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: (width <= 550) ? 30 : 35,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            content.desc,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
              fontSize: (width <= 550) ? 17 : 17,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            contents.length,
            (int index) => _buildDots(index: index),
          ),
        ),
        _currentPage + 1 == contents.length
            ? _buildStartButton(width)
            : _buildNextButton(width),
      ],
    );
  }

  Widget _buildStartButton(double width) {
    final OnboardingController onboardingController = OnboardingController();

    return Padding(
      padding: const EdgeInsets.all(30),
      child: ElevatedButton(
        onPressed: () {
          onboardingController.markOnboardingAsCompleted();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: (width <= 550)
              ? const EdgeInsets.symmetric(horizontal: 100, vertical: 20)
              : EdgeInsets.symmetric(horizontal: width * 0.2, vertical: 25),
          textStyle: GoogleFonts.poppins(fontSize: (width <= 550) ? 13 : 17),
        ),
        child: Text(
          "Start",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w300,
            color: Colors.white,
            fontSize: (width <= 550) ? 17 : 17,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(double width) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              _controller.jumpToPage(2);
            },
            style: TextButton.styleFrom(
              elevation: 0,
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: (width <= 550) ? 13 : 17,
              ),
            ),
            child: Text(
              "Skip",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: (width <= 550) ? 12 : 12,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _controller.nextPage(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 0,
              padding: (width <= 550)
                  ? const EdgeInsets.symmetric(horizontal: 30, vertical: 20)
                  : const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              textStyle: TextStyle(fontSize: (width <= 550) ? 13 : 17),
            ),
            child: Text(
              "Next",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                color: Colors.white,
                fontSize: (width <= 550) ? 12 : 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
