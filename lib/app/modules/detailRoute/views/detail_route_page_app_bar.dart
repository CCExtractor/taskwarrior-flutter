import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';

class DetailRoutePageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final DetailRouteController controller;
  const DetailRoutePageAppBar({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackButton(color: TaskWarriorColors.white),
      backgroundColor: Palette.kToDark,
      title: Text(
        controller.appBarTitle,
        style: TextStyle(
          color: TaskWarriorColors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
