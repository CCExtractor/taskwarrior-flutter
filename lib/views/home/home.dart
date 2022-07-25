// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, avoid_unnecessary_containers, unused_element, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:taskwarrior/drawer/sortdrawer.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/drawer/navigationDrawer.dart';
import 'package:taskwarrior/widgets/addTask.dart';
import 'package:taskwarrior/widgets/buildTasks.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var storageWidget = StorageWidget.of(context);
    var taskData = storageWidget.tasks;
    var pendingFilter = storageWidget.pendingFilter;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          //SortDrawer(),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              showModalBottomSheet(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.2,
                ),
                context: context,
                builder: (context) => SortDrawer(),
              );
            },
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: TasksBuilder(
                taskData: taskData,
                pendingFilter: pendingFilter,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const AddTaskBottomSheet(),
        ),
      ),
      drawer: NavigationDrawer(),
      resizeToAvoidBottomInset: false,
    );
  }
}
