import 'dart:io';
import 'dart:collection';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/models/models.dart';
import 'package:taskwarrior/rust_bridge/api.dart';

class Replica {
  static List<String> attrs = [
    "description",
    "due",
    "start",
    "wait",
    "priority",
    "project"
  ];
  static Future<String> addTaskToReplica(Task newTask) async {
    var taskdbDirPath = await getReplicaPath();
    HashMap<String, String> map = HashMap<String, String>();
    if (newTask.uuid.isEmpty) {
      return "err";
    }
    String tags = "";
    if (newTask.tags != null) {
      tags = newTask.tags!.join(" ");
      map["tags"] = tags;
    }
    var json = newTask.toJson();
    for (String attr in attrs) {
      if (json[attr]) map[attr] = json[attr];
    }
    try {
      await addTask(taskdbDirPath: taskdbDirPath, map: map);
    } catch (e) {
      return "err";
    }
    return "scc";
  }

  static Future<String> modifyTaskInReplica(Task newTask) async {
    var taskdbDirPath = await getReplicaPath();
    HashMap<String, String> map = HashMap<String, String>();
    if (newTask.uuid.isEmpty) {
      return "err";
    }
    String tags = "";
    if (newTask.tags != null) {
      tags = newTask.tags!.join(" ");
      map["tags"] = tags;
    }
    var json = newTask.toJson();
    for (String attr in attrs) {
      if (json[attr]) map[attr] = json[attr];
    }
    try {
      await updateTask(
          uuidSt: newTask.uuid, taskdbDirPath: taskdbDirPath, map: map);
    } catch (e) {
      return "err";
    }
    return "scc";
  }

  static Future<String> deleteTaskFromReplica(String uuid) async {
    var taskdbDirPath = await getReplicaPath();
    try {
      await deleteTask(uuidSt: uuid, taskdbDirPath: taskdbDirPath);
    } catch (e) {
      return "err";
    }
    return "scc";
  }

  static Future<String> getReplicaPath() async {
    String? profile = await getCurrentProfile();
    Directory base = await getBaseDire();
    return '${base.path}/profiles/$profile/replica';
  }

  static Future<String?> getCurrentProfile() async {
    Directory base = await getBaseDire();
    if (File('${base.path}/current-profile').existsSync()) {
      return File('${base.path}/current-profile').readAsStringSync();
    }
    return null;
  }

  static Future<Directory> getBaseDire() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? directory = prefs.getString('baseDirectory');
    Directory dir = (directory != null)
        ? Directory(directory)
        : await getDefaultDirectory();
    return dir;
  }

  static Future<Directory> getDefaultDirectory() async {
    return await getApplicationDocumentsDirectory();
  }
}
