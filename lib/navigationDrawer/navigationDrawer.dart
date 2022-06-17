// ignore_for_file: override_on_non_overriding_member, prefer_const_constructors, file_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskwarrior/widgets/createDrawerHeader.dart';
import 'package:taskwarrior/widgets/createDrawerBodyItem.dart';
import 'package:taskwarrior/routes/pageroute.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NavigationDrawerState();
  }
}

class NavigationDrawerState extends State<NavigationDrawer> {
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
    return Drawer(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView(
        dragStartBehavior: DragStartBehavior.start,
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(),
          createDrawerBodyItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () =>
                Navigator.pushReplacementNamed(context, PageRoutes.home),
          ),
          Divider(),
        ],
      ),
    );
  }
}
