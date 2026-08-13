// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks

import 'dart:collection';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:loggy/loggy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/models/filters.dart';

import 'package:taskwarrior/app/models/json/task.dart';
import 'package:taskwarrior/app/models/storage/client.dart';
import 'package:taskwarrior/app/models/storage.dart';
import 'package:taskwarrior/app/models/tag_meta_data.dart';
import 'package:taskwarrior/app/modules/home/controllers/widget.controller.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/services/deep_link_service.dart';
import 'package:taskwarrior/app/services/tag_filter.dart';
import 'package:taskwarrior/app/tour/filter_drawer_tour.dart';
import 'package:taskwarrior/app/tour/home_page_tour.dart';
import 'package:taskwarrior/app/tour/task_swipe_tour.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';
import 'package:taskwarrior/app/utils/taskfunctions/comparator.dart';
import 'package:taskwarrior/app/utils/taskfunctions/projects.dart';
import 'package:taskwarrior/app/utils/taskfunctions/query.dart';
import 'package:taskwarrior/app/utils/taskfunctions/tags.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/v3/champion/replica.dart';
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';
import 'package:taskwarrior/app/v3/models/task.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:taskwarrior/app/tour/safe_tour.dart';

class HomeController extends GetxController {
  final SplashController splashController = Get.find<SplashController>();
  late Storage storage;
  final RxBool pendingFilter = false.obs;
  /// Which status the list is filtered to: pending / completed / deleted.
  /// Supersedes [pendingFilter], which can only express the first two; that
  /// flag is kept in step for the call sites still reading it.
  final RxString statusFilter = Query.statusPending.obs;
  final RxBool waitingFilter = false.obs;
  final RxString projectFilter = ''.obs;
  final RxBool tagUnion = false.obs;
  final RxString selectedSort = ''.obs;
  final RxSet<String> selectedTags = <String>{}.obs;
  final RxList<Task> queriedTasks = <Task>[].obs;
  final RxList<Task> searchedTasks = <Task>[].obs;
  // Reactive mirror of the search box text. `searchedTasks` only drives the
  // local-taskc list (TasksBuilder); the TaskChampion replica list reads
  // `tasksFromReplica` directly, so it needs an observable query to rebuild and
  // filter on each keystroke. Kept in sync by search()/toggleSearch().
  final RxString searchQuery = ''.obs;
  final RxList<DateTime?> selectedDates = List<DateTime?>.filled(4, null).obs;
  final RxMap<String, TagMetadata> pendingTags = <String, TagMetadata>{}.obs;
  final RxMap<String, ProjectNode> projects = <String, ProjectNode>{}.obs;
  final RxBool sortHeaderVisible = false.obs;
  final RxBool searchVisible = false.obs;
  final TextEditingController searchController = TextEditingController();
  final StringTagController stringTagController = StringTagController();
  late RxBool serverCertExists;
  final Rx<SupportedLanguage> selectedLanguage = SupportedLanguage.english.obs;
  final ScrollController scrollController = ScrollController();
  final FocusNode searchFocusNode = FocusNode();
  final RxBool showbtn = false.obs;
  late TaskDatabase taskdb;
  var tasks = <TaskForC>[].obs;
  var tasksFromReplica = <TaskForReplica>[].obs;
  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    debugPrint("🚀 BOOT: HomeController.onInit()");
    super.onInit();
    storage = Storage(
      Directory(
        '${splashController.baseDirectory.value.path}/profiles/${splashController.currentProfile.value}',
      ),
    );
    serverCertExists = RxBool(storage.guiPemFiles.serverCertExists());
    addListenerToScrollController();

    _profileSet();
    loadDelayTask();
    initLanguageAndDarkMode();
    taskdb = TaskDatabase();
    taskdb.open();
    getUniqueProjects();
    // Initialize the pending/waiting filters from their persisted values.
    // Without this the RxBool defaults to false, and the replica list view
    // (which filters `status == pending` only when pendingFilter is true)
    // shows completed tasks only — hiding every pending task on first load.
    pendingFilter.value = Query(storage.tabs.tab()).getPendingFilter();
    statusFilter.value = Query(storage.tabs.tab()).getStatusFilter();
    waitingFilter.value = Query(storage.tabs.tab()).getWaitingFilter();
    _loadTaskChampion();
    fetchTasksFromDB();

    ever(AppSettings.use24HourFormatRx, (_) {
      _refreshTasks();
      update();
    });

    ever(taskReplica, (_) {
      if (taskReplica.value) refreshReplicaTaskList();
    });
    everAll([
      pendingFilter,
      statusFilter,
      waitingFilter,
      projectFilter,
      tagUnion,
      selectedSort,
      selectedTags,
      tasks,
      tasksFromReplica,
    ], (_) {
      if (Platform.isAndroid || Platform.isIOS) {
        WidgetController widgetController = Get.put(WidgetController());
        widgetController.fetchAllData();
        widgetController.update();
      }
    });
    ever(splashController.currentProfile, (_) {
      if (splashController.getMode(splashController.currentProfile.value) !=
          "TW3") {
        refreshTaskWithNewProfile();
      }
      if (Platform.isAndroid || Platform.isIOS) {
        WidgetController widgetController = Get.put(WidgetController());
        widgetController.fetchAllData();
        widgetController.updateWidget();
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    // Replaced 50ms delay with a secure PostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed) return;

      final deepLinkService = Get.find<DeepLinkService>();
      if (deepLinkService.queuedUri != null) {
        debugPrint(
            "🚀 TRACE: HomeController.onReady() consuming deferred queue!");
        deepLinkService.consumePendingActions(this);
      }
    });
  }

  Future<List<String>> getUniqueProjects() async {
    if (taskReplica.value) {
      return tasksFromReplica
          .where((task) => task.project != null)
          .map((task) => task.project!)
          .toSet()
          .toList();
    }
    var taskDatabase = TaskDatabase();
    List<String> uniqueProjects = await taskDatabase.fetchUniqueProjects();
    debugPrint('Unique projects: $uniqueProjects');
    return uniqueProjects;
  }

  Future<void> deleteAllTasksInDB() async {
    var taskDatabase = TaskDatabase();
    await taskDatabase.deleteAllTasksInDB();
    debugPrint('Deleted all tasks from db');
  }

  Future<void> refreshReplicaTaskList() async {
    if (!taskReplica.value) return;
    tasksFromReplica.value = await Replica.getAllTasksFromReplica();
    debugPrint("Tasks from Replica: ${tasks.length}");
  }

  Future<void> fetchTasksFromDB() async {
    debugPrint("Fetching tasks from DB ${taskReplica.value}");
    await _loadTaskChampion();
    if (taskReplica.value) {
      tasksFromReplica.value = await Replica.getAllTasksFromReplica();
      debugPrint("Tasks from Replica: ${tasks.length}");
      return;
    }
    if (taskchampion.value == false) {
      return;
    }
    TaskDatabase taskDatabase = TaskDatabase();
    await taskDatabase.open();
    List<TaskForC> fetchedTasks = await taskDatabase.fetchTasksFromDatabase();
    tasks.value = fetchedTasks;
  }

  Future<void> _loadTaskChampion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    taskchampion.value = prefs.getBool('settings_taskc') ?? false;
    taskReplica.value = prefs.getBool('settings_taskr_repl') ?? false;
  }

  Future<void> refreshReplicaTasks() async {
    if (!taskReplica.value) return;
    await Replica.sync();
    tasksFromReplica.value = await Replica.getAllTasksFromReplica();
    debugPrint("Tasks from Replica: ${tasks.length}");
  }

  void addListenerToScrollController() {
    scrollController.addListener(() {
      //scroll listener
      double showoffset =
          10.0; //Back to top botton will show on scroll offset 10.0

      if (scrollController.offset > showoffset) {
        showbtn.value = true;
      } else {
        showbtn.value = false;
      }
    });
  }

  void _profileSet() {
    pendingFilter.value = Query(storage.tabs.tab()).getPendingFilter();
    statusFilter.value = Query(storage.tabs.tab()).getStatusFilter();
    // Load the persisted waiting-filter value as-is. The previous logic here
    // toggled (and thus persisted) it to false whenever it was true, so a
    // profile with the waiting filter enabled silently had it disabled every
    // time the app started.
    waitingFilter.value = Query(storage.tabs.tab()).getWaitingFilter();
    projectFilter.value = Query(storage.tabs.tab()).projectFilter();
    tagUnion.value = Query(storage.tabs.tab()).tagUnion();
    selectedSort.value = Query(storage.tabs.tab()).getSelectedSort();
    // Replace, not merge: this runs every time a profile becomes active (see
    // refreshTaskWithNewProfile), so a plain addAll would leak the previous
    // profile's tag filters into the new one instead of loading its own.
    selectedTags.assignAll(Query(storage.tabs.tab()).getSelectedTags());

    _refreshTasks();
    pendingTags.value = _pendingTags();
    projects.value = _projects();
    if (searchVisible.value) {
      toggleSearch();
    }
  }

  void _refreshTasks() {
    if (pendingFilter.value) {
      queriedTasks.value = storage.data
          .pendingData()
          .where((task) => task.status == 'pending')
          .toList();
    } else {
      queriedTasks.value = storage.data.completedData();
    }

    if (waitingFilter.value) {
      var currentTime = DateTime.now();
      queriedTasks.value = queriedTasks
          .where((task) => task.wait != null && task.wait!.isAfter(currentTime))
          .toList();
    }

    if (projectFilter.value.isNotEmpty) {
      queriedTasks.value = queriedTasks.where((task) {
        if (task.project == null) {
          return false;
        } else {
          return task.project!.startsWith(projectFilter.value);
        }
      }).toList();
    }

    queriedTasks.value = queriedTasks.where((task) {
      var tags = task.tags?.toSet() ?? {};
      if (tagUnion.value) {
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

    var sortColumn =
        selectedSort.value.substring(0, selectedSort.value.length - 1);
    var ascending = selectedSort.value.endsWith('+');
    queriedTasks.sort((a, b) {
      int result;
      if (sortColumn == 'id') {
        result = a.id!.compareTo(b.id!);
      } else {
        result = compareTasks(sortColumn)(a, b);
      }
      return ascending ? result : -result;
    });

    searchedTasks.assignAll(queriedTasks);
    var searchTerm = searchController.text;
    if (searchVisible.value) {
      searchedTasks.value = searchedTasks
          .where((task) =>
              task.description.contains(searchTerm) ||
              (task.annotations?.asList() ?? []).any(
                  (annotation) => annotation.description.contains(searchTerm)))
          .toList();
    }
    pendingTags.value = _pendingTags();
    projects.value = _projects();
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
          selected: selectedTags.contains('+$tag'),
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
    // Cycle pending -> completed -> deleted -> pending. "Deleted" is only
    // offered on the TaskChampion path, which is the only one that keeps
    // deleted tasks (the local list has no deleted view), so other modes keep
    // the original two-way toggle.
    Query(storage.tabs.tab())
        .cycleStatusFilter(includeDeleted: taskReplica.value);
    pendingFilter.value = Query(storage.tabs.tab()).getPendingFilter();
    statusFilter.value = Query(storage.tabs.tab()).getStatusFilter();
    _refreshTasks();
  }

  void toggleWaitingFilter() {
    Query(storage.tabs.tab()).toggleWaitingFilter();
    waitingFilter.value = Query(storage.tabs.tab()).getWaitingFilter();
    _refreshTasks();
  }

  void toggleProjectFilter(String project) {
    Query(storage.tabs.tab()).toggleProjectFilter(project);
    projectFilter.value = Query(storage.tabs.tab()).projectFilter();
    _refreshTasks();
  }

  void toggleTagUnion() {
    Query(storage.tabs.tab()).toggleTagUnion();
    tagUnion.value = Query(storage.tabs.tab()).tagUnion();
    _refreshTasks();
  }

  void selectSort(String sort) {
    Query(storage.tabs.tab()).setSelectedSort(sort);
    selectedSort.value = Query(storage.tabs.tab()).getSelectedSort();
    _refreshTasks();
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
    selectedTags.addAll(Query(storage.tabs.tab()).getSelectedTags());
    _refreshTasks();
  }

  Task getTask(String uuid) {
    return storage.data.getTask(uuid);
  }

  void mergeTask(Task task) {
    storage.data.mergeTask(task);

    _refreshTasks();
  }

  Future<void> syncReplica() async {
    await Replica.sync();
  }

  Future<void> synchronize(BuildContext context, bool isDialogNeeded) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      TaskwarriorColorTheme tColors =
          Theme.of(context).extension<TaskwarriorColorTheme>()!;
      if (connectivityResult == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'You are not connected to the internet. Please check your network connection.',
              style: TextStyle(
                color: tColors.primaryTextColor,
              ),
            ),
            backgroundColor: tColors.secondaryBackgroundColor,
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
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16.0),
                      Text(
                        "Syncing",
                        // style: GoogleFonts.poppins(
                        //   fontSize: TaskWarriorFonts.fontSizeLarge,
                        //   fontWeight: TaskWarriorFonts.bold,
                        // ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        "Please wait...",
                        // style: GoogleFonts.poppins(
                        //   fontSize: TaskWarriorFonts.fontSizeSmall,
                        //   fontWeight: TaskWarriorFonts.regular,
                        // ),
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
        pendingTags.value = _pendingTags();
        projects.value = _projects();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              '${header['code']}: ${header['status']}',
              style: TextStyle(
                color: tColors.primaryTextColor,
              ),
            ),
            backgroundColor: tColors.secondaryBackgroundColor,
            duration: const Duration(seconds: 2)));

        if (isDialogNeeded) {
          Get.back(closeOverlays: true);
          return;
        }
      }
    } catch (e, trace) {
      if (isDialogNeeded) {
        Get.back(closeOverlays: true);
      }
      logError(e, trace);
    }
  }

  void toggleSortHeader() {
    sortHeaderVisible.value = !sortHeaderVisible.value;
  }

  void toggleSearch() {
    searchVisible.value = !searchVisible.value;
    if (searchVisible.value) {
      Future.delayed(const Duration(milliseconds: 300), () {
        searchFocusNode.requestFocus();
      });
    }
    if (!searchVisible.value) {
      searchedTasks.assignAll(queriedTasks);
      searchController.text = '';
      searchQuery.value = '';
    }
  }

  void search(String term) {
    searchQuery.value = term;
    searchedTasks.assignAll(
      queriedTasks
          .where(
            (task) =>
                task.description.toLowerCase().contains(term.toLowerCase()),
          )
          .toList(),
    );
  }

  void setInitialTabIndex(int index) {
    storage.tabs.setInitialTabIndex(index);
    pendingFilter.value = Query(storage.tabs.tab()).getPendingFilter();
    statusFilter.value = Query(storage.tabs.tab()).getStatusFilter();
    waitingFilter.value = Query(storage.tabs.tab()).getWaitingFilter();
    selectedSort.value = Query(storage.tabs.tab()).getSelectedSort();
    selectedTags.addAll(Query(storage.tabs.tab()).getSelectedTags());
    projectFilter.value = Query(storage.tabs.tab()).projectFilter();
    _refreshTasks();
  }

  void addTab() {
    storage.tabs.addTab();
  }

  List<String> tabUuids() {
    return storage.tabs.tabUuids();
  }

  int initialTabIndex() {
    return storage.tabs.initialTabIndex();
  }

  void removeTab(int index) {
    storage.tabs.removeTab(index);
    pendingFilter.value = Query(storage.tabs.tab()).getPendingFilter();
    statusFilter.value = Query(storage.tabs.tab()).getStatusFilter();
    waitingFilter.value = Query(storage.tabs.tab()).getWaitingFilter();
    selectedSort.value = Query(storage.tabs.tab()).getSelectedSort();
    selectedTags.addAll(Query(storage.tabs.tab()).getSelectedTags());
    _refreshTasks();
  }

  void renameTab({
    required String tab,
    required String name,
  }) {
    storage.tabs.renameTab(tab: tab, name: name);
  }

  String? tabAlias(String tabUuid) {
    return storage.tabs.alias(tabUuid);
  }

  RxBool isSyncNeeded = false.obs;

  void checkForSync(BuildContext context) {
    if (!isSyncNeeded.value) {
      isNeededtoSyncOnStart(context);
      isSyncNeeded.value = true;
    }
  }

  isNeededtoSyncOnStart(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool syncEnabled = prefs.getBool('sync-onStart') ?? false;
    if (!syncEnabled) return;

    final String? clientId = await CredentialsStorage.getClientId();
    final String? encryptionSecret =
        await CredentialsStorage.getEncryptionSecret();

    try {
      isRefreshing.value = true;
      if (taskReplica.value) {
        if (clientId != null && encryptionSecret != null) {
          await refreshReplicaTasks();
        }
      } else if (taskchampion.value) {
        // CCSync HTTP sync has been retired; the local TaskChampion database is
        // the source of truth for this mode, so reload it without a remote
        // round-trip.
        await fetchTasksFromDB();
      } else {
        await synchronize(context, false);
      }
      if (context.mounted) {
        final tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sync Completed',
              style: TextStyle(
                color: tColors.primaryTextColor,
              ),
            ),
            backgroundColor: tColors.primaryBackgroundColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error during sync on start: $e');
    } finally {
      isRefreshing.value = false;
    }
  }

  RxBool syncOnStart = false.obs;
  RxBool syncOnTaskCreate = false.obs;
  RxBool delaytask = false.obs;
  RxBool taskchampion = false.obs;
  RxBool taskReplica = false.obs;

  // dialogue box
  final formKey = GlobalKey<FormState>();
  final namecontroller = TextEditingController();
  final projectcontroller = TextEditingController();
  var due = Rxn<DateTime>();
  RxString dueString = ''.obs;
  final priorityList = ['L', 'X', 'M', 'H'];
  final priorityColors = [
    TaskWarriorColors.green,
    TaskWarriorColors.grey,
    TaskWarriorColors.yellow,
    TaskWarriorColors.red,
  ];
  RxString priority = 'X'.obs;

  final tagcontroller = TextEditingController();
  RxList<String> tags = <String>[].obs;
  RxBool inThePast = false.obs;

  Filters getFilters() {
    var selectedTagsMap = {
      for (var tag in selectedTags) tag.substring(1): tag,
    };

    var keys = (pendingTags.keys.toSet()..addAll(selectedTagsMap.keys)).toList()
      ..sort();

    var tags = {
      for (var tag in keys)
        tag: TagFilterMetadata(
          display:
              '${selectedTagsMap[tag] ?? tag} ${pendingTags[tag]?.frequency ?? 0}',
          selected: selectedTagsMap.containsKey(tag),
        ),
    };

    var tagFilters = TagFilters(
      tagUnion: tagUnion.value,
      toggleTagUnion: toggleTagUnion,
      tags: tags,
      toggleTagFilter: toggleTagFilter,
    );
    var filters = Filters(
      pendingFilter: pendingFilter.value,
      waitingFilter: waitingFilter.value,
      togglePendingFilter: togglePendingFilter,
      toggleWaitingFilter: toggleWaitingFilter,
      projects: projects,
      projectFilter: projectFilter.value,
      toggleProjectFilter: toggleProjectFilter,
      tagFilters: tagFilters,
    );
    return filters;
  }

  // select profile
  void refreshTaskWithNewProfile() {
    storage = Storage(
      Directory(
        '${splashController.baseDirectory.value.path}/profiles/${splashController.currentProfile.value}',
      ),
    );
    // Reload the filter/sort/tag state from the NEW profile's own persisted
    // Query/storage.tabs, not just re-point storage and refresh with whatever
    // filters happened to be in memory from the previous profile — otherwise
    // the previous profile's project/tag/sort preferences silently carry over
    // and get applied to the new profile's tasks.
    _profileSet();
  }

  void changeInDirectory() {
    print("directory change to ${splashController.baseDirectory.value.path}");
    storage = Storage(
      Directory(
        '${splashController.baseDirectory.value.path}/profiles/${splashController.currentProfile.value}',
      ),
    );
    // Same reasoning as refreshTaskWithNewProfile: reload the filter/sort/tag
    // state from the profile's Query/storage.tabs at the new location, rather
    // than reusing whatever was in memory from the old base directory.
    _profileSet();
  }

  RxBool useDelayTask = false.obs;

  Future<void> loadDelayTask() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    useDelayTask.value = prefs.getBool('delaytask') ?? false;
  }

  RxBool isDarkModeOn = false.obs;

  void initLanguageAndDarkMode() {
    isDarkModeOn.value = AppSettings.isDarkMode;
    selectedLanguage.value = AppSettings.selectedLanguage;
    HomeWidget.saveWidgetData(
        "themeMode", AppSettings.isDarkMode ? "dark" : "light");
    HomeWidget.updateWidget(
        androidName: "TaskWarriorWidgetProvider",
        iOSName: "TaskWarriorWidgets");
    // print("called and value is${isDarkModeOn.value}");
  }

  final addKey = GlobalKey();
  final searchKey1 = GlobalKey();
  final searchKey2 = GlobalKey();
  final filterKey = GlobalKey();
  final menuKey = GlobalKey();
  final refreshKey = GlobalKey();

  late TutorialCoachMark tutorialCoachMark;

  void initInAppTour() {
    tutorialCoachMark = TutorialCoachMark(
        targets: addTargetsPage(
          addKey: addKey,
          searchKey: searchKey1,
          filterKey: filterKey,
          menuKey: menuKey,
          refreshKey: refreshKey,
        ),
        colorShadow: TaskWarriorColors.black,
        paddingFocus: 10,
        opacityShadow: 0.8,
        hideSkip: true,
        onFinish: () {
          SaveTourStatus.saveInAppTourStatus(true);
        });
  }

  void showInAppTour(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        if (await SaveTourStatus.getInAppTourStatus()) {
          debugPrint('User has seen this page');
          return;
        }
        await safeShowTour(
          tutorialCoachMark: tutorialCoachMark,
          context: context,
          targetKeys: [addKey, searchKey1, filterKey, menuKey, refreshKey],
          markSeen: () => SaveTourStatus.saveInAppTourStatus(true),
        );
      },
    );
  }

  final GlobalKey statusKey = GlobalKey();
  final GlobalKey projectsKey = GlobalKey();
  final GlobalKey projectsKeyTaskc = GlobalKey();
  final GlobalKey filterTagKey = GlobalKey();
  final GlobalKey sortByKey = GlobalKey();

  /// Which projects column the filter drawer is currently showing. The two sit
  /// behind mutually exclusive `Visibility` widgets, so only one of
  /// [projectsKey] / [projectsKeyTaskc] is ever laid out.
  bool get usesTaskchampionProjects =>
      taskchampion.value || taskReplica.value;

  void initFilterDrawerTour() {
    tutorialCoachMark = TutorialCoachMark(
      targets: filterDrawer(
        statusKey: statusKey,
        projectsKey: projectsKey,
        projectsKeyTaskc: projectsKeyTaskc,
        filterTagKey: filterTagKey,
        sortByKey: sortByKey,
        useTaskchampionProjects: usesTaskchampionProjects,
      ),
      colorShadow: TaskWarriorColors.black,
      paddingFocus: 10,
      opacityShadow: 1.00,
      hideSkip: true,
      onFinish: () {
        SaveTourStatus.saveFilterTourStatus(true);
      },
    );
  }

  void showFilterDrawerTour(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        if (await SaveTourStatus.getFilterTourStatus()) {
          debugPrint('User has seen this page');
          return;
        }
        await safeShowTour(
          tutorialCoachMark: tutorialCoachMark,
          context: context,
          targetKeys: [
            statusKey,
            // Only the column actually on screen; the other key is never laid
            // out, so requiring it would suppress the tour permanently.
            usesTaskchampionProjects ? projectsKeyTaskc : projectsKey,
            filterTagKey,
            sortByKey,
          ],
          markSeen: () => SaveTourStatus.saveFilterTourStatus(true),
        );
      },
    );
  }

  final taskItemKey = GlobalKey();

  void initTaskSwipeTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: addTaskSwipeTutorialTargets(taskItemKey: taskItemKey),
      colorShadow: TaskWarriorColors.black,
      paddingFocus: 10,
      opacityShadow: 1.00,
      hideSkip: true,
      onFinish: () {
        SaveTourStatus.saveTaskSwipeTutorialStatus(true);
      },
    );
  }

  void showTaskSwipeTutorial(BuildContext context) {
    SaveTourStatus.getTaskSwipeTutorialStatus().then((value) async {
      if (value) {
        debugPrint('User has already seen the task swipe tutorial');
        return;
      }
      initTaskSwipeTutorial();
      // This tour points at a task row, so it has nothing to highlight on an
      // empty list — the guard turns that into a skip rather than a throw.
      await safeShowTour(
        tutorialCoachMark: tutorialCoachMark,
        context: context,
        targetKeys: [taskItemKey],
        markSeen: () => SaveTourStatus.saveTaskSwipeTutorialStatus(true),
      );
    });
  }

  Iterable<String> get allTagsInCurrentTasks {
    if (taskReplica.value) {
      var tagSet = <String>{};
      for (var task in tasksFromReplica) {
        if (task.tags != null) {
          tagSet.addAll(task.tags!);
        }
      }
      var sortedTags = tagSet.toList()..sort();
      return sortedTags;
    }
    return tagSet(storage.data.allData());
  }

  RxString uuid = "".obs;
  RxBool isHomeWidgetTaskTapped = false.obs;

  // void handleHomeWidgetClicked() async {
  //   Uri? uri = await HomeWidget.initiallyLaunchedFromHomeWidget();
  //   if (uri != null) {
  //     if (uri.host == "cardclicked") {
  //       if (uri.queryParameters["uuid"] != null &&
  //           !taskchampion.value &&
  //           !taskReplica.value) {
  //         uuid.value = uri.queryParameters["uuid"] as String;
  //         isHomeWidgetTaskTapped.value = true;
  //         Future.delayed(Duration.zero, () {
  //           Get.toNamed(Routes.DETAIL_ROUTE, arguments: ["uuid", uuid.value]);
  //         });
  //       }
  //     } else if (uri.host == "addclicked") {
  //       showAddDialogAfterWidgetClick();
  //     }
  //   }
  //   HomeWidget.widgetClicked.listen((uri) async {
  //     if (uri != null) {
  //       if (uri.host == "cardclicked") {
  //         if (uri.queryParameters["uuid"] != null &&
  //             !taskchampion.value &&
  //             !taskReplica.value) {
  //           uuid.value = uri.queryParameters["uuid"] as String;
  //           isHomeWidgetTaskTapped.value = true;

  //           debugPrint('uuid is $uuid');
  //           Get.toNamed(Routes.DETAIL_ROUTE, arguments: ["uuid", uuid.value]);
  //         }
  //       } else if (uri.host == "addclicked") {
  //         showAddDialogAfterWidgetClick();
  //       }
  //     }
  //   });
  // }

  // void showAddDialogAfterWidgetClick() {
  //   Widget showDialog = Material(
  //       child: AddTaskBottomSheet(
  //           homeController: this,
  //           forTaskC: taskchampion.value,
  //           forReplica: taskReplica.value));
  //   Get.dialog(showDialog);
  // }
  @override
  void onClose() {
    searchFocusNode.dispose();
    super.onClose();
  }
}
