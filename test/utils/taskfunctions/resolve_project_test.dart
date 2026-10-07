import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskfunctions/add_task_dialog_utils.dart';
import 'package:taskwarrior/app/utils/taskfunctions/taskparser.dart';

void main() {
  test('an empty Project field leaves the project unset', () {
    expect(resolveProject('', null), isNull);
    expect(resolveProject('   ', null), isNull);
  });

  test('the Project field is used when filled in', () {
    expect(resolveProject('home', null), 'home');
    expect(resolveProject(' home ', 'work'), 'home');
  });

  test('an empty field keeps a project typed in the description', () {
    final parsed = taskParser('buy milk project:home');
    expect(resolveProject('', parsed.project), 'home');
  });
}
