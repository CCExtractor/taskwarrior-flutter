import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
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
      child: ExpansionTile(
        key: const PageStorageKey('project-filter'),
        title: Text(
          'project:$projectFilter',
          style: GoogleFonts.firaMono(
              color: AppSettings.isDarkMode ? Colors.white : Colors.black),
        ),
        children: (Map.of(projects)
              ..removeWhere((_, nodeData) => nodeData.parent != null))
            .keys
            .map(ProjectTile.new)
            .toList(),
      ),
    );
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
                style: GoogleFonts.firaMono(
                    color:
                        AppSettings.isDarkMode ? Colors.white : Colors.black))),
        Text(
          (node.children.isEmpty)
              ? '${node.subtasks}'
              : '(${node.tasks}) ${node.subtasks}',
          style: GoogleFonts.firaMono(
              color: AppSettings.isDarkMode ? Colors.white : Colors.black),
        )
      ],
    );

    var radio = Radio(
      toggleable: true,
      value: project,
      groupValue: projectFilter,
      onChanged: (_) => callback(project),
    );

    return (node.children.isEmpty)
        ? ListTile(
            leading: radio,
            title: title,
            onTap: () => callback(project),
            tileColor: AppSettings.isDarkMode
                ? const Color.fromARGB(255, 48, 46, 46)
                : const Color.fromARGB(255, 220, 216, 216),
            textColor: AppSettings.isDarkMode
                ? Colors.white
                : const Color.fromARGB(255, 48, 46, 46),
          )
        : ExpansionTile(
            // textColor: Theme.of(context).textTheme.subtitle1!.color,
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
