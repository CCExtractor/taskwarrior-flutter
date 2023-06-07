// ignore_for_file: deprecated_export_use

import 'dart:async';
import 'dart:io';

import 'package:taskwarrior/model/storage/taskserver_configuration_exception.dart';
import 'package:taskwarrior/widgets/taskc/impl/codec.dart';
import 'package:taskwarrior/widgets/taskc/impl/message.dart';
import 'package:taskwarrior/widgets/taskc/message.dart';
import 'package:taskwarrior/widgets/taskc/response.dart';
import 'package:taskwarrior/widgets/taskserver.dart';

enum TaskserverProgress {
  connecting,
  securing,
  sending,
  waiting,
  receiving,
}

class TaskdClient {
  TaskdClient({
    this.taskrc,
    this.client,
    this.pemFilePaths,
    this.throwOnBadCertificate,
  }) : progressController = StreamController();

  final Taskrc? taskrc;
  final String? client;
  final PemFilePaths? pemFilePaths;
  final void Function(X509Certificate)? throwOnBadCertificate;
  final StreamController<TaskserverProgress> progressController;

  Stream get progress => progressController.stream;

  PemFilePaths _pemFilePaths() {
    return pemFilePaths ??
        PemFilePaths.fromTaskrc(
          taskrc?.pemFilePaths.map ?? {},
        );
  }

  bool _onBadCertificate(X509Certificate serverCert) {
    if (_pemFilePaths().savedServerCertificateMatches(serverCert)) {
      return true;
    } else if (throwOnBadCertificate != null) {
      throwOnBadCertificate!(serverCert);
      return true;
    }
    return false;
  }

  Future<Response> request({
    required String type,
    String? payload,
  }) async {
    if (taskrc?.server == null) {
      throw TaskserverConfigurationException(
        'Server cannot be null.',
      );
    }

    progressController.add(TaskserverProgress.connecting);

    var socket = await Socket.connect(
      taskrc!.server!.address,
      taskrc!.server!.port,
    );

    progressController.add(TaskserverProgress.securing);

    var secureSocket = await SecureSocket.secure(
      socket,
      context: _pemFilePaths().securityContext(),
      onBadCertificate: _onBadCertificate,
    );

    var messageString = message(
      type: type,
      client: client,
      credentials: taskrc?.credentials,
      payload: payload,
    );

    progressController.add(TaskserverProgress.sending);

    secureSocket.add(Codec.encode(messageString));

    progressController.add(TaskserverProgress.waiting);

    var responseBytes = BytesBuilder();

    await secureSocket.listen((event) {
      if (responseBytes.isEmpty) {
        progressController.add(TaskserverProgress.receiving);
      }
      responseBytes.add(event);
    }).asFuture();

    await secureSocket.close();
    await socket.close();

    if (responseBytes.isEmpty) {
      throw EmptyResponseException();
    }

    var response = Response.fromString(Codec.decode(responseBytes.takeBytes()));

    if (![
      '200',
      '201',
      '202',
    ].contains(response.header['code'])) {
      throw TaskserverResponseException(response.header);
    }

    return response;
  }

  Future<Map> statistics() {
    return request(
      type: 'statistics',
    ).then((response) => response.header);
  }

  Future<Response> synchronize(String payload) {
    return request(
      type: 'sync',
      payload: payload,
    );
  }
}
