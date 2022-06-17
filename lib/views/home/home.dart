// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, avoid_unnecessary_containers, unused_element, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskwarrior/model/task.dart';
import 'package:taskwarrior/navigationDrawer/navigationDrawer.dart';
import 'package:taskwarrior/services/addTask_service.dart';
import 'package:taskwarrior/widgets/boxes.dart';
import 'package:taskwarrior/widgets/buildContent.dart';
import 'package:taskwarrior/widgets/taskdialog.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    Hive.box('tasks').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      // body: Stack(children: [
      //   Stack(
      //     children: [
      //       // FutureBuilder(
      //       //   future: Future.wait([futuretask, futurehighprioritytask, futurelowprioritytask]),
      //       //   builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
      //       //     if (snapshot.hasData) {
      //       /*return*/ ListView(
      //         children: [
      //           ListTile(
      //             title: Text(
      //               'High Priority Tasks',
      //               textAlign: TextAlign.center,
      //               style: const TextStyle(
      //                   fontWeight: FontWeight.bold, fontSize: 30),
      //             ),
      //           ),
      //           DataList(
      //             //items: snapshot.data![1].prioritytaskList,
      //             type: 'highPriorityTasks',
      //           ),
      //           ListTile(
      //             title: Text(
      //               'Medium Priority Tasks', //default value for tasks priority
      //               textAlign: TextAlign.center,
      //               style: const TextStyle(
      //                   fontWeight: FontWeight.bold, fontSize: 30),
      //             ),
      //           ),
      //           DataList(
      //             //items: snapshot.data![0].taskList,
      //             type: 'MediumPriorityTasks',
      //           ),
      //           ListTile(
      //             title: Text(
      //               'Low Priority Tasks', //default value for tasks priority
      //               textAlign: TextAlign.center,
      //               style: const TextStyle(
      //                   fontWeight: FontWeight.bold, fontSize: 30),
      //             ),
      //           ),
      //           DataList(
      //             //items: snapshot.data![2].latertaskList,
      //             type: 'lowPriorityTasks',
      //           )
      //         ],
      //         scrollDirection: Axis.vertical,
      //         shrinkWrap: true,
      //       )
      //       // } else if (snapshot.hasError) {
      //       //   return Text("${snapshot.error}");
      //       // }

      //       //return CircularProgressIndicator();
      //     ],
      //   ),
      // ]),
      body: ValueListenableBuilder<Box<Task>>(
        valueListenable: Boxes.getTasks().listenable(),
        builder: (context, box, _) {
          final task = box.values.toList().cast<Task>();

          return buildContent(task);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => TaskDialog(
            onClickedDone: addTask,
          ),
        ),
      ),
      drawer: NavigationDrawer(),
      resizeToAvoidBottomInset: false,
    );
  }
}
