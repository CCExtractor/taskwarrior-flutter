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

const String _githubUrl = "https://github.com/CCExtractor/taskwarrior-flutter";
const String _zulipUrl = "https://ccextractor.org/public/general/support/";
const String _ccextractorUrl = "https://ccextractor.org/";

class AboutPageBody extends StatelessWidget {
  final AboutController aboutController;
  const AboutPageBody({required this.aboutController, super.key});

  @override
  Widget build(BuildContext context) {
    final TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final sentences = SentenceManager(
      currentLanguage: aboutController.selectedLanguage.value,
    ).sentences;

    final double horizontalPadding = Get.width * 0.06;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          Get.height * 0.05,
          horizontalPadding,
          Get.height * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AboutHeader(tColors: tColors),
            SizedBox(height: Get.height * 0.03),
            Text(
              sentences.aboutPageProjectDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontFamily.poppins,
                fontWeight: TaskWarriorFonts.regular,
                fontSize: TaskWarriorFonts.fontSizeSmall + 1,
                height: 1.6,
                color: tColors.primaryTextColor,
              ),
            ),
            SizedBox(height: Get.height * 0.035),
            _SupportCard(
              tColors: tColors,
              message: sentences.aboutPageSupport,
            ),
            SizedBox(height: Get.height * 0.03),
            _LinkTile(
              tColors: tColors,
              label: "GitHub",
              svgPath: Assets.svg.github.path,
              url: _githubUrl,
            ),
            const SizedBox(height: 12),
            _LinkTile(
              tColors: tColors,
              label: "Zulip",
              svgPath: Assets.svg.link.path,
              url: _zulipUrl,
            ),
            const SizedBox(height: 12),
            _LinkTile(
              tColors: tColors,
              label: "CCExtractor",
              svgPath: Assets.svg.link.path,
              url: _ccextractorUrl,
            ),
            SizedBox(height: Get.height * 0.04),
            Text(
              sentences.aboutPageGitHubLink,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontFamily.poppins,
                fontWeight: TaskWarriorFonts.medium,
                fontSize: TaskWarriorFonts.fontSizeSmall,
                height: 1.5,
                color: tColors.greyShade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutHeader extends StatelessWidget {
  final TaskwarriorColorTheme tColors;
  const _AboutHeader({required this.tColors});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 96,
          width: 96,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: tColors.secondaryBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(Assets.svg.logo.path),
        ),
        const SizedBox(height: 16),
        Text(
          "Taskwarrior",
          style: TextStyle(
            fontFamily: FontFamily.poppins,
            fontWeight: TaskWarriorFonts.bold,
            fontSize: TaskWarriorFonts.fontSizeExtraLarge,
            color: tColors.primaryTextColor,
          ),
        ),
        const SizedBox(height: 10),
        FutureBuilder<String>(
          future: getAppInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const SizedBox.shrink();
            }
            final appInfoLines = snapshot.data!.split(' ');
            final packageName = appInfoLines.isNotEmpty ? appInfoLines[0] : '';
            final version = appInfoLines.length > 1 ? appInfoLines[1] : '';

            return Column(
              children: [
                _Pill(
                  tColors: tColors,
                  label: "Version $version",
                ),
                const SizedBox(height: 8),
                Text(
                  packageName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontFamily.poppins,
                    fontWeight: TaskWarriorFonts.regular,
                    fontSize: TaskWarriorFonts.fontSizeSmall,
                    color: tColors.greyShade,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final TaskwarriorColorTheme tColors;
  final String label;
  const _Pill({required this.tColors, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: tColors.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: FontFamily.poppins,
          fontWeight: TaskWarriorFonts.medium,
          fontSize: TaskWarriorFonts.fontSizeSmall,
          color: tColors.primaryTextColor,
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  final TaskwarriorColorTheme tColors;
  final String message;
  const _SupportCard({required this.tColors, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: tColors.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 22,
            color: tColors.primaryTextColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: FontFamily.poppins,
                fontWeight: TaskWarriorFonts.regular,
                fontSize: TaskWarriorFonts.fontSizeSmall + 0.5,
                height: 1.5,
                color: tColors.primaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final TaskwarriorColorTheme tColors;
  final String label;
  final String svgPath;
  final String url;
  const _LinkTile({
    required this.tColors,
    required this.label,
    required this.svgPath,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(14);
    return Material(
      color: tColors.secondaryBackgroundColor,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: () => _openLink(context, url),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              SvgPicture.asset(
                svgPath,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  tColors.primaryTextColor!,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: FontFamily.poppins,
                    fontWeight: TaskWarriorFonts.medium,
                    fontSize: TaskWarriorFonts.fontSizeMedium,
                    color: tColors.primaryTextColor,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: tColors.greyShade,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _openLink(BuildContext context, String url) async {
  final Uri uri = Uri.parse(url);
  final bool launched =
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open $url')),
    );
  }
}

Future<String> getAppInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  return '${packageInfo.packageName} ${packageInfo.version}';
}
