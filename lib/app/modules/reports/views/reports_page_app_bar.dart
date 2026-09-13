import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';

/// The app bar used by the Statistics screens.
///
/// Kept in step with the app's other page app bars (`AboutPageAppBar`,
/// `SettingsPageAppBar`): the same background, the bundled Poppins family, and
/// a 35px chevron. Building it inline in each host let those details drift.
class ReportsPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ReportsPageAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: FontFamily.poppins,
          color: TaskWarriorColors.white,
        ),
      ),
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Icon(
          Icons.chevron_left,
          color: TaskWarriorColors.white,
          size: 35,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
