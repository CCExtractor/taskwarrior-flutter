import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TaskUpdate {
  final String status;
  final String job;
  const TaskUpdate(this.status, this.job);
  TaskUpdate.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        job = json['job'];
  Map<String, dynamic> toJson() => {
        'status': status,
        'job': job,
      };
}

Future<WebSocketChannel> listenForTaskUpdates(url, onSuccess, onFailure) async {
  final webSocketChannel = WebSocketChannel.connect(
    Uri.parse(url),
  );
  await webSocketChannel.ready;
  webSocketChannel.stream.listen((message) {
    debugPrint(message);
    TaskUpdate update =
        TaskUpdate.fromJson(jsonDecode(message) as Map<String, dynamic>);
    if (update.status == 'success') {
      onSuccess(update);
    }
    if (update.status == 'failure') {
      onFailure(update);
    }
  });
  return webSocketChannel;
}

String getWsUrl(url, clientId) {
  return url.replaceFirst('http', 'ws') + '/ws?clientID=' + clientId;
}
