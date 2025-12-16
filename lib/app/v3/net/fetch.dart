import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';
import 'package:taskwarrior/app/v3/models/task.dart';
import 'package:taskwarrior/app/v3/net/origin.dart';
import 'package:http/http.dart' as http;

Future<List<TaskForC>> fetchTasks(String uuid, String encryptionSecret) async {
  var baseUrl = await CredentialsStorage.getApiUrl();
  try {
    String url =
        '$baseUrl/tasks?email=email&origin=$origin&UUID=$uuid&encryptionSecret=$encryptionSecret';

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
    }).timeout(const Duration(milliseconds: 10000));
    debugPrint("Fetch tasks response: ${response.statusCode}");
    debugPrint("Fetch tasks body: ${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> allTasks = jsonDecode(response.body);
      debugPrint(allTasks.toString());
      return allTasks.map((task) => TaskForC.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  } catch (e, s) {
    debugPrint('Error fetching tasks: $e\n $s');

    return [];
  }
}
