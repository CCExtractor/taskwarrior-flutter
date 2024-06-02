import 'package:flutter/material.dart';


import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';

class AboutPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AboutPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
      title: Text(
        'About',
        // style: GoogleFonts.poppins(color: TaskWarriorColors.white),
        style: TextStyle(
          fontFamily: FontFamily.poppins,
          color: TaskWarriorColors.white,
        ),
      ),
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.chevron_left,
          color: TaskWarriorColors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
