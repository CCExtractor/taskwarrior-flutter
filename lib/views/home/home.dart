// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/controller/home_tour_controller.dart';
import 'package:taskwarrior/drawer/filter_drawer.dart';
import 'package:taskwarrior/drawer/nav_drawer.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/taskserver/ntaskserver.dart';
import 'package:taskwarrior/views/home/home_tour.dart';
import 'package:taskwarrior/widgets/add_Task.dart';
import 'package:taskwarrior/widgets/buildTasks.dart';
import 'package:taskwarrior/widgets/pallete.dart';
import 'package:taskwarrior/widgets/tag_filter.dart';

import 'package:taskwarrior/model/storage.dart';

import 'package:taskwarrior/widgets/home_paths.dart' as rc;
import 'package:taskwarrior/widgets/taskserver.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Filters {
  const Filters({
    required this.pendingFilter,
    required this.togglePendingFilter,
    required this.tagFilters,
    required this.projects,
    required this.projectFilter,
    required this.toggleProjectFilter,
  });

  final bool pendingFilter;
  final void Function() togglePendingFilter;
  final TagFilters tagFilters;
  final dynamic projects;
  final String projectFilter;
  final void Function(String) toggleProjectFilter;
}

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final addKey = GlobalKey();
  final searchKey1 = GlobalKey();
  final searchKey2 = GlobalKey();
  final filterKey = GlobalKey();
  final menuKey = GlobalKey();
  final refreshKey = GlobalKey();

  bool isSaved = false;
  late TutorialCoachMark tutorialCoachMark;

  void _initInAppTour() {
    tutorialCoachMark = TutorialCoachMark(
        targets: addTargetsPage(
          addKey: addKey,
          searchKey: searchKey1,
          filterKey: filterKey,
          menuKey: menuKey,
          refreshKey: refreshKey,
        ),
        colorShadow: Colors.black,
        paddingFocus: 10,
        opacityShadow: 0.8,
        hideSkip: true,
        onFinish: () {
          SaveInAppTour().saveTourStatus();
        });
  }

  void _showInAppTour() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        SaveInAppTour().getTourStatus().then((value) => {
              if (value == false)
                {
                  tutorialCoachMark.show(context: context),
                }
              else
                {
                  // ignore: avoid_print
                  debugPrint('User has seen this page'),
                  // User has seen this page
                }
            });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initInAppTour();
    _showInAppTour();
  }

  late InheritedStorage storageWidget;
  late Storage storage;
  Server? server;
  Credentials? credentials;

  bool isTaskDServerActive = true;

  ///to check if the data is synced or not

  bool isSyncNeeded = false;

  ///call the synchronize function from storage_widget.dart
  ///to sync the data from the server
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    storage = StorageWidget.of(context).storage;

    ///didChangeDependencies loads after the initState
    ///it provides the context from the tree
    if (!isSyncNeeded) {
      ///check if the data is synced or not
      ///if not then sync the data
      isNeededtoSyncOnStart();
      isSyncNeeded = true;
    }
  }

  isNeededtoSyncOnStart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value;
    value = prefs.getBool('sync-onStart') ?? false;

    if (value) {
      storageWidget = StorageWidget.of(context);
      storageWidget.synchronize(context, false);
    } else {}
  }

  bool hideKey = true;

  @override
  Widget build(BuildContext context) {
    Server? server;
    Credentials? credentials;

    var contents = rc.Taskrc(storage.home.home).readTaskrc();
    if (contents != null) {
      server = Taskrc.fromString(contents).server;
      credentials = Taskrc.fromString(contents).credentials;
    }

    if (contents != null) {
      server = Taskrc.fromString(contents).server;
      credentials = Taskrc.fromString(contents).credentials;
    }

    var storageWidget = StorageWidget.of(context);
    var taskData = storageWidget.tasks;

    var pendingFilter = storageWidget.pendingFilter;
    var pendingTags = storageWidget.pendingTags;

    var selectedTagsMap = {
      for (var tag in storageWidget.selectedTags) tag.substring(1): tag,
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
      tagUnion: storageWidget.tagUnion,
      toggleTagUnion: storageWidget.toggleTagUnion,
      tags: tags,
      toggleTagFilter: storageWidget.toggleTagFilter,
    );
    var filters = Filters(
      pendingFilter: pendingFilter,
      togglePendingFilter: storageWidget.togglePendingFilter,
      projects: storageWidget.projects,
      projectFilter: storageWidget.projectFilter,
      toggleProjectFilter: storageWidget.toggleProjectFilter,
      tagFilters: tagFilters,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.kToDark.shade200,
        title:
            Text('Home Page', style: GoogleFonts.poppins(color: Colors.white)),
        actions: [
          IconButton(
            key: searchKey1,
            icon: (storageWidget.searchVisible)
                ? const Tooltip(
                    message: 'Cancel',
                    child: Icon(Icons.cancel, color: Colors.white))
                : const Tooltip(
                    message: 'Search',
                    child: Icon(Icons.search, color: Colors.white)),
            onPressed: storageWidget.toggleSearch,
          ),
          Builder(
            builder: (context) => IconButton(
              key: refreshKey,
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                if (server != null || credentials != null) {
                  storageWidget.synchronize(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('TaskServer is not configured'),
                      action: SnackBarAction(
                        label: 'Set Up',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ManageTaskServer(),
                              )).then((value) {
                            setState(() {});
                          });
                        },
                        textColor: Colors.purple,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              key: filterKey,
              icon: const Tooltip(
                message: 'Filters',
                child: Icon(Icons.filter_list, color: Colors.white),
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            key: menuKey,
            icon: const Tooltip(
                message: 'Menu', child: Icon(Icons.menu, color: Colors.white)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: NavDrawer(storageWidget: storageWidget, notifyParent: refresh),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(content: Text('Tap back again to exit')),
        child: Container(
          color:
              AppSettings.isDarkMode ? Palette.kToDark.shade200 : Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: <Widget>[
                if (storageWidget.searchVisible)
                  Container(
                    key: searchKey2,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: SearchBar(
                      controller: storageWidget.searchController,
                      // shape:,
                      onChanged: (value) {
                        storageWidget.search(value);
                      },

                      shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.focused)) {
                            return RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: const BorderSide(
                                  color: Colors.black, width: 2.0),
                            );
                          } else {
                            return RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: const BorderSide(
                                  color: Colors.black, width: 1.5),
                            );
                          }
                        },
                      ),
                      leading: const Icon(Icons.search_rounded),
                      trailing: <Widget>[
                        (storageWidget.searchController.text.isNotEmpty)
                            ? IconButton(
                                key: GlobalKey(),
                                icon: const Icon(Icons.cancel,
                                    color: Colors.black),
                                onPressed: () {
                                  storageWidget.searchController.clear();
                                  storageWidget.search(
                                      storageWidget.searchController.text);
                                },
                              )
                            : const SizedBox(
                                width: 0,
                                height: 0,
                              )
                      ],

                      hintText: 'Search',
                    ),
                  ),
                Expanded(
                  child: Scrollbar(
                    child: TasksBuilder(
                        // darkmode: AppSettings.isDarkMode,
                        taskData: taskData,
                        pendingFilter: pendingFilter,
                        searchVisible: storageWidget.searchVisible),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      endDrawer: FilterDrawer(filters),
      floatingActionButton: FloatingActionButton(
        key: addKey,
        heroTag: "btn3",
        backgroundColor:
            AppSettings.isDarkMode ? Colors.white : Palette.kToDark.shade200,
        child: Tooltip(
          message: 'Add Task',
          child: Icon(
            Icons.add,
            color: AppSettings.isDarkMode
                ? Palette.kToDark.shade200
                : Colors.white,
          ),
        ),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const AddTaskBottomSheet(),
        ).then((value) {
          // print(value);

          //if auto sync is turned on
          if (isSyncNeeded) {
            //if user have not created any event then
            //we won't call sync method
            if (value == "cancel") {
            } else {
              //else we can sync new tasks
              isNeededtoSyncOnStart();
            }
          }
        }),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  refresh() {
    setState(() {});
  }
}
