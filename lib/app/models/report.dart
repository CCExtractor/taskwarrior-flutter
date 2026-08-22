/// Data model for the reporting engine (Issue #418).
///
/// A *report* is a named, purpose-built bundle of a filter expression, a sort
/// order, and a set of display columns — mirroring Taskwarrior's report system
/// (`report.<name>.filter` / `.sort` / `.columns` / `.description`). Reports let
/// users invoke preset views like "next", "ready", or "overdue" instead of
/// hand-building a filter/sort every time.
library;

/// A single column in a report's display (e.g. `description`, `due`).
class ColumnSpec {
  final String field;
  final String? label;

  const ColumnSpec(this.field, {this.label});

  /// Parses a Taskwarrior `report.*.columns` value such as
  /// `"id,description,due"` into a list of columns. Taskwarrior column formats
  /// (e.g. `due.relative`) are reduced to their base attribute.
  static List<ColumnSpec> parseList(String value) {
    return value
        .split(',')
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .map((c) => ColumnSpec(c.split('.').first))
        .toList();
  }
}

/// One sort key: an attribute plus a direction. Taskwarrior encodes these as
/// `field+` (ascending) or `field-` (descending), optionally chained with
/// commas (e.g. `"urgency-,due+"`).
class SortCriterion {
  final String field;
  final bool ascending;

  const SortCriterion(this.field, {this.ascending = true});

  /// Parses a Taskwarrior `report.*.sort` value into an ordered list of keys.
  /// A trailing `+`/`-` sets direction (default ascending). A `/` break marker
  /// (e.g. `urgency-/`) is ignored — only the ordering matters here.
  static List<SortCriterion> parseList(String value) {
    return value
        .split(',')
        .map((s) => s.trim().replaceAll('/', ''))
        .where((s) => s.isNotEmpty)
        .map((s) {
      if (s.endsWith('-')) {
        return SortCriterion(s.substring(0, s.length - 1), ascending: false);
      }
      if (s.endsWith('+')) {
        return SortCriterion(s.substring(0, s.length - 1), ascending: true);
      }
      return SortCriterion(s); // no direction → ascending
    }).toList();
  }
}

/// A complete report definition.
class ReportDefinition {
  /// Short identifier, e.g. `next` — also the display title.
  final String name;

  /// Human-readable one-line summary shown under the name.
  final String description;

  /// Columns to display (advisory for the UI; may be empty).
  final List<ColumnSpec> columns;

  /// Ordered sort keys applied after filtering.
  final List<SortCriterion> sortCriteria;

  /// The filter expression (e.g. `"status:pending +READY"`), or null/empty for
  /// "everything".
  final String? filterExpression;

  /// True for reports read from a user `.taskrc` (grouped above the defaults).
  final bool isCustom;

  const ReportDefinition({
    required this.name,
    required this.description,
    this.columns = const [],
    this.sortCriteria = const [],
    this.filterExpression,
    this.isCustom = false,
  });
}
