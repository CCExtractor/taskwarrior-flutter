import 'dart:io';

import 'package:taskwarrior/app/models/data.dart';
import 'package:taskwarrior/app/models/storage/tabs.dart';
import 'package:taskwarrior/app/utils/home_path/impl/gui_pem_file_paths.dart';
import 'package:taskwarrior/app/utils/home_path/impl/home.dart';
import 'package:taskwarrior/app/utils/home_path/impl/taskrc.dart';
import 'package:taskwarrior/app/utils/taskfunctions/query.dart';


class Storage {
  const Storage(this.profile);

  final Directory profile;

  Data get data => Data(profile);
  GUIPemFiles get guiPemFiles => GUIPemFiles(profile);
  Home get home => Home(
        home: profile,
        pemFilePaths: guiPemFiles.pemFilePaths,
      );
  Query get query => Query(profile);
  Tabs get tabs => Tabs(profile);
  Taskrc get taskrc => Taskrc(profile);
}
