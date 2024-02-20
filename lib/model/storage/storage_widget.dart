// ignore_for_file: use_build_context_synchronously

import 'dart:collection';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:loggy/loggy.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';

import 'package:taskwarrior/model/json.dart';
import 'package:taskwarrior/model/storage.dart';
import 'package:taskwarrior/model/storage/client.dart';
import 'package:taskwarrior/widgets/taskw.dart';

class TagMetadata {
  TagMetadata({
    required this.lastModified,
    required this.frequency,
    required this.selected,
  });

  final DateTime lastModified;
  final int frequency;
  final bool selected;

  Map toJson() => {
        'lastModified': lastModified,
        'frequency': frequency,
        'selected': selected,
      };

  @override
  String toString() => toJson().toString();
}

class StorageWidget extends StatefulWidget {
  const StorageWidget({super.key, required this.profile, required this.child});

  final Directory profile;
  final Widget child;

  @override
  State<StorageWidget> createState() => _StorageWidgetState();

  static InheritedStorage of(BuildContext context) {
    return InheritedModel.inheritFrom<InheritedStorage>(context)!;
  }
}

class _StorageWidgetState extends State<StorageWidget> {
  late Storage storage;
  late bool pendingFilter;
  late String projectFilter;
  late bool tagUnion;
  late String selectedSort;
  late Set<String> selectedTags;
  late List<Task> queriedTasks;
  late List<Task> searchedTasks;
  late Map<String, TagMetadata> pendingTags;
  late Map<String, ProjectNode> projects;
  bool sortHeaderVisible = false;
  bool searchVisible = false;
  var searchController = TextEditingController();
  late bool serverCertExists;

  @override
  void initState() {
    super.initState();
    storage = Storage(widget.profile);
    serverCertExists = storage.guiPemFiles.serverCertExists();
    _profileSet();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.profile != oldWidget.profile) {
      storage = Storage(widget.profile);
      serverCertExists = storage.guiPemFiles.serverCertExists();
      _profileSet();
    }
  }

  void _profileSet() {
    pendingFilter = Query(storage.tabs.tab()).getPendingFilter();
    projectFilter = Query(storage.tabs.tab()).projectFilter();
    tagUnion = Query(storage.tabs.tab()).tagUnion();
    selectedSort = Query(storage.tabs.tab()).getSelectedSort();
    selectedTags = Query(storage.tabs.tab()).getSelectedTags();
    _refreshTasks();
    pendingTags = _pendingTags();
    projects = _projects();
    if (searchVisible) {
      toggleSearch();
    }
  }

  void _refreshTasks() {
    if (pendingFilter) {
      queriedTasks = storage.data
          .pendingData()
          .where((task) => task.status == 'pending')
          .toList();
    } else {
      queriedTasks = storage.data.completedData();
    }

    if (projectFilter.isNotEmpty) {
      queriedTasks = queriedTasks.where((task) {
        if (task.project == null) {
          return false;
        } else {
          return task.project!.startsWith(projectFilter);
        }
      }).toList();
    }

    queriedTasks = queriedTasks.where((task) {
      var tags = task.tags?.toSet() ?? {};
      if (tagUnion) {
        if (selectedTags.isEmpty) {
          return true;
        }
        return selectedTags.any((tag) => (tag.startsWith('+'))
            ? tags.contains(tag.substring(1))
            : !tags.contains(tag.substring(1)));
      } else {
        return selectedTags.every((tag) => (tag.startsWith('+'))
            ? tags.contains(tag.substring(1))
            : !tags.contains(tag.substring(1)));
      }
    }).toList();

    var sortColumn = selectedSort.substring(0, selectedSort.length - 1);
    var ascending = selectedSort.endsWith('+');
    queriedTasks.sort((a, b) {
      int result;
      if (sortColumn == 'id') {
        result = a.id!.compareTo(b.id!);
      } else {
        result = compareTasks(sortColumn)(a, b);
      }
      return ascending ? result : -result;
    });
    searchedTasks = queriedTasks;
    var searchTerm = searchController.text;
    if (searchVisible) {
      searchedTasks = searchedTasks
          .where((task) =>
              task.description.contains(searchTerm) ||
              (task.annotations?.asList() ?? []).any(
                  (annotation) => annotation.description.contains(searchTerm)))
          .toList();
    }
    pendingTags = _pendingTags();
    projects = _projects();
  }

  Map<String, TagMetadata> _pendingTags() {
    var frequency = tagFrequencies(storage.data.pendingData());
    var modified = tagsLastModified(storage.data.pendingData());
    var setOfTags = tagSet(storage.data.pendingData());
    return SplayTreeMap.of({
      for (var tag in setOfTags)
        tag: TagMetadata(
          frequency: frequency[tag] ?? 0,
          lastModified: modified[tag]!,
          selected: selectedTags
              .map(
                (filter) => filter.substring(1),
              )
              .contains(tag),
        ),
    });
  }

  Map<String, ProjectNode> _projects() {
    var frequencies = <String, int>{};
    for (var task in storage.data.pendingData()) {
      if (task.project != null) {
        if (frequencies.containsKey(task.project)) {
          frequencies[task.project!] = (frequencies[task.project] ?? 0) + 1;
        } else {
          frequencies[task.project!] = 1;
        }
      }
    }
    return SplayTreeMap.of(sparseDecoratedProjectTree(frequencies));
  }

  void togglePendingFilter() {
    Query(storage.tabs.tab()).togglePendingFilter();
    pendingFilter = Query(storage.tabs.tab()).getPendingFilter();
    _refreshTasks();
    setState(() {});
  }

  void toggleProjectFilter(String project) {
    Query(storage.tabs.tab()).toggleProjectFilter(project);
    projectFilter = Query(storage.tabs.tab()).projectFilter();
    _refreshTasks();
    setState(() {});
  }

  void toggleTagUnion() {
    Query(storage.tabs.tab()).toggleTagUnion();
    tagUnion = Query(storage.tabs.tab()).tagUnion();
    _refreshTasks();
    setState(() {});
  }

  void selectSort(String sort) {
    Query(storage.tabs.tab()).setSelectedSort(sort);
    selectedSort = Query(storage.tabs.tab()).getSelectedSort();
    _refreshTasks();
    setState(() {});
  }

  void toggleTagFilter(String tag) {
    if (selectedTags.contains('+$tag')) {
      selectedTags
        ..remove('+$tag')
        ..add('-$tag');
    } else if (selectedTags.contains('-$tag')) {
      selectedTags.remove('-$tag');
    } else {
      selectedTags.add('+$tag');
    }
    Query(storage.tabs.tab()).toggleTagFilter(tag);
    selectedTags = Query(storage.tabs.tab()).getSelectedTags();
    _refreshTasks();
    setState(() {});
  }

  Task getTask(String uuid) {
    return storage.data.getTask(uuid);
  }

  void mergeTask(Task task) {
    storage.data.mergeTask(task);

    _refreshTasks();
    setState(() {});
  }

  Future<void> synchronize(BuildContext context, bool isDialogNeeded) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'You are not connected to the internet. Please check your network connection.',
              style: TextStyle(
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.kprimaryTextColor
                    : TaskWarriorColors.kLightPrimaryTextColor,
              ),
            ),
            backgroundColor: AppSettings.isDarkMode
                ? TaskWarriorColors.ksecondaryBackgroundColor
                : TaskWarriorColors.kLightSecondaryBackgroundColor,
            duration: const Duration(seconds: 2)));
      } else {
        if (isDialogNeeded) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16.0),
                      Text(
                        "Syncing",
                        style: GoogleFonts.poppins(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Please wait...",
                        style: GoogleFonts.poppins(
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        var header = await storage.home.synchronize(await client());
        _refreshTasks();
        pendingTags = _pendingTags();
        projects = _projects();
        setState(() {});

        if (isDialogNeeded) {
          Get.back();
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              '${header['code']}: ${header['status']}',
              style: TextStyle(
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.kprimaryTextColor
                    : TaskWarriorColors.kLightPrimaryTextColor,
              ),
            ),
            backgroundColor: AppSettings.isDarkMode
                ? TaskWarriorColors.ksecondaryBackgroundColor
                : TaskWarriorColors.kLightSecondaryBackgroundColor,
            duration: const Duration(seconds: 2)));
      }
    } catch (e, trace) {
      if (isDialogNeeded) {
        Get.back();
      }
      logError(e, trace);
    }
  }

  void toggleSortHeader() {
    sortHeaderVisible = !sortHeaderVisible;
    setState(() {});
  }

  void toggleSearch() {
    searchVisible = !searchVisible;
    if (!searchVisible) {
      searchedTasks = queriedTasks;
      searchController.text = '';
    }
    setState(() {});
  }

  void search(String term) {
    searchedTasks = queriedTasks
        .where(
          (task) => task.description.toLowerCase().contains(term.toLowerCase()),
        )
        .toList();
    setState(() {});
  }

  void setInitialTabIndex(int index) {
    storage.tabs.setInitialTabIndex(index);
    pendingFilter = Query(storage.tabs.tab()).getPendingFilter();
    selectedSort = Query(storage.tabs.tab()).getSelectedSort();
    selectedTags = Query(storage.tabs.tab()).getSelectedTags();
    projectFilter = Query(storage.tabs.tab()).projectFilter();
    _refreshTasks();
    setState(() {});
  }

  void addTab() {
    storage.tabs.addTab();
    setState(() {});
  }

  List<String> tabUuids() {
    return storage.tabs.tabUuids();
  }

  int initialTabIndex() {
    return storage.tabs.initialTabIndex();
  }

  void removeTab(int index) {
    storage.tabs.removeTab(index);
    pendingFilter = Query(storage.tabs.tab()).getPendingFilter();
    selectedSort = Query(storage.tabs.tab()).getSelectedSort();
    selectedTags = Query(storage.tabs.tab()).getSelectedTags();
    _refreshTasks();
    setState(() {});
  }

  void renameTab({
    required String tab,
    required String name,
  }) {
    storage.tabs.renameTab(tab: tab, name: name);
    setState(() {});
  }

  String? tabAlias(String tabUuid) {
    return storage.tabs.alias(tabUuid);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedStorage(
      storage: storage,
      tasks: searchedTasks,
      pendingTags: pendingTags,
      projects: projects,
      pendingFilter: pendingFilter,
      projectFilter: projectFilter,
      tagUnion: tagUnion,
      selectedSort: selectedSort,
      getTask: getTask,
      mergeTask: mergeTask,
      synchronize: synchronize,
      togglePendingFilter: togglePendingFilter,
      toggleProjectFilter: toggleProjectFilter,
      toggleTagUnion: toggleTagUnion,
      selectSort: selectSort,
      toggleTagFilter: toggleTagFilter,
      selectedTags: selectedTags,
      sortHeaderVisible: sortHeaderVisible,
      searchVisible: searchVisible,
      toggleSortHeader: toggleSortHeader,
      toggleSearch: toggleSearch,
      search: search,
      searchController: searchController,
      setInitialTabIndex: setInitialTabIndex,
      addTab: addTab,
      tabUuids: tabUuids,
      initialTabIndex: initialTabIndex,
      removeTab: removeTab,
      renameTab: renameTab,
      tabAlias: tabAlias,
      serverCertExists: serverCertExists,
      child: widget.child,
    );
  }
}

class InheritedStorage extends InheritedModel<String> {
  // ignore: use_super_parameters
  const InheritedStorage({
    super.key,
    required this.storage,
    required this.tasks,
    required this.pendingTags,
    required this.projects,
    required this.pendingFilter,
    required this.projectFilter,
    required this.tagUnion,
    required this.selectedSort,
    required this.selectedTags,
    required this.getTask,
    required this.mergeTask,
    required this.synchronize,
    required this.togglePendingFilter,
    required this.toggleProjectFilter,
    required this.toggleTagUnion,
    required this.toggleTagFilter,
    required this.selectSort,
    required this.sortHeaderVisible,
    required this.searchVisible,
    required this.toggleSortHeader,
    required this.toggleSearch,
    required this.search,
    required this.searchController,
    required this.setInitialTabIndex,
    required this.addTab,
    required this.tabUuids,
    required this.initialTabIndex,
    required this.removeTab,
    required this.renameTab,
    required this.tabAlias,
    required this.serverCertExists,
    required child,
  }) : super(child: child);

  final Storage storage;
  final List<Task> tasks;
  final Map<String, TagMetadata> pendingTags;
  final Map<String, ProjectNode> projects;
  final bool pendingFilter;
  final String projectFilter;
  final bool tagUnion;
  final String selectedSort;
  final Set<String> selectedTags;
  final Task Function(String) getTask;
  final void Function(Task) mergeTask;
  final void Function(BuildContext, bool) synchronize;
  final void Function() togglePendingFilter;
  final void Function(String) toggleProjectFilter;
  final void Function() toggleTagUnion;
  final void Function(String) selectSort;
  final void Function(String) toggleTagFilter;
  final bool sortHeaderVisible;
  final bool searchVisible;
  final void Function() toggleSortHeader;
  final void Function(int) setInitialTabIndex;
  final void Function() addTab;
  final List<String> Function() tabUuids;
  final int Function() initialTabIndex;
  final void Function(int) removeTab;
  final String? Function(String) tabAlias;
  final void Function() toggleSearch;
  final void Function(String) search;
  final TextEditingController searchController;
  final void Function({required String tab, required String name}) renameTab;
  final bool serverCertExists;

  @override
  bool updateShouldNotify(InheritedStorage oldWidget) {
    return true;
  }

  @override
  bool updateShouldNotifyDependent(
      InheritedStorage oldWidget, Set<String> dependencies) {
    return true;
  }
}
