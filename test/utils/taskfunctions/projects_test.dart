import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskfunctions/projects.dart';

void main() {
  group('Project Utils', () {
    test('projectPath returns correct path', () {
      var project = 'a.b.c';
      var expectedPath = ['a.b.c', 'a.b', 'a'];
      expect(projectPath(project), expectedPath);
    });

    test('ancestor returns correct ancestor', () {
      expect(ancestor('a.b.c', 0), 'a.b.c');
      expect(ancestor('a.b.c', 1), 'a.b');
      expect(ancestor('a.b.c', 2), 'a');
      expect(ancestor('a.b.c', 3), null);
    });

    test('ProjectNode toMap returns correct map', () {
      var node = ProjectNode(5)
        ..parent = 'parent'
        ..children = {'child1', 'child2'}
        ..subtasks = 10;
      var expectedMap = {
        'parent': 'parent',
        'children': ['child1', 'child2'],
        'tasks': 5,
        'subtasks': 10,
      };
      expect(node.toMap(), expectedMap);
    });

    test('sparseDecoratedProjectTree returns correct tree', () {
      var projects = {'a.b.c': 5, 'a.b.d': 3, 'a.e': 2};
      var tree = sparseDecoratedProjectTree(projects);

      expect(tree['a']!.tasks, 0);
      expect(tree['a']!.subtasks, 10);
      expect(tree['a']!.children, {'a.b', 'a.e'});

      expect(tree['a.b']!.tasks, 0);
      expect(tree['a.b']!.subtasks, 8);
      expect(tree['a.b']!.children, {'a.b.c', 'a.b.d'});
      expect(tree['a.b']!.parent, 'a');

      expect(tree['a.b.c']!.tasks, 5);
      expect(tree['a.b.c']!.subtasks, 5);
      expect(tree['a.b.c']!.children, []);
      expect(tree['a.b.c']!.parent, 'a.b');

      expect(tree['a.b.d']!.tasks, 3);
      expect(tree['a.b.d']!.subtasks, 3);
      expect(tree['a.b.d']!.children, []);
      expect(tree['a.b.d']!.parent, 'a.b');

      expect(tree['a.e']!.tasks, 2);
      expect(tree['a.e']!.subtasks, 2);
      expect(tree['a.e']!.children, []);
      expect(tree['a.e']!.parent, 'a');
    });
  });
}
