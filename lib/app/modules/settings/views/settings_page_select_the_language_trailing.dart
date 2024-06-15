import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/settings/controllers/settings_controller.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';

class SettingsPageSelectTheLanguageTrailing extends StatelessWidget {
  final SettingsController controller;

  const SettingsPageSelectTheLanguageTrailing(
      {required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButton<SupportedLanguage>(
        value: controller.selectedLanguage.value,
        onChanged: (value) {
          controller.setSelectedLanguage(value!);
        },
        items: SupportedLanguage.values.map((language) {
          return DropdownMenuItem<SupportedLanguage>(
            value: language,
            child: Text(_getLanguageName(language)),
          );
        }).toList(),
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
      default:
        return '';
    }
  }
}
