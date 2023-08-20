// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:file_selector/file_selector.dart';

Future<void> saveServerCert(String contents) async {
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    var path = await getSavePath(
      suggestedName: 'server.cert.pem',
    );
    var data = Uint8List.fromList(contents.codeUnits);
    var file = XFile.fromData(
      data,
    );
    await file.saveTo(path!);
  } else {
    await FilePickerWritable().openFileForCreate(
      fileName: 'server.cert.pem',
      writer: (tempFile) => tempFile.writeAsString(contents),
    );
  }
}

Future<void> exportTasks({
  required String contents,
  required String suggestedName,
}) async {
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    var path = await getSavePath(
      suggestedName: suggestedName,
    );
    var data = Uint8List.fromList(contents.codeUnits);
    var file = XFile.fromData(
      data,
    );
    await file.saveTo(path!);
  } else {
    await FilePickerWritable().openFileForCreate(
      fileName: suggestedName,
      writer: (tempFile) => tempFile.writeAsString(contents),
    );
  }
}
