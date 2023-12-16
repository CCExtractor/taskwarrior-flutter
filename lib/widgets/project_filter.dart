import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/widgets/taskw.dart';

class InheritedProjects extends InheritedWidget {
  const InheritedProjects({
    required this.projects,
    required this.projectFilter,
    required this.callback,
    required child,
    Key? key,
  }) : super(key: key, child: child);

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
      {Key? key})
      : super(key: key);

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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Project : ",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color:
                          AppSettings.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 40.w,
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
                                  ? Colors.white
                                  : Colors.black,
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
                    "All Projecs",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color:
                          AppSettings.isDarkMode ? Colors.white : Colors.black,
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
                          ? Colors.white
                          : const Color.fromARGB(255, 48, 46, 46),
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
  const ProjectTile(this.project, {Key? key}) : super(key: key);

  final String project;

  @override
  Widget build(BuildContext context) {
    var inheritedProjects = InheritedProjects.of(context);

    var node = inheritedProjects.projects[project]!;
    var projectFilter = inheritedProjects.projectFilter;
    var callback = inheritedProjects.callback;

    var title = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Text(project,
                style: GoogleFonts.poppins(
                    color:
                        AppSettings.isDarkMode ? Colors.white : Colors.black))),
        Text(
          (node.children.isEmpty)
              ? '${node.subtasks}'
              : '(${node.tasks}) ${node.subtasks}',
          style: GoogleFonts.poppins(
              color: AppSettings.isDarkMode ? Colors.white : Colors.black),
        )
      ],
    );

    var radio = Radio(
      activeColor: AppSettings.isDarkMode
          ? Colors.white
          : const Color.fromARGB(255, 48, 46, 46),
      focusColor: AppSettings.isDarkMode
          ? Colors.white
          : const Color.fromARGB(255, 48, 46, 46),
      toggleable: true,
      value: project,
      groupValue: projectFilter,
      onChanged: (_) => callback(project),
    );

    return (node.children.isEmpty)
        ? GestureDetector(
            onTap: () => callback(project),
            child: Row(
              children: [
                radio,
                SizedBox(
                  width: 45.w,
                  child: Text(project,
                      maxLines: 3,
                      style: GoogleFonts.poppins(
                          color: AppSettings.isDarkMode
                              ? Colors.white
                              : Colors.black)),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: (AppSettings.isDarkMode
                        ? Colors.white
                        : const Color.fromARGB(255, 48, 46, 46)),
                  ),
                  child: Text(
                    (node.children.isEmpty)
                        ? '${node.subtasks}'
                        : '(${node.tasks}) ${node.subtasks}',
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                        color: AppSettings.isDarkMode
                            ? Colors.black
                            : Colors.white),
                  ),
                ),
              ],
            ),
          )
        : ExpansionTile(
            controlAffinity: ListTileControlAffinity.leading,
            leading: radio,
            title: title,
            backgroundColor: AppSettings.isDarkMode
                ? const Color.fromARGB(255, 48, 46, 46)
                : const Color.fromARGB(255, 220, 216, 216),
            textColor: AppSettings.isDarkMode
                ? Colors.white
                : const Color.fromARGB(255, 48, 46, 46),
            children: node.children.map(ProjectTile.new).toList(),
          );
  }
}
