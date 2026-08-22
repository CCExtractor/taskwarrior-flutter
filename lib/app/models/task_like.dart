import 'package:taskwarrior/app/v3/models/annotation.dart';

/// The canonical read contract shared by every task model in the app.
///
/// The app historically carried two parallel task models — `TaskForC` (the
/// local/Taskserver path, which stores `entry`/`modified` as strings) and
/// `TaskForReplica` (the TaskChampion path, which stores them as epoch
/// seconds). Shared logic (filtering, sorting, reports, urgency) had to be
/// hard-typed to one of them, so it only ever worked for a single sync mode.
///
/// [TaskLike] is the unifying surface: both models implement it, so shared
/// logic can be written once against this contract and work for every mode.
///
/// Most attributes are declared with the types both models already use, so
/// implementing this interface requires no field changes. The only two
/// attributes whose raw representations genuinely differ (`entry`, `modified`)
/// are exposed here as **normalized** [DateTime] accessors — [entryDate] and
/// [modifiedDate] — leaving each model free to keep its own storage format.
abstract class TaskLike {
  /// Stable identifier. Nullable because the local model permits a null uuid
  /// for tasks that have not been assigned one yet.
  String? get uuid;

  String? get description;

  /// `pending` / `completed` / `deleted` / `recurring`.
  String? get status;

  String? get project;

  /// `H` / `M` / `L`, or null for none.
  String? get priority;

  List<String>? get tags;

  /// UUIDs of the tasks this one depends on.
  List<String>? get depends;

  List<Annotation>? get annotations;

  /// Recurrence rule (e.g. `weekly`), or null for a non-recurring task.
  String? get recur;

  /// Date attributes, in each model's existing string form. Parse with
  /// [parseTaskDate] when a [DateTime] is required.
  String? get due;
  String? get start;
  String? get wait;

  /// Whether this task has at least one *unresolved* dependency.
  ///
  /// Null means "unknown" — the local/Taskserver path does not compute
  /// dependency resolution (that requires the full task set), so only the
  /// TaskChampion path reports a definite value. Consumers should treat null
  /// as "not blocked" rather than assuming either state.
  bool? get isBlocked;

  /// Whether at least one other task depends on this one. Null means unknown
  /// (see [isBlocked]).
  bool? get isBlocking;

  /// Creation time, normalized across both models' storage formats.
  DateTime? get entryDate;

  /// Last-modified time, normalized across both models' storage formats.
  DateTime? get modifiedDate;
}

/// Parses a task date attribute into UTC, accepting both representations used
/// across the app: an ISO-8601 string, a Taskwarrior compact stamp
/// (`20240701T161718Z`), or epoch seconds rendered as a string.
///
/// Returns null for null/empty/unparseable input rather than throwing, since
/// task data arriving from sync or an older local database can be incomplete.
DateTime? parseTaskDate(String? value) {
  if (value == null) return null;
  final String raw = value.trim();
  if (raw.isEmpty) return null;

  // The specific formats are checked BEFORE DateTime.tryParse, because
  // tryParse is permissive enough to swallow both of them and produce a wrong
  // answer: it reads a compact stamp as *local* time (shifting it by the
  // device's timezone) and reads bare epoch digits as a year.

  // Taskwarrior's compact form, e.g. 20240701T161718Z. Task timestamps are
  // UTC, so a missing trailing Z is still treated as UTC rather than local —
  // otherwise the same data would resolve differently per device timezone.
  final RegExpMatch? compact =
      RegExp(r'^(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})(\d{2})Z?$')
          .firstMatch(raw);
  if (compact != null) {
    return DateTime.utc(
      int.parse(compact.group(1)!),
      int.parse(compact.group(2)!),
      int.parse(compact.group(3)!),
      int.parse(compact.group(4)!),
      int.parse(compact.group(5)!),
      int.parse(compact.group(6)!),
    );
  }

  // Epoch seconds, as emitted by the Rust FFI layer. Requires at least 9
  // digits so a short numeric string (e.g. a bare "2024") still falls through
  // to the ISO parser instead of being read as a 1970s timestamp.
  if (RegExp(r'^\d{9,}$').hasMatch(raw)) {
    final int? epoch = int.tryParse(raw);
    if (epoch != null) {
      return DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: true);
    }
  }

  return DateTime.tryParse(raw)?.toUtc();
}

/// Converts epoch seconds to a UTC [DateTime], or null when absent.
DateTime? epochToDate(int? epochSeconds) => epochSeconds == null
    ? null
    : DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000, isUtc: true);
