import 'dart:io';

import 'package:taskwarrior/model/data.dart';
import 'package:taskwarrior/model/storage/gui_pem_file_paths.dart';
import 'package:taskwarrior/model/storage/tabs.dart';
import 'package:taskwarrior/widgets/taskw.dart';

class Storage {
  const Storage(this.profile);

  final Directory profile;

  Data get data => Data(profile);
  GUIPemFiles get guiPemFiles => GUIPemFiles(profile);
//   Home get home => Home(
//         home: profile,
//         pemFilePaths: guiPemFiles.pemFilePaths,
//       );
  Query get query => Query(profile);
  Tabs get tabs => Tabs(profile);
  //Taskrc get taskrc => Taskrc(profile);
}
