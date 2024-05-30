import 'package:flutter/material.dart';
import 'package:taskwarrior/app/models/onboarding_model.dart';
import 'package:taskwarrior/app/utils/gen/assets.gen.dart';

List<OnboardingModel> contents = [
  OnboardingModel(
    title: "Welcome to Taskwarrior",
    image:Assets.svg.s1.path,
    colors: const Color(0xffDAD3C8),
    desc:
        "Welcome to Taskwarrior, your ultimate task management solution. Manage your tasks, group them, and organize your work with ease.",
  ),
  OnboardingModel(
    title: "Powerful Reporting",
    image:Assets.svg.s2.path,
    colors: const Color(0xffFFE5DE),
    desc:
        "Generate insightful reports to analyze your task data. Gain valuable insights into your productivity and make data-driven decisions.",
  ),
  OnboardingModel(
    title: "Sync Across Devices",
    image:Assets.svg.s3.path,
    colors: const Color(0xffDCF6E6),
    desc:
        "Sync your tasks seamlessly across multiple Taskwarrior clients, ensuring you're always up to date and have access to your reports on any device.",
  ),
];
