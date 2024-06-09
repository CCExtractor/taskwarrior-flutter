// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class Tabs {
  const Tabs(this.profile);

  final Directory profile;

  File get _initialTabIndex => File('${profile.path}/initialTabIndex');
  Directory get _tabs => Directory('${profile.path}/tabs');

  Directory tab() {
    var index = initialTabIndex();
    var tabUuid = tabUuids()[index];
    return Directory('${profile.path}/tabs/$tabUuid');
  }

  int initialTabIndex() {
    if (!_initialTabIndex.existsSync()) {
      setInitialTabIndex(0);
    }
    return json.decode(_initialTabIndex.readAsStringSync());
  }

  void setInitialTabIndex(int index) {
    _initialTabIndex.writeAsStringSync(json.encode(index));
  }

  void addTab() {
    var uuid = const Uuid().v1();
    var dir = '${_tabs.path}/$uuid';
    Directory(dir).createSync(recursive: true);
    File('$dir/created').writeAsStringSync(DateTime.now().toIso8601String());
  }

  List<String> tabUuids() {
    _tabs.createSync(recursive: true);
    if (_tabs.listSync().isEmpty) {
      addTab();
    }
    var dirs = _tabs.listSync()
      ..sort((a, b) => DateTime.parse(
            File('${a.path}/created').readAsStringSync(),
          ).compareTo(DateTime.parse(
            File('${b.path}/created').readAsStringSync(),
          )));
    return dirs.map((dir) => basename(dir.path)).toList();
  }

  void removeTab(int index) {
    var uuid = tabUuids()[index];
    Directory('${_tabs.path}/$uuid').deleteSync(recursive: true);
    setInitialTabIndex(max(0, min(initialTabIndex(), tabUuids().length - 1)));
    if (tabUuids().isEmpty) {
      addTab();
    }
  }

  void renameTab({
    required String tab,
    required String name,
  }) {
    File('${_tabs.path}/$tab/alias').writeAsStringSync(name);
  }

  String? alias(String tabUuid) {
    if (File('${_tabs.path}/$tabUuid/alias').existsSync()) {
      var result = File('${_tabs.path}/$tabUuid/alias').readAsStringSync();
      if (result.isNotEmpty) {
        return result;
      }
    }
    return null;
  }
}
