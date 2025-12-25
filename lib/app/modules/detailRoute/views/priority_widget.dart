import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class PriorityWidget extends StatelessWidget {
  const PriorityWidget({
    required this.name,
    required this.value,
    required this.callback,
    required this.globalKey,
    this.isEditable = true,
    super.key,
  });

  final String name;
  final dynamic value;
  final void Function(dynamic) callback;
  final GlobalKey globalKey;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final Color? textColor = isEditable
        ? tColors.primaryTextColor
        : tColors.primaryDisabledTextColor;

    // Normalize value: null → X
    final String priority =
        (value == null || value == '') ? 'X' : value.toString();

    return Card(
      key: globalKey,
      color: tColors.secondaryBackgroundColor,
      child: ListTile(
        enabled: isEditable,
        textColor: tColors.primaryTextColor,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '$name:'.padRight(13),
                      style: GoogleFonts.poppins(
                        fontWeight: TaskWarriorFonts.bold,
                        fontSize: TaskWarriorFonts.fontSizeMedium,
                        color: textColor,
                      ),
                    ),
                    TextSpan(
                      text: priority, // Always show X / H / M / L
                      style: GoogleFonts.poppins(
                        fontSize: TaskWarriorFonts.fontSizeMedium,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: isEditable
            ? () {
                switch (priority) {
                  case 'X':
                    callback('H');
                    break;
                  case 'H':
                    callback('M');
                    break;
                  case 'M':
                    callback('L');
                    break;
                  case 'L':
                    callback('X');
                    break;
                }
              }
            : null,
      ),
    );
  }
}
