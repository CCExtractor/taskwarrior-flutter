import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/widgets/taskwarrior_page_app_bar.dart';

/// The app bar used by the Statistics screens.
///
/// Now delegates to the shared [TaskWarriorPageAppBar] so it can no longer
/// drift from the other pages' app bars.
class ReportsPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ReportsPageAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return TaskWarriorPageAppBar(
      title: TaskWarriorPageAppBar.titleText(title),
      onLeadingPressed: () => Get.back(),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
