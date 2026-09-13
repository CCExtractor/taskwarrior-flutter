import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

/// One row inside a settings card. Supports a leading widget and an [onTap] so
/// navigation rows (e.g. Logs) behave like the rest of the app instead of
/// relying on a small trailing icon to be tapped.
class SettingsPageListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget? trailing;
  final Widget? leading;
  final VoidCallback? onTap;

  const SettingsPageListTile({
    super.key,
    required this.title,
    required this.subTitle,
    this.trailing,
    this.leading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return ListTile(
      onTap: onTap,
      leading: leading,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      minVerticalPadding: 14,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: TaskWarriorFonts.semiBold,
          fontSize: TaskWarriorFonts.fontSizeMedium,
          color: tColors.primaryTextColor,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          subTitle,
          style: GoogleFonts.poppins(
            color: tColors.greyShade,
            fontSize: TaskWarriorFonts.fontSizeSmall,
          ),
        ),
      ),
      trailing: trailing,
    );
  }
}
