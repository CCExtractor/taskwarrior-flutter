import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';

Future<void> modifyTaskOnTaskwarrior(
    String description,
    String project,
    String due,
    String priority,
    String status,
    String taskuuid,
    String id,
    List<String> newTags) async {
  var baseUrl = await CredentialsStorage.getApiUrl();
  var c = await CredentialsStorage.getClientId();
  var e = await CredentialsStorage.getEncryptionSecret();
  String apiUrl = '$baseUrl/edit-task';
  debugPrint(c);
  debugPrint(e);
  debugPrint("modifyTaskOnTaskwarrior called");
  debugPrint("description: $description project: $project due: $due "
      "priority: $priority status: $status taskuuid: $taskuuid id: $id tags: $newTags"
      "body: ${jsonEncode({
        "email": "e",
        "encryptionSecret": e,
        "UUID": c,
        "description": description,
        "priority": priority,
        "project": project,
        "due": due,
        "status": status,
        "taskuuid": taskuuid,
        "taskId": id,
        "tags": newTags.isNotEmpty ? newTags : null
      })}");
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'text/plain',
    },
    body: jsonEncode({
      "email": "e",
      "encryptionSecret": e,
      "UUID": c,
      "description": description,
      "priority": priority,
      "project": project,
      "due": due,
      "status": status,
      "taskuuid": taskuuid,
      "taskId": id,
      "tags": newTags.isNotEmpty ? newTags : null
    }),
  );
  debugPrint('Modify task response body: ${response.body}');
  if (response.statusCode < 200 || response.statusCode >= 300) {
    Get.showSnackbar(GetSnackBar(
      title: 'Error',
      message:
          'Failed to modify task on Taskwarrior server. ${response.statusCode}',
      duration: Duration(seconds: 3),
    ));
  }

  var taskDatabase = TaskDatabase();
  await taskDatabase.open();
  await taskDatabase.deleteTask(
      description: description, due: due, project: project, priority: priority);
}
