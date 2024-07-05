import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:taskwarrior/app/modules/home/views/filter_drawer_home_page.dart';
import 'package:taskwarrior/app/modules/home/views/home_page_app_bar.dart';
import 'package:taskwarrior/app/modules/home/views/home_page_body.dart';
import 'package:taskwarrior/app/modules/home/views/home_page_floating_action_button.dart';
import 'package:taskwarrior/app/modules/home/views/nav_drawer.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/taskserver/taskserver.dart';
import 'package:taskwarrior/app/utils/home_path/home_path.dart' as rc;

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    Server? server;
    Credentials? credentials;

    var contents = rc.Taskrc(controller.storage.home.home).readTaskrc();
    if (contents != null) {
      server = Taskrc.fromString(contents).server;
      credentials = Taskrc.fromString(contents).credentials;
    }

    if (contents != null) {
      server = Taskrc.fromString(contents).server;
      credentials = Taskrc.fromString(contents).credentials;
    }

    controller.checkForSync(context);

    return Obx(
      () => Scaffold(
        appBar: HomePageAppBar(
          server: server,
          credentials: credentials,
          controller: controller,
        ),
        backgroundColor: controller.isDarkModeOn.value
            ? TaskWarriorColors.kprimaryBackgroundColor
            : TaskWarriorColors.kLightPrimaryBackgroundColor,
        drawer: NavDrawer(homeController: controller),
        body: HomePageBody(controller: controller),
        endDrawer: Obx(
          () => FilterDrawer(
            filters: controller.getFilters(),
            homeController: controller,
          ),
        ),
        floatingActionButton:
            HomePageFloatingActionButton(controller: controller),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
