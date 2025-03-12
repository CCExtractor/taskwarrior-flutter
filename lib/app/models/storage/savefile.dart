import 'dart:io';
import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:file_picker_writable/file_picker_writable.dart';

Future<void> saveServerCert(String contents) async {
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    var saveLocation = await getSaveLocation(
      suggestedName: 'server.cert.pem',
    );

    if (saveLocation != null) {
      var data = Uint8List.fromList(contents.codeUnits);
      var file = XFile.fromData(data);
      await file.saveTo(saveLocation.path);
    }
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
    var saveLocation = await getSaveLocation(
      suggestedName: suggestedName,
    );

    if (saveLocation != null) {
      var data = Uint8List.fromList(contents.codeUnits);
      var file = XFile.fromData(data);
      await file.saveTo(saveLocation.path);
    }
  } else {
    await FilePickerWritable().openFileForCreate(
      fileName: suggestedName,
      writer: (tempFile) => tempFile.writeAsString(contents),
    );
  }
}
