// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, avoid_unnecessary_containers, unused_element, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:taskwarrior/drawer/filter_drawer.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/routes/pageroute.dart';
import 'package:taskwarrior/widgets/addTask.dart';
import 'package:taskwarrior/widgets/buildTasks.dart';
import 'package:taskwarrior/widgets/pallete.dart';
import 'package:taskwarrior/widgets/tag_filter.dart';

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
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static bool _darkmode =
      SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
  @override
  Widget build(BuildContext context) {
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
        title: Text('Home Page', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
          icon: (storageWidget.searchVisible)
              ? const Icon(Icons.cancel, color: Colors.white)
              : const Icon(Icons.search, color: Colors.white),
          onPressed: storageWidget.toggleSearch,
          ),
          // Builder(
          //   builder: (context) => IconButton(
          //     icon: const Icon(Icons.refresh, color: Colors.white),
          //     onPressed: () => storageWidget.synchronize(context),
          //   ),
          // ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: _darkmode?Colors.black:Colors.white,
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            tileColor: _darkmode?Colors.black:Colors.white,
            textColor: _darkmode?Colors.white:Colors.black,
            contentPadding: EdgeInsets.only(top: 40, left: 10),
            title: const Text(
              'Menu',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            tileColor: _darkmode?Colors.black:Colors.white,
            textColor: _darkmode?Colors.white:Colors.black,
            leading: Icon(Icons.person_rounded, color: _darkmode?Colors.white:Colors.black,),
            title: const Text('Profile'),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.pushNamed(context, PageRoutes.profile);
              // Then close the drawer
              // Navigator.pop(context);
            },
          ),
          ListTile(
            tileColor: _darkmode?Colors.black:Colors.white,
            textColor: _darkmode?Colors.white:Colors.black,
            leading: Icon(Icons.refresh, color: _darkmode?Colors.white:Colors.black,),
            onTap: () {
              storageWidget.synchronize(context);
              Navigator.pop(context);
            },
            title: Text("Refresh"),
          ),
          ListTile(
            tileColor: _darkmode?Colors.black:Colors.white,
            textColor: _darkmode?Colors.white:Colors.black,
            leading: _darkmode
                ? const Icon(
                    Icons.light_mode,
                    color: Color.fromARGB(255, 216, 196, 15),
                    size: 25,
                  )
                : const Icon(
                    Icons.dark_mode,
                    color: Colors.black,
                    size: 25,
                  ),
            title: Text("Switch Theme"),
            onTap: () {
              if (_darkmode) {
                _darkmode = false;
              } else {
                _darkmode = true;
              }
              setState(() {});
              Navigator.pop(context);
            },
          )
        ],
      )),
      body: Container(
        color: _darkmode ? Palette.kToDark.shade200 : Colors.white,
        child: Column(
          children: <Widget>[
            if (storageWidget.searchVisible)
              Card(
                child: TextField(
                  autofocus: true,
                  onChanged: (value) {
                    storageWidget.search(value);
                  },
                  controller: storageWidget.searchController,
                ),
              ),
            Expanded(
              child: Scrollbar(
                child: TasksBuilder(
                  darkmode: _darkmode,
                  taskData: taskData,
                  pendingFilter: pendingFilter,
                ),
              ),
            ),
          ],
        ),
      ),
      endDrawer: FilterDrawer(filters),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const AddTaskBottomSheet(),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
