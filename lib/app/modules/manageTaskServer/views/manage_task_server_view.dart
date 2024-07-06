// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/manageTaskServer/views/manage_task_server_page_app_bar.dart';
import 'package:taskwarrior/app/modules/manageTaskServer/views/manage_task_server_page_body.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';

import 'package:taskwarrior/app/utils/app_settings.dart';

import '../controllers/manage_task_server_controller.dart';

class ManageTaskServerView extends GetView<ManageTaskServerController> {
  const ManageTaskServerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ManageTaskServerPageAppBar(controller: controller),
      backgroundColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.kLightPrimaryBackgroundColor,
      body: ManageTaskServerPageBody(controller: controller),
    );
  }
}
