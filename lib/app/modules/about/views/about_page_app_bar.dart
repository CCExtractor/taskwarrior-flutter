import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/about/controllers/about_controller.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/widgets/taskwarrior_page_app_bar.dart';

class AboutPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AboutController aboutController;
  const AboutPageAppBar({required this.aboutController, super.key});

  @override
  Widget build(BuildContext context) {
    return TaskWarriorPageAppBar(
      title: TaskWarriorPageAppBar.titleText(
        SentenceManager(currentLanguage: aboutController.selectedLanguage.value)
            .sentences
            .aboutPageAppBarTitle,
      ),
      onLeadingPressed: () => Navigator.pop(context),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
