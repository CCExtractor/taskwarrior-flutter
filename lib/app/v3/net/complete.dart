import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';
import 'package:path/path.dart';

Future<void> completeTask(String email, String taskUuid) async {
  var c = await CredentialsStorage.getClientId();
  var e = await CredentialsStorage.getEncryptionSecret();
  var baseUrl = await CredentialsStorage.getApiUrl();
  final url = Uri.parse('$baseUrl/complete-task');
  final body = jsonEncode({
    'email': email,
    'encryptionSecret': e,
    'UUID': c,
    'taskuuid': taskUuid,
  });

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      debugPrint('Task completed successfully on server');
    } else {
      debugPrint('Failed to complete task: ${response.statusCode}');
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(const SnackBar(
          content: Text(
        "Failed to complete task!",
        style: TextStyle(color: Colors.red),
      )));
    }
  } catch (e) {
    debugPrint('Error completing task: $e');
  }
}
