import 'package:taskwarrior/app/models/report.dart';

/// Parses a Taskwarrior `.taskrc` file and extracts user-defined report
/// definitions (Issue #418). Only lines of the form `key=value` are read;
/// comments (`#…`) and blanks are ignored. A report is recognised when a
/// `report.<name>.sort` key is present — matching Taskwarrior's own rule for a
/// "real" report — and its `.description`, `.filter`, and `.columns` siblings
/// are pulled in when available.
class TaskrcParser {
  final Map<String, String> _entries = <String, String>{};

  /// Ingests raw `.taskrc` text. Safe to call more than once (later values for
  /// the same key win, mirroring Taskwarrior's last-wins semantics).
  void parse(String content) {
    for (final String rawLine in content.split('\n')) {
      final String line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      final int eq = line.indexOf('=');
      if (eq <= 0) continue;
      final String key = line.substring(0, eq).trim();
      final String value = line.substring(eq + 1).trim();
      if (key.isEmpty) continue;
      _entries[key] = value;
    }
  }

  /// The user-defined reports found in the parsed config. Each has a `.sort`;
  /// missing pieces fall back to sensible defaults (id,description columns,
  /// urgency- sort, the name as its own description).
  List<ReportDefinition> customReports() {
    final RegExp reportSort = RegExp(r'^report\.([^.]+)\.sort$');
    final List<String> names = <String>[];
    for (final String key in _entries.keys) {
      final RegExpMatch? m = reportSort.firstMatch(key);
      if (m != null) names.add(m.group(1)!);
    }

    return names.map((String name) {
      return ReportDefinition(
        name: name,
        description: _entries['report.$name.description'] ?? name,
        columns: ColumnSpec.parseList(
            _entries['report.$name.columns'] ?? 'id,description'),
        sortCriteria: SortCriterion.parseList(
            _entries['report.$name.sort'] ?? 'urgency-'),
        filterExpression: _entries['report.$name.filter'],
        isCustom: true,
      );
    }).toList();
  }

  /// Read-only view of all parsed key/value pairs (useful for diagnostics).
  Map<String, String> get entries => Map<String, String>.unmodifiable(_entries);
}
