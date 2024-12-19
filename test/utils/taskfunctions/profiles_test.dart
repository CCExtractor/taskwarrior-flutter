import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskfunctions/profiles.dart';

void main() {
  late Directory baseDir;
  late Profiles profiles;

  setUp(() {
    baseDir = Directory.systemTemp.createTempSync();
    profiles = Profiles(baseDir);
  });

  tearDown(() {
    baseDir.deleteSync(recursive: true);
  });

  test('addProfile creates a new profile with alias and creation date', () {
    var profileId = profiles.addProfile();
    var profileDir = Directory('${baseDir.path}/profiles/$profileId');
    expect(profileDir.existsSync(), isTrue);
    expect(File('${profileDir.path}/created').existsSync(), isTrue);
    expect(File('${profileDir.path}/alias').readAsStringSync(), 'New Alias');
  });

  test('copyConfigToNewProfile copies config files to new profile', () {
    var originalProfile = profiles.addProfile();
    var configFiles = [
      '.taskrc',
      '.task/ca.cert.pem',
      '.task/first_last.cert.pem',
      '.task/first_last.key.pem',
      '.task/server.cert.pem',
      'taskd.ca',
      'taskd.certificate',
      'taskd.key',
    ];

    for (var file in configFiles) {
      var filePath = '${baseDir.path}/profiles/$originalProfile/$file';
      File(filePath).createSync(recursive: true);
    }

    profiles.copyConfigToNewProfile(originalProfile);
    var newProfile = profiles.listProfiles().last;

    for (var file in configFiles) {
      var filePath = '${baseDir.path}/profiles/$newProfile/$file';
      expect(File(filePath).existsSync(), isTrue);
    }
  });

  test('listProfiles returns sorted list of profile IDs', () {
    var profile1 = profiles.addProfile();
    var profile2 = profiles.addProfile();
    expect(profiles.listProfiles(), [profile1, profile2]);
  });

  test('deleteProfile removes profile directory', () {
    var profile = profiles.addProfile();
    profiles.deleteProfile(profile);
    expect(
        Directory('${baseDir.path}/profiles/$profile').existsSync(), isFalse);
  });

  test('setAlias and getAlias set and get the alias for a profile', () {
    var profile = profiles.addProfile();
    profiles.setAlias(profile: profile, alias: 'Test Alias');
    expect(profiles.getAlias(profile), 'Test Alias');
  });

  test(
      'setCurrentProfile and getCurrentProfile set and get the current profile',
      () {
    var profile = profiles.addProfile();
    profiles.setCurrentProfile(profile);
    expect(profiles.getCurrentProfile(), profile);
  });

  test('getCurrentStorage returns storage for current profile', () {
    var profile = profiles.addProfile();
    profiles.setCurrentProfile(profile);
    expect(profiles.getCurrentStorage()?.profile.path,
        '${baseDir.path}/profiles/$profile');
  });

  test('getStorage returns storage for specified profile', () {
    var profile = profiles.addProfile();
    expect(profiles.getStorage(profile).profile.path,
        '${baseDir.path}/profiles/$profile');
  });
}
