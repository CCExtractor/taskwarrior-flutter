// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';
import 'package:taskwarrior/controller/reports_tour_controller.dart';
import 'package:taskwarrior/model/json/task.dart';
import 'package:taskwarrior/model/storage.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/views/home/home.dart';
import 'package:taskwarrior/views/reports/pages/burndown_daily.dart';
import 'package:taskwarrior/views/reports/pages/burndown_monthly.dart';
import 'package:taskwarrior/views/reports/pages/burndown_weekly.dart';
import 'package:taskwarrior/views/reports/reports_tour.dart';
import 'package:taskwarrior/widgets/pallete.dart';
import 'package:taskwarrior/widgets/taskdetails/profiles_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ReportsHome extends StatefulWidget {
  const ReportsHome({
    super.key,
  });

  @override
  State<ReportsHome> createState() => _ReportsHomeState();
}

class _ReportsHomeState extends State<ReportsHome>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey daily = GlobalKey();
  final GlobalKey weekly = GlobalKey();
  final GlobalKey monthly = GlobalKey();

  bool isSaved = false;
  late TutorialCoachMark tutorialCoachMark;

  int _selectedIndex = 0;
  var storageWidget;
  late Storage storage;
  late final Filters filters;

  Directory? baseDirectory;
  List<Task> allData = [];

  void _initReportsTour() {
    tutorialCoachMark = TutorialCoachMark(
      targets: reportsDrawer(
        daily: daily,
        weekly: weekly,
        monthly: monthly,
      ),
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      hideSkip: true,
      onFinish: () {
        SaveReportsTour().saveReportsTourStatus();
      },
    );
  }

  void _showReportsTour() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        SaveReportsTour().getReportsTourStatus().then((value) => {
              if (value == false)
                {
                  tutorialCoachMark.show(context: context),
                }
              else
                {
                  // ignore: avoid_print
                  print('User has seen this page'),
                }
            });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initReportsTour();
    _showReportsTour();

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
        title: Text(
          'Reports',
          style: GoogleFonts.poppins(color: Colors.white),
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
            labelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
            ),
            onTap: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
            tabs: <Widget>[
              Tab(
                key: daily,
                icon: const Icon(Icons.schedule),
                text: 'Daily',
                iconMargin: const EdgeInsets.only(bottom: 0.0),
              ),
              Tab(
                key: weekly,
                icon: const Icon(Icons.today),
                text: 'Weekly',
                iconMargin: const EdgeInsets.only(bottom: 0.0),
              ),
              Tab(
                key: monthly,
                icon: const Icon(Icons.date_range),
                text: 'Monthly',
                iconMargin: const EdgeInsets.only(bottom: 0.0),
              ),
            ],
          ),
        ),
      ),
      backgroundColor:
          AppSettings.isDarkMode ? Palette.kToDark.shade200 : Colors.white,
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
                      style: GoogleFonts.poppins(
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
                      style: GoogleFonts.poppins(
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
            ),
    );
  }
}
