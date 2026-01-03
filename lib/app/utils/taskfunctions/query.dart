import 'dart:convert';
import 'dart:io';

class Query {
  const Query(this._queryStorage);

  final Directory _queryStorage;

  File get _selectedSort => File('${_queryStorage.path}/selectedSort');
  File get _pendingFilter => File('${_queryStorage.path}/pendingFilter');
  File get _waitingFilter => File('${_queryStorage.path}/waitingFilter');
  File get _deletedFilter => File('${_queryStorage.path}/deletedFilter');
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

  void togggleDeletedFilter() {
    _deletedFilter.writeAsStringSync(
      json.encode(!getDeletedFilter()),
    );
  }

  bool getDeletedFilter() {
    if (!_deletedFilter.existsSync()) {
      _deletedFilter
        ..createSync(recursive: true)
        ..writeAsStringSync('true');
    }
    return json.decode(_deletedFilter.readAsStringSync());
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
    return (json.decode(_selectedTags.readAsStringSync()) as List)
        .cast<String>()
        .toSet();
  }
}
