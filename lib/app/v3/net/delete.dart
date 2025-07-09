import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';

Future<void> deleteTask(String email, String taskUuid) async {
  var baseUrl = await CredentialsStorage.getApiUrl();
  var c = await CredentialsStorage.getClientId();
  var e = await CredentialsStorage.getEncryptionSecret();
  final url = Uri.parse('$baseUrl/delete-task');
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
      debugPrint('Task deleted successfully on server');
    } else {
      debugPrint('Failed to delete task: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error deleting task: $e');
  }
}
