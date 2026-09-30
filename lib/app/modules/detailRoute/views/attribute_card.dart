import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

/// The `name: value` card every attribute on the detail page is drawn with.
/// Editors only supply the tap behaviour.
class AttributeCard extends StatelessWidget {
  const AttributeCard({
    required this.name,
    required this.value,
    this.isEditable = true,
    this.onTap,
    this.onLongPress,
    this.cardKey,
    this.cardColor,
    this.tileColor,
    super.key,
  });

  final String name;

  /// Shown as-is; `null` renders the localized "not selected" text.
  final String? value;
  final bool isEditable;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Key placed on the [Card], e.g. a tour anchor.
  final Key? cardKey;

  /// Defaults to the theme's secondary background colour.
  final Color? cardColor;
  final Color? tileColor;

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final Color? textColor = isEditable
        ? tColors.primaryTextColor
        : tColors.primaryDisabledTextColor;

    return Card(
      key: cardKey,
      color: cardColor ?? tColors.secondaryBackgroundColor,
      child: ListTile(
        enabled: isEditable,
        tileColor: tileColor,
        textColor: textColor,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '$name:'.padRight(13),
                  style: TextStyle(
                    fontFamily: FontFamily.poppins,
                    fontWeight: TaskWarriorFonts.bold,
                    fontSize: TaskWarriorFonts.fontSizeMedium,
                    color: textColor,
                  ),
                ),
                TextSpan(
                  text: value ??
                      SentenceManager(
                              currentLanguage: AppSettings.selectedLanguage)
                          .sentences
                          .notSelected,
                  style: TextStyle(
                    fontFamily: FontFamily.poppins,
                    fontSize: TaskWarriorFonts.fontSizeMedium,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
