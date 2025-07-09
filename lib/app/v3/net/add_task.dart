import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';

Future<void> addTaskAndDeleteFromDatabase(String description, String project,
    String due, String priority, List<dynamic> tags) async {
  var baseUrl = await CredentialsStorage.getApiUrl();
  String apiUrl = '$baseUrl/add-task';
  var c = await CredentialsStorage.getClientId();
  var e = await CredentialsStorage.getEncryptionSecret();
  debugPrint("Database Adding Tags $tags $description");
  debugPrint(c);
  debugPrint(e);
  var res = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'text/plain',
    },
    body: jsonEncode({
      'email': 'email',
      'encryptionSecret': e,
      'UUID': c,
      'description': description,
      'project': project,
      'due': due,
      'priority': priority,
      'tags': tags
    }),
  );
  debugPrint('Database res  ${res.body}');
  var taskDatabase = TaskDatabase();
  await taskDatabase.open();
  await taskDatabase.deleteTask(
      description: description, due: due, project: project, priority: priority);
}
