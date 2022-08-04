import 'dart:io';
import 'package:taskwarrior/widgets/taskserver.dart';

class GUIPemFiles {
  GUIPemFiles(this.home);

  final Directory home;

  PemFilePaths get pemFilePaths => PemFilePaths(
        ca: '${home.path}/.task/ca.cert.pem',
        certificate: '${home.path}/.task/first_last.cert.pem',
        key: '${home.path}/.task/first_last.key.pem',
        serverCert: '${home.path}/.task/server.cert.pem',
      );

  File fileByKey(String key) {
    Directory('${home.path}/.task').createSync(recursive: true);
    return File(pemFilePaths.map[key]!);
  }

  String? pemName(String key) {
    if (File('${home.path}/$key').existsSync()) {
      return File('${home.path}/$key').readAsStringSync();
    }
    return null;
  }

  void removePemFile(String pemFileKey) {
    if (fileByKey(pemFileKey).existsSync()) {
      fileByKey(pemFileKey).deleteSync();
    }
    if (File('${home.path}/$pemFileKey').existsSync()) {
      File('${home.path}/$pemFileKey').deleteSync();
    }
  }

  void removeServerCert() {
    if (pemFilePaths.serverCert != null) {
      if (File(pemFilePaths.serverCert!).existsSync()) {
        File(pemFilePaths.serverCert!).deleteSync();
      }
    }
  }

  bool serverCertExists() {
    return File(pemFilePaths.serverCert!).existsSync();
  }

  void addFileName({required String key, required String name}) {
    File('${home.path}/$key').writeAsStringSync(name);
  }

  void addFileContents({required String key, required String contents}) {
    fileByKey(key).writeAsStringSync(contents);
  }

  void addPemFile({
    required String key,
    required String contents,
    String? name,
  }) {
    addFileContents(key: key, contents: contents);
    if (name != null) {
      addFileName(key: key, name: name);
    }
  }

  String? pemContents(String key) {
    if (fileByKey(key).existsSync()) {
      return fileByKey(key).readAsStringSync();
    }
    return null;
  }

  String? pemFilename(String key) {
    return pemName(key);
  }
}
