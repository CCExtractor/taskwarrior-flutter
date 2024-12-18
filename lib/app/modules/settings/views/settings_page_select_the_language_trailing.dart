import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/settings/controllers/settings_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class SettingsPageSelectTheLanguageTrailing extends StatelessWidget {
  final SettingsController controller;

  const SettingsPageSelectTheLanguageTrailing(
      {required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Obx(
      () => DropdownButton<SupportedLanguage>(
        value: controller.selectedLanguage.value,
        onChanged: (value) {
          controller.setSelectedLanguage(value!);
        },
        items: SupportedLanguage.values.map((language) {
          return DropdownMenuItem<SupportedLanguage>(
            value: language,
            child: Text(
              _getLanguageName(language),
              style: TextStyle(
                fontFamily: FontFamily.poppins,
                color: tColors.primaryTextColor,
              ),
            ),
          );
        }).toList(),
        dropdownColor: AppSettings.isDarkMode
            ? TaskWarriorColors.kprimaryBackgroundColor
            : TaskWarriorColors.kLightPrimaryBackgroundColor,
      ),
    );
  }

  String _getLanguageName(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.english:
        return 'English';
      case SupportedLanguage.hindi:
        return 'Hindi';
      case SupportedLanguage.marathi:
        return 'Marathi';
      case SupportedLanguage.french:
        return 'Français'; 
      case SupportedLanguage.spanish:
        return 'Español'; 
      case SupportedLanguage.bengali:
        return 'বাংলা'; 
      default:
        return '';
    }
  }
}
