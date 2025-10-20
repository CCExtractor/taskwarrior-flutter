import 'dart:convert';
import 'dart:io';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/models/models.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';
import 'package:taskwarrior/app/v3/models/task.dart';
import 'package:taskwarrior/rust_bridge/api.dart';
import 'package:uuid/v4.dart';

class Replica {
  static List<String> attrs = [
    "description",
    "due",
    "start",
    "wait",
    "priority",
    "project",
    "status"
  ];
  static Future<String> addTaskToReplica(
      HashMap<String, dynamic> newTask) async {
    var taskdbDirPath = await getReplicaPath();
    HashMap<String, String> map = HashMap<String, String>();
    if (newTask.containsKey("uuid") && newTask['uuid'].isEmpty) {
      return "err";
    }
    String tags = "";
    if (newTask['tags'] != null && (newTask['tags'] as List).isNotEmpty) {
      tags = newTask['tags'].join(" ");
      map["tags"] = tags;
    }
    for (String attr in attrs) {
      if (newTask.containsKey(attr) &&
          newTask[attr] != null &&
          attrs.contains(attr)) {
        map[attr] = newTask[attr].toString();
      }
    }
    map['uuid'] = UuidV4().generate();
    try {
      await addTask(taskdbDirPath: taskdbDirPath, map: map);
      await getAllTasksFromReplica(); //to update the db
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      return "err";
    }
    return "scc";
  }

  static Future<String> modifyTaskInReplica(TaskForReplica newTask) async {
    var taskdbDirPath = await getReplicaPath();
    HashMap<String, String> map = HashMap<String, String>();
    if (newTask.uuid.isEmpty) {
      return "err";
    }
    String tags = "";
    if (newTask.tags != null) {
      tags = newTask.tags!.join(" ");
      debugPrint("Modifying Replica Task Tags: $tags");
      map["tags"] = tags;
    }
    var json = newTask.toJson();
    for (String attr in attrs) {
      if (json[attr] != null) map[attr] = json[attr].toString();
    }
    debugPrint("Modifying Replica Task JSON the map: $map");
    try {
      await updateTask(
          uuidSt: newTask.uuid, taskdbDirPath: taskdbDirPath, map: map);
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
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

  static Future<List<TaskForReplica>> getAllTasksFromReplica() async {
    var taskdbDirPath = await getReplicaPath();
    List<TaskForReplica> tasks = [];
    try {
      var res = await getAllTasksJson(taskdbDirPath: taskdbDirPath);
      var map = jsonDecode(res);
      debugPrint("Fetched from Replica: $map");
      tasks = List<TaskForReplica>.from(map
          .map((e) => TaskForReplica.fromJson(Map<String, dynamic>.from(e))));
      debugPrint("Parsed from Replica: $tasks");
    } catch (e) {
      debugPrint("Error fetching from Replica $e");
      return [];
    }
    return tasks;
  }

  static Future<void> sync() async {
    var taskdbDirPath = await getReplicaPath();
    try {
      var url = await CredentialsStorage.getApiUrl();
      var clientId = await CredentialsStorage.getClientId();
      var encryptionSecret = await CredentialsStorage.getEncryptionSecret();
      await sync_(
          taskdbDirPath: taskdbDirPath,
          url: url ?? "",
          clientId: clientId ?? "",
          encryptionSecret: encryptionSecret ?? "");
    } catch (e) {
      debugPrint("Error syncing Replica $e");
    }
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
