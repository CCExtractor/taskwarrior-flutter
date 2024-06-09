import 'dart:io';

class Taskrc {
  const Taskrc(this.home);

  final Directory home;

  File get _taskrc => File('${home.path}/.taskrc');

  void addTaskrc(String taskrc) {
    _taskrc.writeAsStringSync(taskrc);
  }

  String? readTaskrc() {
    if (_taskrc.existsSync()) {
      return _taskrc.readAsStringSync();
    }
    return null;
  }
}
