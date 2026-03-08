import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';
import 'package:taskwarrior/app/v3/models/task.dart';

/// Push a newly-spawned recurring task to the Taskchampion server.
/// Unlike [addTaskAndDeleteFromDatabase], this does NOT delete the local
/// record because the task was created with a proper UUID and is already
/// visible to the user.
Future<void> pushNewTaskToServer(TaskForC task) async {
  try {
    var baseUrl = await CredentialsStorage.getApiUrl();
    String apiUrl = '$baseUrl/add-task';
    var c = await CredentialsStorage.getClientId();
    var e = await CredentialsStorage.getEncryptionSecret();
    final bodyMap = <String, dynamic>{
      'email': 'email',
      'encryptionSecret': e,
      'UUID': c,
      'description': task.description,
      'project': task.project ?? '',
      'due': task.due ?? '',
      'priority': task.priority ?? '',
      'tags': task.tags ?? [],
    };
    if (task.recur != null && task.recur!.isNotEmpty)
      bodyMap['recur'] = task.recur;
    if (task.rtype != null && task.rtype!.isNotEmpty)
      bodyMap['rtype'] = task.rtype;
    await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'text/plain'},
      body: jsonEncode(bodyMap),
    );
    debugPrint('Pushed recurring child task to server: ${task.description}');
  } catch (e) {
    debugPrint('Failed to push recurring child task to server: $e');
  }
}

Future<void> addTaskAndDeleteFromDatabase(
  String description,
  String project,
  String due,
  String priority,
  List<dynamic> tags, {
  String? recur,
  String? rtype,
}) async {
  var baseUrl = await CredentialsStorage.getApiUrl();
  String apiUrl = '$baseUrl/add-task';
  var c = await CredentialsStorage.getClientId();
  var e = await CredentialsStorage.getEncryptionSecret();
  debugPrint("Database Adding Tags $tags $description");
  debugPrint(c);
  debugPrint(e);
  final bodyMap = <String, dynamic>{
    'email': 'email',
    'encryptionSecret': e,
    'UUID': c,
    'description': description,
    'project': project,
    'due': due,
    'priority': priority,
    'tags': tags,
  };
  if (recur != null && recur.isNotEmpty) bodyMap['recur'] = recur;
  if (rtype != null && rtype.isNotEmpty) bodyMap['rtype'] = rtype;
  var res = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'text/plain',
    },
    body: jsonEncode(bodyMap),
  );
  debugPrint('Database res  ${res.body}');
  var taskDatabase = TaskDatabase();
  await taskDatabase.open();
  await taskDatabase.deleteTask(
      description: description, due: due, project: project, priority: priority);
}
