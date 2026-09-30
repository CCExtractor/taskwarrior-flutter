import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/about/controllers/about_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

class AboutPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AboutController aboutController;
  const AboutPageAppBar({required this.aboutController, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
      title: Text(
        SentenceManager(currentLanguage: aboutController.selectedLanguage.value)
            .sentences
            .aboutPageAppBarTitle,
        style: TextStyle(
          fontFamily: FontFamily.poppins,
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: TaskWarriorColors.white,
        ),
      ),
      leading: IconButton(
        splashRadius: 22,
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: TaskWarriorColors.white,
          size: 18,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
