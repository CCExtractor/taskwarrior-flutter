import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';

Future<void> modifyTaskOnTaskwarrior(String description, String project,
    String due, String priority, String status, String taskuuid) async {
  var baseUrl = await CredentialsStorage.getApiUrl();
  var c = await CredentialsStorage.getClientId();
  var e = await CredentialsStorage.getEncryptionSecret();
  String apiUrl = '$baseUrl/modify-task';
  debugPrint(c);
  debugPrint(e);
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
    }),
  );

  if (response.statusCode != 200) {
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(const SnackBar(
        content: Text(
      "Failed to update task!",
      style: TextStyle(color: Colors.red),
    )));
  }

  var taskDatabase = TaskDatabase();
  await taskDatabase.open();
  await taskDatabase.deleteTask(
      description: description, due: due, project: project, priority: priority);
}
