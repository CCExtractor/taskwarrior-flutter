List<String> projectPath(String project) {
  var result = <String>[];
  var depth = project.split('.').length;
  for (var i = 0; i < depth; i++) {
    result.add(ancestor(project, i)!);
  }
  return result;
}

String? ancestor(String project, int distance) {
  var parts = project.split('.');
  if (distance > parts.length - 1) {
    return null;
  }
  return parts.sublist(0, parts.length - distance).join('.');
}

class ProjectNode {
  ProjectNode([
    this.tasks = 0,
  ])  : children = <String>{},
        subtasks = 0;

  String? parent;
  Set<String> children;
  int tasks;
  int subtasks;

  Map<String, dynamic> toMap() => {
        'parent': parent,
        'children': children.toList(),
        'tasks': tasks,
        'subtasks': subtasks,
      };
}

Map<String, ProjectNode> sparseDecoratedProjectTree(Map<String, int> projects) {
  var result = <String, ProjectNode>{};

  for (var entry in projects.entries) {
    var path = projectPath(entry.key);
    var steps = path.asMap();

    result[entry.key] = ProjectNode(entry.value);

    for (var i = 0; i < path.length; i++) {
      var next = steps[i]!;

      result.putIfAbsent(next, ProjectNode.new);

      result[next]!.parent = steps[i + 1];

      if (i > 0) {
        result[next]!.children.add(steps[i - 1]!);
      }
    }
  }

  for (var entry in projects.entries) {
    var path = projectPath(entry.key);
    for (var project in path) {
      result[project]!.subtasks += entry.value;
    }
  }

  var toRemove = {
    for (var entry in result.entries)
      if ((entry.value.children.length == 1) && (entry.value.tasks == 0))
        entry.key,
  };

  for (var project in toRemove) {
    var middle = result[project]!;
    result.remove(project);

    var below = middle.children.first;
    var above = middle.parent;

    result[below]!.parent = above;

    if (above != null) {
      result[above]!.children.remove(project);
      result[above]!.children.add(below);
    }
  }
  return result;
}
