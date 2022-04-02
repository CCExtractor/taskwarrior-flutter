// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, avoid_unnecessary_containers, unused_element, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taskwarrior/navigationDrawer/navigationDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/widgets/data_list.dart';
import 'package:taskwarrior/widgets/full_button.dart';
import 'package:taskwarrior/routes/pageroute.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences prefs;

  void loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Stack(children: [
        Stack(
          children: [
            // FutureBuilder(
            //   future: Future.wait([futuretask, futurehighprioritytask, futurelowprioritytask]),
            //   builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            //     if (snapshot.hasData) {
                  /*return*/ ListView(
                    children: [
                      ListTile(
                        title: Text(
                          'High Priority Tasks',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      DataList(
                        //items: snapshot.data![1].prioritytaskList,
                        type: 'highPriorityTasks',
                      ),
                      ListTile(
                        title: Text(
                          'Medium Priority Tasks',//default value for tasks priority
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      DataList(
                        //items: snapshot.data![0].taskList,
                        type: 'MediumPriorityTasks',
                      ),ListTile(
                        title: Text(
                          'Low Priority Tasks',//default value for tasks priority
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      DataList(
                        //items: snapshot.data![2].latertaskList,
                        type: 'lowPriorityTasks',
                      )
                    ],
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                  )
                // } else if (snapshot.hasError) {
                //   return Text("${snapshot.error}");
                // }
                
                //return CircularProgressIndicator();
          ],
        ),
      ]),
      drawer: NavigationDrawer(),
      resizeToAvoidBottomInset: false,
    );
  }
}
