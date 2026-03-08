// ignore_for_file: prefer_expression_function_bodies

import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:taskwarrior/app/models/json/task.dart';
import 'package:taskwarrior/app/services/notification_services.dart';
import 'package:taskwarrior/app/utils/taskc/payload.dart';
import 'package:taskwarrior/app/utils/taskfunctions/urgency.dart';
class Data {
  Data(this.home);

  final Directory home;

  void updateWaitOrUntil(Iterable<Task> pendingData) {
    var now = DateTime.now().toUtc();
    for (var task in pendingData) {
      if (task.until != null && task.until!.isBefore(now)) {
        mergeTask(
          task.rebuild(
            (b) => b
              ..status = 'deleted'
              ..end = now,
          ),
        );
      } else if (task.status == 'waiting' &&
          (task.wait == null || task.wait!.isBefore(now))) {
        _mergeTasks(
          [
            task.rebuild(
              (b) => b
                ..status = 'pending'
                ..wait = null,
            ),
          ],
        );
      }
    }
  }

  List<Task> pendingData() {
    var data = _allData().where(
        (task) => task.status != 'completed' && task.status != 'deleted');
    var now = DateTime.now();
    if (data.any((task) =>
        (task.until != null && task.until!.isBefore(now)) ||
        (task.status == 'waiting' &&
            (task.wait == null || task.wait!.isBefore(now))))) {
      updateWaitOrUntil(data);
      data = _allData().where(
          (task) => task.status != 'completed' && task.status != 'deleted');
    }
    return data
        .toList()
        .asMap()
        .entries
        .map((entry) => entry.value.rebuild((b) => b..id = entry.key + 1))
        .toList();
  }

  List<Task> _completedData() {
    var data = _allData().where(
        (task) => task.status == 'completed');
    return [
      for (var task in data) task.rebuild((b) => b..id = 0),
    ];
  }

  List<Task> completedData() {
    var data = _allData().where(
        (task) => task.status == 'completed');
    return data
        .toList()
        .asMap()
        .entries
        .map((entry) => entry.value.rebuild((b) => b..id = entry.key + 1))
        .toList();
  }

  List<Task> waitingData() {
    var data = _allData().where((task) => task.status == 'waiting');
    return [
      for (var task in data) task.rebuild((b) => b..id = 0),
    ];
  }

  List<Task> deletedData() {
  var data = _allData().where(
      (task) => task.status == 'deleted');
  return data
      .toList()
      .asMap()
      .entries
      .map((entry) => entry.value.rebuild((b) => b..id = entry.key + 1))
      .toList();
  }

  List<Task> allData() {
    var data = pendingData()..addAll(_completedData())..addAll(deletedData());
    return data;
  }

  List<Task> _allData() => [
        if (File('${home.path}/.task/all.data').existsSync())
          for (var line in File('${home.path}/.task/all.data')
              .readAsStringSync()
              .trim()
              .split('\n'))
            if (line.isNotEmpty) Task.fromJson(json.decode(line)),
      ];

  String export() {
    var string = allData()
        .map((task) {
          var jsonTask = task.toJson();

          jsonTask['urgency'] = num.parse(urgency(task)
              .toStringAsFixed(1)
              .replaceFirst(RegExp(r'.0$'), ''));

          var keyOrder = [
            'id',
            'annotations',
            'depends',
            'description',
            'due',
            'end',
            'entry',
            'imask',
            'mask',
            'modified',
            'parent',
            'priority',
            'project',
            'recur',
            'scheduled',
            'start',
            'status',
            'tags',
            'until',
            'uuid',
            'wait',
            'urgency',
          ].asMap().map((key, value) => MapEntry(value, key));

          var fallbackOrder = jsonTask.keys
              .toList()
              .asMap()
              .map((key, value) => MapEntry(value, key));

          for (var entry in fallbackOrder.entries) {
            keyOrder.putIfAbsent(
              entry.key,
              () => entry.value + keyOrder.length,
            );
          }

          return json.encode(SplayTreeMap.of(jsonTask, (key1, key2) {
            return keyOrder[key1]!.compareTo(keyOrder[key2]!);
          }));
        })
        .toList()
        .join(',\n');
    return '[\n$string\n]\n';
  }

  void mergeTask(Task task) {
    NotificationService notificationService = NotificationService();
    notificationService.initiliazeNotification();

    if (task.status == 'pending' && task.due != null) {
      int notificationid = notificationService.calculateNotificationId(
          task.due!, task.description, false, task.entry);
      notificationService.cancelNotification(notificationid);
      notificationService.sendNotification(
          task.due!, task.description, false, task.entry);
      if (task.wait != null) {
        int waitNotificationId = notificationService.calculateNotificationId(
            task.wait!, task.description, true, task.entry);
        notificationService.cancelNotification(waitNotificationId);
        notificationService.sendNotification(
            task.wait!, task.description, true, task.entry);
      }
    } else if (task.due != null) {
      int notificationid = notificationService.calculateNotificationId(
          task.due!, task.description, false, task.entry);

      notificationService.cancelNotification(notificationid);
    }
    _mergeTasks([task]);
    File('${home.path}/.task/backlog.data').writeAsStringSync(
      '${json.encode(task.rebuild((b) => b..id = null).toJson())}\n',
      mode: FileMode.append,
    );
  }

  Task getTask(String uuid) {
    return allData().firstWhere((task) => task.uuid == uuid);
  }

  void _mergeTasks(List<Task> tasks) {
    File('${home.path}/.task/all.data').createSync(recursive: true);
    var lines = File('${home.path}/.task/all.data')
        .readAsStringSync()
        .trim()
        .split('\n');
    var taskMap = {
      for (var taskLine in lines)
        if (taskLine.isNotEmpty)
          (json.decode(taskLine) as Map)['uuid']: taskLine,
    };
    for (var task in tasks) {
      taskMap[task.uuid] =
          json.encode(task.rebuild((b) => b..id = null).toJson());
    }
    File('${home.path}/.task/all.data').writeAsStringSync('');
    for (var task in taskMap.values) {
      File('${home.path}/.task/all.data').writeAsStringSync(
        '$task\n',
        mode: FileMode.append,
      );
    }
  }

  String payload() {
    var payload = '';
    if (File('${home.path}/.task/backlog.data').existsSync()) {
      payload = File('${home.path}/.task/backlog.data').readAsStringSync();
    }
    return payload;
  }

  void mergeSynchronizeResponse(Payload payload) {
    var tasks = [
      for (var task in payload.tasks)
        Task.fromJson(
            (json.decode(task) as Map<String, dynamic>)..remove('id')),
    ];
    _mergeTasks(tasks);
    File('${home.path}/.task/backlog.data')
        .writeAsStringSync('${payload.userKey}\n');
  }
}
