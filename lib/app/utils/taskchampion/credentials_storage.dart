import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CredentialsStorage {
  static const String _encryptionSecretKey = 'taskc_client_secret';
  static const String _clientIdKey = 'taskc_client_id';
  static const String _apiUrlKey = 'backend_url_tc';
  static Future<String?> getEncryptionSecret() async {
    String? profile = await getCurrentProfile();
    Directory base = await getBaseDire();
    if (File('${base.path}/profiles/$profile/$_encryptionSecretKey')
        .existsSync()) {
      var contents =
          File('${base.path}/profiles/$profile/$_encryptionSecretKey')
              .readAsStringSync();
      return (contents.isEmpty) ? null : contents;
    } else {
      return null;
    }
  }

  static Future<String?> getClientId() async {
    String? profile = await getCurrentProfile();
    Directory base = await getBaseDire();
    if (File('${base.path}/profiles/$profile/$_clientIdKey').existsSync()) {
      var contents = File('${base.path}/profiles/$profile/$_clientIdKey')
          .readAsStringSync();
      return (contents.isEmpty) ? null : contents;
    } else {
      return null;
    }
  }

  static Future<String?> getApiUrl() async {
    String? profile = await getCurrentProfile();
    Directory base = await getBaseDire();
    if (File('${base.path}/profiles/$profile/$_apiUrlKey').existsSync()) {
      var contents =
          File('${base.path}/profiles/$profile/$_apiUrlKey').readAsStringSync();
      return (contents.isEmpty) ? null : contents;
    } else {
      return null;
    }
  }

  static Future<String?> getCurrentProfile() async {
    Directory base = await getBaseDire();
    if (File('${base.path}/current-profile').existsSync()) {
      return File('${base.path}/current-profile').readAsStringSync();
    }
    return null;
  }

  static Future<Directory> getBaseDire() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? directory = prefs.getString('baseDirectory');
    Directory dir = (directory != null)
        ? Directory(directory)
        : await getDefaultDirectory();
    return dir;
  }

  static Future<Directory> getDefaultDirectory() async {
    return await getApplicationDocumentsDirectory();
  }
}
