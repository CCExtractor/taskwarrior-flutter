import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/taskfunctions/projects.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

class ProjectsColumn extends StatelessWidget {
  const ProjectsColumn({
    required this.projects,
    required this.projectFilter,
    required this.callback,
    super.key,
  });

  final Map<String, ProjectNode> projects;
  final String projectFilter;
  final void Function(String) callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Project : ",
                style: TextStyle(
                  fontFamily: FontFamily.poppins,
                  fontWeight: TaskWarriorFonts.bold,
                  fontSize: TaskWarriorFonts.fontSizeSmall,
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
              ),
              SizedBox(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        projectFilter == "" ? "" : projectFilter,
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontSize: TaskWarriorFonts.fontSizeSmall,
                          color: AppSettings.isDarkMode
                              ? TaskWarriorColors.white
                              : TaskWarriorColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("All Projects",
                  style: TextStyle(
                    fontFamily: FontFamily.poppins,
                    fontSize: TaskWarriorFonts.fontSizeSmall,
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.white
                        : TaskWarriorColors.black,
                  )),
            ],
          ),
        ),
        if (projects.isNotEmpty)
          ...projects.entries
              .where((entry) => entry.value.parent == null)
              .map((entry) => ProjectTile(
                    project: entry.key,
                    projects: projects,
                    projectFilter: projectFilter,
                    callback: callback,
                  ))
        else
          Column(
            children: [
              Text(
                "No Projects Found",
                style: TextStyle(
                  fontFamily: FontFamily.poppins,
                  fontSize: TaskWarriorFonts.fontSizeSmall,
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
            ],
          ),
      ],
    );
  }
}

class ProjectTile extends StatelessWidget {
  const ProjectTile({
    required this.project,
    required this.projects,
    required this.projectFilter,
    required this.callback,
    super.key,
  });

  final String project;
  final Map<String, ProjectNode> projects;
  final String projectFilter;
  final void Function(String) callback;

  @override
  Widget build(BuildContext context) {
    var node = projects[project]!;

    var title = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            project,
            style: GoogleFonts.poppins(
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.white
                    : TaskWarriorColors.black),
          ),
        ),
        Text(
          (node.children.isEmpty)
              ? '${node.subtasks}'
              : '(${node.tasks}) ${node.subtasks}',
          style: GoogleFonts.poppins(
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.white
                  : TaskWarriorColors.black),
        )
      ],
    );

    var radio = Radio(
      activeColor: AppSettings.isDarkMode
          ? TaskWarriorColors.white
          : TaskWarriorColors.ksecondaryBackgroundColor,
      focusColor: AppSettings.isDarkMode
          ? TaskWarriorColors.white
          : TaskWarriorColors.ksecondaryBackgroundColor,
      toggleable: true,
      value: project,
      groupValue: projectFilter,
      onChanged: (_) => callback(project),
    );

    return (node.children.isEmpty)
        ? GestureDetector(
            onTap: () => callback(project),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                radio,
                Text(
                  project,
                  maxLines: 3,
                  // style: GoogleFonts.poppins(
                  //     color: AppSettings.isDarkMode
                  //         ? TaskWarriorColors.white
                  //         : TaskWarriorColors.black),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  margin: const EdgeInsets.only(right: 10),
                  decoration: const BoxDecoration(
                      // color: (AppSettings.isDarkMode
                      //     ? TaskWarriorColors.white
                      //     : TaskWarriorColors.ksecondaryBackgroundColor),
                      ),
                  child: Text(
                    (node.children.isEmpty)
                        ? '${node.subtasks}'
                        : '(${node.tasks}) ${node.subtasks}',
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.black
                          : TaskWarriorColors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        : ExpansionTile(
            controlAffinity: ListTileControlAffinity.leading,
            key: PageStorageKey(project),
            leading: radio,
            title: title,
            backgroundColor: AppSettings.isDarkMode
                ? TaskWarriorColors.ksecondaryBackgroundColor
                : TaskWarriorColors.ksecondaryBackgroundColor,
            textColor: AppSettings.isDarkMode
                ? TaskWarriorColors.white
                : TaskWarriorColors.ksecondaryBackgroundColor,
            children: node.children
                .map((childProject) => ProjectTile(
                      project: childProject,
                      projects: projects,
                      projectFilter: projectFilter,
                      callback: callback,
                    ))
                .toList(),
          );
  }
}
