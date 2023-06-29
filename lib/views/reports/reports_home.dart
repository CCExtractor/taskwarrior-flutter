// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';
import 'package:taskwarrior/model/json/task.dart';
import 'package:taskwarrior/model/storage.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/views/home/home.dart';
import 'package:taskwarrior/views/reports/pages/burndown_daily.dart';
import 'package:taskwarrior/views/reports/pages/burndown_monthly.dart';
import 'package:taskwarrior/views/reports/pages/burndown_weekly.dart';
import 'package:taskwarrior/widgets/pallete.dart';
import 'package:taskwarrior/widgets/taskdetails/profiles_widget.dart';
import 'package:path_provider/path_provider.dart';

class ReportsHome extends StatefulWidget {
  const ReportsHome({
    Key? key,
  }) : super(key: key);

  @override
  State<ReportsHome> createState() => _ReportsHomeState();
}

class _ReportsHomeState extends State<ReportsHome>
    with TickerProviderStateMixin {
  late TabController _tabController;

  int _selectedIndex = 0;
  var storageWidget;
  late Storage storage;
  late final Filters filters;

  Directory? baseDirectory;
  List<Task> allData = [];
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    ///initialize the storage widget
    Future.delayed(Duration.zero, () {
      storageWidget = StorageWidget.of(context);
      var currentProfile = ProfilesWidget.of(context).currentProfile;

      getApplicationDocumentsDirectory().then((directory) {
        setState(() {
          baseDirectory = directory;
          storage = Storage(
            Directory('${baseDirectory!.path}/profiles/$currentProfile'),
          );
        });

        ///fetch all data contains all the tasks
        allData = storage.data.allData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // Screen height
    // double width = MediaQuery.of(context).size.width; // Screen width

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.kToDark.shade200,
          title: const Text(
            'Reports',
            style: TextStyle(color: Colors.white),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left,
              color: Appcolors.white,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(
                height * 0.1), // Adjust the preferred height as needed
            child: TabBar(
              controller: _tabController,
              labelColor: Appcolors.white,
              labelStyle: GoogleFonts.firaMono(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              unselectedLabelStyle: GoogleFonts.firaMono(
                fontWeight: FontWeight.w300,
              ),
              onTap: (value) {
                setState(() {
                  _selectedIndex = value;
                });
              },
              tabs: const <Widget>[
                Tab(
                  icon: Icon(Icons.schedule),
                  text: 'Daily',
                  iconMargin: EdgeInsets.only(bottom: 0.0),
                ),
                Tab(
                  icon: Icon(Icons.today),
                  text: 'Weekly',
                  iconMargin: EdgeInsets.only(bottom: 0.0),
                ),
                Tab(
                  icon: Icon(Icons.date_range),
                  text: 'Monthly',
                  iconMargin: EdgeInsets.only(bottom: 0.0),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: AppSettings.isDarkMode ? Colors.black : Colors.white,
        body: allData.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.heart_broken,
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No Task found',
                        style: GoogleFonts.firaMono(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AppSettings.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add a task to see reports',
                        style: GoogleFonts.firaMono(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AppSettings.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : IndexedStack(
                index: _selectedIndex,
                children: const [
                  BurnDownDaily(),
                  BurnDownWeekly(),
                  BurnDownMonthlt(),
                ],
              ));
  }
}
