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
  static const double _largeScreenBreakpoint = 800.0;

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
      () {
        // Get the current screen width
        final screenWidth = MediaQuery.of(context).size.width;
        final bool isLargeScreen = screenWidth >= _largeScreenBreakpoint;

        return Scaffold(
          appBar: HomePageAppBar(
            server: server,
            credentials: credentials,
            controller: controller,
          ),
          backgroundColor: controller.isDarkModeOn.value
              ? TaskWarriorColors.kprimaryBackgroundColor
              : TaskWarriorColors.kLightPrimaryBackgroundColor,
          // Only show default Scaffold drawer/endDrawer on small screens
          drawer: isLargeScreen ? null : NavDrawer(homeController: controller),
          endDrawer: isLargeScreen
              ? null
              : Obx(
                  () => FilterDrawer(
                    filters: controller.getFilters(),
                    homeController: controller,
                  ),
                ),
          body: isLargeScreen
              ? Row(
                  children: [
                    // Static Drawer
                    SizedBox(
                      width: 250, // Adjust width as needed for your drawer
                      child: NavDrawer(homeController: controller),
                    ),
                    // Main content takes remaining space
                    Expanded(
                      child: HomePageBody(
                        controller: controller,
                      ),
                    ),
                    // Static End Drawer
                    SizedBox(
                      width: 250, // Adjust width as needed for your end drawer
                      child: Obx(
                        () => FilterDrawer(
                          filters: controller.getFilters(),
                          homeController: controller,
                        ),
                      ),
                    ),
                  ],
                )
              : HomePageBody(
                  // Regular body for small screens
                  controller: controller,
                ),
          floatingActionButton:
              HomePageFloatingActionButton(controller: controller),
          resizeToAvoidBottomInset: false,
        );
      },
    );
  }
}
