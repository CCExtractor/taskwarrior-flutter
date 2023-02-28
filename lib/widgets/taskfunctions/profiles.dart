// ignore_for_file: prefer_expression_function_bodies

import 'dart:collection';
import 'dart:io';

import 'package:uuid/uuid.dart';

import 'package:taskwarrior/model/storage.dart';

class Profiles {
  Profiles(this.base);

  final Directory base;

  String addProfile() {
    var uuid = const Uuid().v1();

    Directory('${base.path}/profiles/$uuid').createSync(recursive: true);
    File('${base.path}/profiles/$uuid/created')
        .writeAsStringSync('${DateTime.now().toUtc()}');
    File('${base.path}/profiles/$uuid/alias').createSync();

    const alias = 'New Profile';
    setAlias(profile: uuid, alias: alias);
    return uuid;
  }

  void copyConfigToNewProfile(String profile) {
    var newProfile = addProfile();
    Directory('${base.path}/profiles/$newProfile/.task')
        .createSync(recursive: true);
    for (var file in [
      '.taskrc',
      '.task/ca.cert.pem',
      '.task/first_last.cert.pem',
      '.task/first_last.key.pem',
      '.task/server.cert.pem',
      'taskd.ca',
      'taskd.certificate',
      'taskd.key',
    ]) {
      if (File('${base.path}/profiles/$profile/$file').existsSync()) {
        File('${base.path}/profiles/$profile/$file').copySync(
          '${base.path}/profiles/$newProfile/$file',
        );
      }
    }
  }

  List<String> listProfiles() {
    var dir = Directory('${base.path}/profiles')..createSync();
    var dirs = dir
        .listSync()
        .map((entity) =>
            entity.uri.pathSegments.lastWhere((segment) => segment.isNotEmpty))
        .toList()
      ..sort(comparator);
    return dirs;
  }

  int comparator(String a, String b) {
    if (a.isEmpty || b.isEmpty) {
      return 0;
    }
    DateTime created(String profile) {
      if (!File('${base.path}/profiles/$profile/created').existsSync()) {
        File('${base.path}/profiles/$profile/created')
            .writeAsStringSync('${DateTime.now().toUtc()}');
      }
      return DateTime.parse(
          File('${base.path}/profiles/$profile/created').readAsStringSync());
    }

    var aCreated = created(a);
    var bCreated = created(b);
    if (aCreated.isBefore(bCreated)) {
      return -1;
    } else if (aCreated.isAfter(bCreated)) {
      return 1;
    } else {
      return 0;
    }
  }

  Map<String, String?> profilesMap() {
    return SplayTreeMap.of({
      for (var profile in listProfiles()) profile: getAlias(profile),
    }, comparator);
  }

  void deleteProfile(String profile) {
    Directory('${base.path}/profiles/$profile').deleteSync(recursive: true);
    if (File('${base.path}/current-profile').existsSync()) {
      if (profile == File('${base.path}/current-profile').readAsStringSync()) {
        File('${base.path}/current-profile').deleteSync();
      }
    }
  }

  void setAlias({required String profile, required String alias}) {
    File('${base.path}/profiles/$profile/alias').writeAsStringSync(alias);
  }

  String? getAlias(String profile) {
    String? result;
    if (File('${base.path}/profiles/$profile/alias').existsSync()) {
      var contents =
          File('${base.path}/profiles/$profile/alias').readAsStringSync();
      result = (contents.isEmpty) ? null : contents;
    }
    return result;
  }

  void setCurrentProfile(String? profile) {
    File('${base.path}/current-profile').writeAsStringSync(profile ?? '');
  }

  String? getCurrentProfile() {
    if (File('${base.path}/current-profile').existsSync()) {
      return File('${base.path}/current-profile').readAsStringSync();
    }
    return null;
  }

  Storage? getCurrentStorage() {
    var currentProfile = getCurrentProfile();
    if (currentProfile != null) {
      return getStorage(currentProfile);
    }
    return null;
  }

  Storage getStorage(String profile) {
    return Storage(Directory('${base.path}/profiles/$profile'));
  }
}
