import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';

Future<void> completeTask(String email, String taskUuid,
    {http.Client? client}) async {
  final httpClient = client ?? http.Client();
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
    final response = await httpClient.post(
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
      throw Exception('Failed to complete task: ${response.statusCode}');
    }
  } catch (e, s) {
    debugPrint('Error completing task: $e\n$s');
    rethrow;
  }
}
