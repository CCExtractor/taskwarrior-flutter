import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/data.dart';
import 'package:taskwarrior/app/models/storage.dart';
import 'package:taskwarrior/app/models/storage/tabs.dart';
import 'package:taskwarrior/app/utils/home_path/impl/gui_pem_file_paths.dart';
import 'package:taskwarrior/app/utils/home_path/impl/home.dart';
import 'package:taskwarrior/app/utils/home_path/impl/taskrc.dart';
import 'package:taskwarrior/app/utils/taskfunctions/query.dart';

void main() {
  group('Storage', () {
    late Directory profile;
    late Storage storage;

    setUp(() {
      profile = Directory.systemTemp.createTempSync();
      storage = Storage(profile);
    });

    tearDown(() {
      profile.deleteSync(recursive: true);
    });

    test('should correctly initialize with given directory', () {
      expect(storage.profile, profile);
    });

    test('should correctly initialize Data with profile directory', () {
      expect(storage.data, isA<Data>());
      expect(storage.profile, profile);
    });

    test('should correctly initialize GUIPemFiles with profile directory', () {
      expect(storage.guiPemFiles, isA<GUIPemFiles>());
      expect(storage.profile, profile);
    });

    test('should correctly initialize Home with profile directory', () {
      expect(storage.home, isA<Home>());
      expect(storage.home.home, profile);
      expect(
          storage.home.pemFilePaths?.key, storage.guiPemFiles.pemFilePaths.key);
    });

    test('should correctly initialize Query with profile directory', () {
      expect(storage.query, isA<Query>());
      expect(storage.profile, profile);
    });

    test('should correctly initialize Tabs with profile directory', () {
      expect(storage.tabs, isA<Tabs>());
      expect(storage.tabs.profile, profile);
    });

    test('should correctly initialize Taskrc with profile directory', () {
      expect(storage.taskrc, isA<Taskrc>());
      expect(storage.profile, profile);
    });
  });
}
