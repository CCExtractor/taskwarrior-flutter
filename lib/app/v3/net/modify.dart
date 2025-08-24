import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';
import 'package:taskwarrior/app/v3/models/task.dart';

Future<void> modifyTaskOnTaskwarrior(TaskForC tskc) async {
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
      "description": tskc.description,
      "priority": tskc.priority,
      "project": tskc.project,
      "due": tskc.due,
      "status": tskc.status,
      "taskuuid": tskc.uuid,
    }),
  );

  if (response.statusCode != 200) {
    Get.snackbar(
      'Error',
      'Failed to modify task: ${response.reasonPhrase}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  var taskDatabase = TaskDatabase();
  await taskDatabase.open();
  await taskDatabase.deleteTask(
      description: tskc.description,
      due: tskc.due,
      project: tskc.project,
      priority: tskc.priority);
}
