import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/widgets/taskwarrior_page_app_bar.dart';

class DetailRoutePageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final DetailRouteController controller;
  const DetailRoutePageAppBar({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TaskWarriorPageAppBar(
      title: TaskWarriorPageAppBar.titleText(controller.appBarTitle),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
