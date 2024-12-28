import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/storage/tabs.dart';
import 'package:uuid/uuid.dart';

void main() {
  late Directory testProfile;
  late Tabs tabs;

  setUp(() {
    testProfile = Directory(
        '${Directory.systemTemp.path}/test_profile_${const Uuid().v1()}');
    testProfile.createSync();
    tabs = Tabs(testProfile);
  });

  tearDown(() {
    if (testProfile.existsSync()) {
      testProfile.deleteSync(recursive: true);
    }
  });
  group("Tabs test", () {
    test('Initial tab index defaults to 0', () {
      expect(tabs.initialTabIndex(), 0);
    });

    test('Can set and get initial tab index', () {
      tabs.setInitialTabIndex(2);
      expect(tabs.initialTabIndex(), 2);
    });

    test('Can add a new tab', () {
      var initialTabCount = tabs.tabUuids().length;
      tabs.addTab();
      expect(tabs.tabUuids().length, initialTabCount + 1);
    });

    test('Can remove a tab', () {
      var initialTabCount = tabs.tabUuids().length;
      tabs.addTab();
      tabs.removeTab(0);
      expect(tabs.tabUuids().length, initialTabCount);
    });

    test('Removing a tab updates the initial index', () {
      tabs.addTab();
      tabs.addTab();
      tabs.setInitialTabIndex(1);
      tabs.removeTab(1);
      expect(tabs.initialTabIndex(), 0);
    });

    test('Can rename a tab and retrieve its alias', () {
      tabs.addTab();
      var tabUuid = tabs.tabUuids().first;
      tabs.renameTab(tab: tabUuid, name: 'New Tab Name');
      expect(tabs.alias(tabUuid), 'New Tab Name');
    });

    test('Alias returns null for non-existent alias files', () {
      tabs.addTab();
      var tabUuid = tabs.tabUuids().first;
      expect(tabs.alias(tabUuid), isNull);
    });
  });
}
