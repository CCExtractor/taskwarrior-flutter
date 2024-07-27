import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskfunctions/projects.dart';

void main() {
  test('sparseDecoratedProjectTree test', () {
    var projects1 = {
      'projectA': 5,
      'projectA.subprojectB': 3,
      'projectA.subprojectC': 2,
      'projectA.subprojectC.subsubprojectD': 1,
    };
    var result1 = sparseDecoratedProjectTree(projects1);
    expect(result1.keys.toSet(), {
      'projectA',
      'projectA.subprojectB',
      'projectA.subprojectC',
      'projectA.subprojectC.subsubprojectD',
    });
    expect(result1['projectA']!.children, {
      'projectA.subprojectB',
      'projectA.subprojectC',
    });
    expect(result1['projectA.subprojectC']!.children, {
      'projectA.subprojectC.subsubprojectD',
    });

    var projects2 = {
      'projectX': 10,
      'projectX.subprojectY': 5,
      'projectX.subprojectZ': 3,
      'projectX.subprojectZ.subsubprojectA': 2,
      'projectX.subprojectZ.subsubprojectB': 1,
      'projectX.subprojectZ.subsubprojectC': 4,
    };
    var result2 = sparseDecoratedProjectTree(projects2);
    expect(result2.keys.toSet(), {
      'projectX',
      'projectX.subprojectY',
      'projectX.subprojectZ',
      'projectX.subprojectZ.subsubprojectA',
      'projectX.subprojectZ.subsubprojectB',
      'projectX.subprojectZ.subsubprojectC',
    });
    expect(result2['projectX.subprojectZ.subsubprojectA']!.parent, 'projectX.subprojectZ');
    expect(result2['projectX.subprojectZ.subsubprojectC']!.parent, 'projectX.subprojectZ');

    var projects3 = {
      'rootProject': 0,
    };
    var result3 = sparseDecoratedProjectTree(projects3);
    expect(result3.keys, ['rootProject']);
    expect(result3['rootProject']!.children.isEmpty, true);
    expect(result3['rootProject']!.parent, null);

    var projects4 = {
      'projectP': 2,
      'projectP.subprojectQ': 3,
      'projectP.subprojectQ.subsubprojectR': 1,
    };
    var result4 = sparseDecoratedProjectTree(projects4);
    expect(result4.keys.toSet(), {
      'projectP',
      'projectP.subprojectQ',
      'projectP.subprojectQ.subsubprojectR',
    });
    expect(result4['projectP.subprojectQ.subsubprojectR']!.parent, 'projectP.subprojectQ');


  });
}
