// ignore_for_file: deprecated_member_use, file_names, prefer_typing_uninitialized_variables, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

Future<PushNotificationResponse> createPushNotification(
    String id, String token) async {
  String uuid = UniqueKey().toString();

  var serverUrl; //later remove
  final response = await http.post(
    Uri.parse(serverUrl! + 'push-notification'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'uuid': uuid,
      'token': token,
      'platform': 'android',
    }),
  );

  if (response.statusCode == 200) {
    debugPrint(response.body);
    return PushNotificationResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    throw ('Unable to push notification');
  } else {
    throw Exception('Network Error');
  }
}

class PushNotificationResponse {
  final String title;
  final String description;
  final DateTime expiredAt;

  PushNotificationResponse(
      {required this.title,
      required this.description,
      required this.expiredAt});

  factory PushNotificationResponse.fromJson(Map<String, dynamic> json) {
    return PushNotificationResponse(
      title: json['title'],
      description: json['description'],
      expiredAt: json['expiredAt'],
    );
  }
}
