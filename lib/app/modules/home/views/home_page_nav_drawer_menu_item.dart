import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class NavDrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const NavDrawerMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: tColors.dialogBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: tColors.primaryTextColor,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: tColors.primaryTextColor,
                fontSize: TaskWarriorFonts.fontSizeMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
