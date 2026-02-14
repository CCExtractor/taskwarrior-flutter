import 'dart:convert';
import 'dart:io';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/services/notification_services.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';
import 'package:taskwarrior/app/utils/taskfunctions/recurrence_engine.dart';
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
    "entry",
    "status",
    "recur",
    "mask",
    "imask",
    "parent",
    "rtype"
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
      _scheduleNotificationsForMap(map);
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

    // Handle Recurrence on Completion
    if (newTask.status == 'completed' &&
        newTask.recur != null &&
        newTask.recur!.isNotEmpty) {
      try {
        DateTime? due =
            newTask.due != null ? DateTime.tryParse(newTask.due!) : null;
        DateTime? wait =
            newTask.wait != null ? DateTime.tryParse(newTask.wait!) : null;

        due ??= DateTime.now();

        DateTime? nextDue =
            RecurrenceEngine.calculateNextDate(due, newTask.recur!);
        DateTime? nextWait = wait != null
            ? RecurrenceEngine.calculateNextDate(wait, newTask.recur!)
            : null;

        if (nextDue != null) {
          var newMap = HashMap<String, dynamic>();
          newMap['description'] = newTask.description;
          newMap['project'] = newTask.project;
          newMap['priority'] = newTask.priority;
          newMap['tags'] = newTask.tags;
          newMap['recur'] = newTask.recur;
          newMap['rtype'] = newTask.rtype;
          newMap['mask'] = newTask.mask;
          newMap['imask'] = newTask.imask;
          newMap['parent'] = newTask.uuid;
          newMap['entry'] = DateTime.now().toUtc().toIso8601String();
          newMap['status'] = 'pending';
          newMap['due'] = nextDue.toUtc().toIso8601String();
          if (nextWait != null) {
            newMap['wait'] = nextWait.toUtc().toIso8601String();
          }

          debugPrint("Creating next recurring replica task: $newMap");
          await addTaskToReplica(newMap);
        }
      } catch (e) {
        debugPrint("Error creating recurring replica task: $e");
      }
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
      final status = (newTask.status ?? '').toLowerCase();
      if (status == 'completed' || status == 'deleted') {
        cancelNotificationsForTask(newTask);
      }
      await updateTask(
          uuidSt: newTask.uuid, taskdbDirPath: taskdbDirPath, map: map);
      if (status == 'pending' || status.isEmpty) {
        _scheduleNotificationsForMap(map);
      }
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
      debugPrint(
          "Syncing Replica with url=$url clientId=$clientId encryptionSecret=$encryptionSecret");
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

  static DateTime? _parseUtc(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(value).toUtc();
    } catch (_) {
      return null;
    }
  }

  static DateTime _entryFromMap(HashMap<String, String> map) {
    return _parseUtc(map['entry']) ?? DateTime.now().toUtc();
  }

  static void _scheduleNotificationsForMap(HashMap<String, String> map) {
    try {
      final status = (map['status'] ?? 'pending').toLowerCase();
      if (status != 'pending') return;
      final description = map['description'] ?? 'Task';
      final entryTime = _entryFromMap(map);
      final due = _parseUtc(map['due']);
      final wait = _parseUtc(map['wait']);
      final now = DateTime.now().toUtc();
      final notificationService = NotificationService();
      notificationService.initiliazeNotification();

      if (due != null && due.isAfter(now)) {
        notificationService.sendNotification(
            due, description, false, entryTime);
      }
      if (wait != null && wait.isAfter(now)) {
        notificationService.sendNotification(
            wait, description, true, entryTime);
      }
    } catch (e) {
      debugPrint("Skipping replica notification scheduling: $e");
    }
  }

  static void cancelNotificationsForTask(TaskForReplica task) {
    try {
      final entryTime = _parseUtc(task.entry) ?? DateTime.now().toUtc();
      final due = _parseUtc(task.due);
      final wait = _parseUtc(task.wait);
      final description = task.description ?? 'Task';
      final notificationService = NotificationService();
      notificationService.initiliazeNotification();
      if (due != null) {
        final id = notificationService.calculateNotificationId(
            due, description, false, entryTime);
        notificationService.cancelNotification(id);
      }
      if (wait != null) {
        final id = notificationService.calculateNotificationId(
            wait, description, true, entryTime);
        notificationService.cancelNotification(id);
      }
    } catch (e) {
      debugPrint("Skipping replica notification cancel: $e");
    }
  }
}
