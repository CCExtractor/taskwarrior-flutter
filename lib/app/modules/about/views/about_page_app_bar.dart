import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/about/controllers/about_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

class AboutPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AboutController aboutController;
  const AboutPageAppBar({required this.aboutController,super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
      title: Text(
        SentenceManager(
                      currentLanguage: aboutController.selectedLanguage.value)
                  .sentences
                  .aboutPageAppBarTitle,
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
