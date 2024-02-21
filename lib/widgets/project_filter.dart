import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';
import 'package:taskwarrior/config/taskwarriorfonts.dart';
import 'package:taskwarrior/widgets/taskw.dart';

class InheritedProjects extends InheritedWidget {
  // ignore: use_super_parameters
  const InheritedProjects({
    required this.projects,
    required this.projectFilter,
    required this.callback,
    required child,
    super.key,
  }) : super(child: child);

  final Map<String, ProjectNode> projects;
  final String projectFilter;
  final void Function(String) callback;

  static InheritedProjects of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedProjects>()!;
  }

  @override
  bool updateShouldNotify(InheritedProjects oldWidget) =>
      projectFilter != oldWidget.projectFilter ||
      projects != oldWidget.projects ||
      callback != oldWidget.callback;
}

class ProjectsColumn extends StatelessWidget {
  const ProjectsColumn(this.projects, this.projectFilter, this.callback,
      {super.key});

  final Map<String, ProjectNode> projects;
  final String projectFilter;
  final void Function(String) callback;

  @override
  Widget build(BuildContext context) {
    return InheritedProjects(
        projectFilter: projectFilter,
        callback: callback,
        projects: projects,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Project : ",
                    style: GoogleFonts.poppins(
                      fontWeight: TaskWarriorFonts.bold,
                      fontSize: 15,
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
                            projectFilter == ""
                                ? "Not selected"
                                : projectFilter,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "All Projects",
                    style: GoogleFonts.poppins(
                      fontWeight: TaskWarriorFonts.semiBold,
                      fontSize: 12,
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                  ),
                ],
              ),
            ),
            if (projects.isNotEmpty)
              ...projects.entries
                  .where((entry) => entry.value.parent == null)
                  .map((entry) => ProjectTile(entry.key))
            else
              Column(
                children: [
                  Text(
                    "No Projects Found",
                    style: GoogleFonts.poppins(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
          ],
        ));
  }
}

class ProjectTile extends StatelessWidget {
  const ProjectTile(this.project, {super.key});

  final String project;

  @override
  Widget build(BuildContext context) {
    var inheritedProjects = InheritedProjects.of(context);

    var node = inheritedProjects.projects[project]!;
    var projectFilter = inheritedProjects.projectFilter;
    var callback = inheritedProjects.callback;

    var title = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
            child: Text(project,
                style: GoogleFonts.poppins(
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.white
                        : TaskWarriorColors.black))),
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
                Text(project,
                    maxLines: 3,
                    style: GoogleFonts.poppins(
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.white
                            : TaskWarriorColors.black)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: (AppSettings.isDarkMode
                        ? TaskWarriorColors.white
                        : TaskWarriorColors.ksecondaryBackgroundColor),
                  ),
                  child: Text(
                    (node.children.isEmpty)
                        ? '${node.subtasks}'
                        : '(${node.tasks}) ${node.subtasks}',
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.black
                            : TaskWarriorColors.white),
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
            children: node.children.map(ProjectTile.new).toList(),
          );
  }
}
