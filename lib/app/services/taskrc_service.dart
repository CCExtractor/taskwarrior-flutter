import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:taskwarrior/app/models/report.dart';
import 'package:taskwarrior/app/utils/taskchampion/taskrc_parser.dart';

/// Loads an optional user `.taskrc` so power users can tweak or add reports
/// (Issue #418). The file lives in the app's documents directory; if it is
/// absent or unreadable we simply fall back to the built-in default reports.
class TaskrcService {
  static Future<File> _file() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/.taskrc');
  }

  /// Absolute path where a `.taskrc` may be placed (shown in the UI so users
  /// know where to drop their config).
  static Future<String> taskrcPath() async => (await _file()).path;

  /// User-defined reports from `.taskrc`, or an empty list if none.
  static Future<List<ReportDefinition>> loadCustomReports() async {
    try {
      final File file = await _file();
      if (!await file.exists()) return <ReportDefinition>[];
      final String content = await file.readAsString();
      final TaskrcParser parser = TaskrcParser()..parse(content);
      return parser.customReports();
    } catch (_) {
      return <ReportDefinition>[];
    }
  }
}
