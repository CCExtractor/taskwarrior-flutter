import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:taskwarrior/app/models/report.dart';
import 'package:taskwarrior/app/utils/taskchampion/taskrc_parser.dart';

/// Reads and writes the user `.taskrc` that holds custom reports (Issue #418).
///
/// Reports created in the app are stored in exactly the format Taskwarrior
/// itself uses — `report.<name>.filter` and friends — rather than in a private
/// store. That keeps one source of truth (a report typed by hand and one built
/// in the app are indistinguishable) and means the file can be copied to a
/// desktop Taskwarrior and still work.
class TaskrcService {
  static Future<File> _file() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/.taskrc');
  }

  /// Absolute path where the `.taskrc` lives (shown in the UI).
  static Future<String> taskrcPath() async => (await _file()).path;

  /// User-defined reports from `.taskrc`, or an empty list if none.
  static Future<List<ReportDefinition>> loadCustomReports() async {
    try {
      final File file = await _file();
      if (!await file.exists()) return <ReportDefinition>[];
      final TaskrcParser parser = TaskrcParser()..parse(await file.readAsString());
      return parser.customReports();
    } catch (_) {
      return <ReportDefinition>[];
    }
  }

  /// A report name Taskwarrior can address: `report.<name>.sort` is parsed by
  /// splitting on dots, so a name containing a dot, whitespace or `=` would
  /// produce a key that can never be read back.
  static String? validateName(String name) {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) return 'Give the report a name.';
    if (!RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(trimmed)) {
      return 'Use only letters, numbers, hyphens and underscores.';
    }
    return null;
  }

  /// Write [report] into `.taskrc`, replacing any report already stored under
  /// the same name.
  ///
  /// The file is edited line by line rather than rewritten: a user may have put
  /// their own settings, comments or reports in it, and none of that should be
  /// lost because the app saved something. Only lines whose key begins with
  /// `report.<name>.` are dropped before the new block is appended.
  static Future<void> saveReport(ReportDefinition report) async {
    final File file = await _file();
    final String existing =
        await file.exists() ? await file.readAsString() : '';
    await file.writeAsString(mergeReport(existing, report));
  }

  /// Pure form of [saveReport]: returns what the file should contain.
  ///
  /// Separated from the file so it can be tested directly — this is the part
  /// that must not lose a user's hand-written settings, and it is not worth
  /// trusting to a plugin-dependent integration test.
  static String mergeReport(String content, ReportDefinition report) {
    final String? nameError = validateName(report.name);
    if (nameError != null) throw ArgumentError(nameError);
    final String name = report.name.trim();

    final List<String> kept = _linesExcludingReport(content, name);

    // `.sort` is what marks a block as a real report — Taskwarrior's own rule,
    // and what TaskrcParser looks for — so it must always be written, even when
    // the user left the sort field empty.
    final String sort = report.sortCriteria.isEmpty
        ? 'urgency-'
        : report.sortCriteria
            .map((c) => '${c.field}${c.ascending ? '+' : '-'}')
            .join(',');
    final String columns = report.columns.isEmpty
        ? 'id,description'
        : report.columns.map((c) => c.field).join(',');

    final List<String> block = <String>[
      'report.$name.description=${report.description.trim()}',
      'report.$name.columns=$columns',
      'report.$name.sort=$sort',
      if ((report.filterExpression ?? '').trim().isNotEmpty)
        'report.$name.filter=${report.filterExpression!.trim()}',
    ];

    return <String>[
      ...kept,
      if (kept.isNotEmpty) '',
      ...block,
      '',
    ].join('\n');
  }

  /// Remove the report called [name], leaving the rest of the file untouched.
  static Future<void> deleteReport(String name) async {
    final File file = await _file();
    if (!await file.exists()) return;
    await file.writeAsString(removeReport(await file.readAsString(), name));
  }

  /// Pure form of [deleteReport].
  static String removeReport(String content, String name) =>
      _linesExcludingReport(content, name.trim()).join('\n');

  /// Every line of [file] except those defining `report.<name>.*`.
  ///
  /// Comments and blanks are preserved verbatim; only assignment lines are
  /// inspected, and only for this one report.
  static List<String> _linesExcludingReport(String content, String name) {
    final String prefix = 'report.$name.';
    final List<String> kept = <String>[];
    for (final String raw in content.split('\n')) {
      final String line = raw.trim();
      if (line.isNotEmpty && !line.startsWith('#')) {
        final int eq = line.indexOf('=');
        if (eq > 0 && line.substring(0, eq).trim().startsWith(prefix)) {
          continue; // superseded by the block we are about to write
        }
      }
      kept.add(raw);
    }
    // Trailing blanks would otherwise accumulate on every save.
    while (kept.isNotEmpty && kept.last.trim().isEmpty) {
      kept.removeLast();
    }
    return kept;
  }
}
