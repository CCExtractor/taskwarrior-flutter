import 'package:flutter/material.dart';

class OnboardingModel {
  final String title;
  final String image;
  final String desc;
  final Color colors;

  OnboardingModel({
    required this.title,
    required this.image,
    required this.desc,
    required this.colors,
  });
}

List<OnboardingModel> contents = [
  OnboardingModel(
    title: "Welcome to Taskwarrior",
    image: "assets/svg/s1.svg",
    colors: const Color(0xffDAD3C8),
    desc:
        "Welcome to Taskwarrior, your ultimate task management solution. Manage your tasks, group them, and organize your work with ease.",
  ),
  OnboardingModel(
    title: "Powerful Reporting",
    image: "assets/svg/s3.svg",
    colors: const Color(0xffFFE5DE),
    desc:
        "Generate insightful reports to analyze your task data. Gain valuable insights into your productivity and make data-driven decisions.",
  ),
  OnboardingModel(
    title: "Sync Across Devices",
    // image: "assets/svg/s3.svg",
    image: "assets/svg/s2.svg",
    colors: const Color(0xffDCF6E6),
    desc:
        "Sync your tasks seamlessly across multiple Taskwarrior clients, ensuring you're always up to date and have access to your reports on any device.",
  ),
];
