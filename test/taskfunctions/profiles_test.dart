import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskfunctions/profiles.dart';

void main() {
  late Directory testDirectory;
  late Profiles profiles;

  setUp(() async {
    testDirectory = await Directory.systemTemp.createTemp('test_directory');
    profiles = Profiles(testDirectory);
  });

  tearDown(() {
    testDirectory.deleteSync(recursive: true);
  });

  test('Add and list profiles', () {
    var profileId = profiles.addProfile();

    expect(profiles.listProfiles(), contains(profileId));
  });

  test('Set and get alias', () {
    var profileId = profiles.addProfile();

    profiles.setAlias(profile: profileId, alias: 'Test Alias');

    var alias = profiles.getAlias(profileId);
    expect(alias, 'Test Alias');
  });

  test('Set and get current profile', () {
    var profileId = profiles.addProfile();

    profiles.setCurrentProfile(profileId);

    var currentProfile = profiles.getCurrentProfile();
    expect(currentProfile, profileId);
  });

  test('Delete profile', () {
    var profileId = profiles.addProfile();

    profiles.deleteProfile(profileId);

    expect(profiles.listProfiles(), isNot(contains(profileId)));
  });

  test('Copy configuration to new profile', () {
    var profileId = profiles.addProfile();

    profiles.copyConfigToNewProfile(profileId);

    expect(Directory('${testDirectory.path}/profiles').listSync(),
        hasLength(greaterThan(1)));
  });

  test('Get current storage', () {
    var profileId = profiles.addProfile();
    profiles.setCurrentProfile(profileId);

    var storage = profiles.getCurrentStorage();

    expect(storage, isNotNull);
  });
}
