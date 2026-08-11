import 'dart:convert';
import 'dart:io';

class Query {
  const Query(this._queryStorage);

  final Directory _queryStorage;

  File get _selectedSort => File('${_queryStorage.path}/selectedSort');
  File get _pendingFilter => File('${_queryStorage.path}/pendingFilter');
  File get _statusFilter => File('${_queryStorage.path}/statusFilter');
  File get _waitingFilter => File('${_queryStorage.path}/waitingFilter');
  File get _projectFilter => File('${_queryStorage.path}/projectFilter');
  File get _tagUnion => File('${_queryStorage.path}/tagUnion');
  File get _selectedTags => File('${_queryStorage.path}/selectedTags');

  void setSelectedSort(String selectedSort) {
    if (!_selectedSort.existsSync()) {
      _selectedSort.createSync(recursive: true);
    }
    _selectedSort.writeAsStringSync(selectedSort);
  }

  String getSelectedSort() {
    if (!_selectedSort.existsSync()) {
      _selectedSort
        ..createSync(recursive: true)
        ..writeAsStringSync('urgency+');
    }
    return _selectedSort.readAsStringSync();
  }

  /// The statuses the task list can be filtered to, in cycle order.
  static const String statusPending = 'pending';
  static const String statusCompleted = 'completed';
  static const String statusDeleted = 'deleted';

  /// The status the task list is currently filtered to.
  ///
  /// Supersedes the older boolean `pendingFilter`, which could only express
  /// pending-vs-completed. On first read this migrates the persisted boolean
  /// so an existing profile keeps whichever of the two it was already showing.
  String getStatusFilter() {
    if (!_statusFilter.existsSync()) {
      final String migrated =
          getPendingFilter() ? statusPending : statusCompleted;
      _statusFilter
        ..createSync(recursive: true)
        ..writeAsStringSync(migrated);
      return migrated;
    }
    final String value = _statusFilter.readAsStringSync().trim();
    // Guard against a corrupt/unknown value rather than filtering to nothing.
    return const [statusPending, statusCompleted, statusDeleted].contains(value)
        ? value
        : statusPending;
  }

  void setStatusFilter(String status) {
    if (!_statusFilter.existsSync()) {
      _statusFilter.createSync(recursive: true);
    }
    _statusFilter.writeAsStringSync(status);
    // Keep the legacy boolean in step: call sites that still read it (the
    // local/Taskserver list, the home widget) then behave sensibly, treating
    // "deleted" as not-pending.
    _pendingFilter
      ..createSync(recursive: true)
      ..writeAsStringSync(json.encode(status == statusPending));
  }

  /// Advances to the next status in the cycle. [includeDeleted] is false for
  /// sync modes with no deleted view, so those keep the original two-way
  /// pending/completed toggle.
  void cycleStatusFilter({bool includeDeleted = false}) {
    final String current = getStatusFilter();
    final List<String> cycle = includeDeleted
        ? const [statusPending, statusCompleted, statusDeleted]
        : const [statusPending, statusCompleted];
    final int index = cycle.indexOf(current);
    // A value outside this cycle (e.g. "deleted" while in a two-way mode)
    // falls back to the start rather than getting stuck.
    setStatusFilter(index == -1 ? cycle.first : cycle[(index + 1) % cycle.length]);
  }

  void togglePendingFilter() {
    _pendingFilter.writeAsStringSync(
      json.encode(!getPendingFilter()),
    );
  }

  bool getPendingFilter() {
    if (!_pendingFilter.existsSync()) {
      _pendingFilter
        ..createSync(recursive: true)
        ..writeAsStringSync('true');
    }
    return json.decode(_pendingFilter.readAsStringSync());
  }

  void toggleWaitingFilter() {
    _waitingFilter.writeAsStringSync(
      json.encode(!getWaitingFilter()),
    );
  }

  bool getWaitingFilter() {
    if (!_waitingFilter.existsSync()) {
      _waitingFilter
        ..createSync(recursive: true)
        ..writeAsStringSync('true');
    }
    return json.decode(_waitingFilter.readAsStringSync());
  }

  void toggleProjectFilter(String project) {
    _projectFilter.writeAsStringSync(
      (project == projectFilter()) ? '' : project,
    );
  }

  String projectFilter() {
    if (!_projectFilter.existsSync()) {
      _projectFilter.createSync(recursive: true);
    }
    return _projectFilter.readAsStringSync();
  }

  void toggleTagUnion() {
    _tagUnion.writeAsStringSync(
      json.encode(!tagUnion()),
    );
  }

  bool tagUnion() {
    if (!_tagUnion.existsSync()) {
      _tagUnion
        ..createSync(recursive: true)
        ..writeAsStringSync('false');
    }
    return json.decode(_tagUnion.readAsStringSync());
  }

  void toggleTagFilter(String tag) {
    var tags = getSelectedTags();
    if (tags.contains('+$tag')) {
      tags
        ..remove('+$tag')
        ..add('-$tag');
    } else if (tags.contains('-$tag')) {
      tags.remove('-$tag');
    } else {
      tags.add('+$tag');
    }
    _selectedTags.writeAsStringSync(json.encode(tags.toList()));
  }

  Set<String> getSelectedTags() {
    if (!_selectedTags.existsSync()) {
      _selectedTags
        ..createSync(recursive: true)
        ..writeAsStringSync(json.encode([]));
    }
    return (json.decode(_selectedTags.readAsStringSync()) as List).cast<String>().toSet();
  }
}
