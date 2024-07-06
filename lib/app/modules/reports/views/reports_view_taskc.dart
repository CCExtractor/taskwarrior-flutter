import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/api_service.dart';
import 'package:taskwarrior/app/modules/reports/controllers/reports_controller.dart';
import 'package:taskwarrior/app/modules/reports/views/burn_down_daily_taskc.dart';
import 'package:taskwarrior/app/modules/reports/views/burn_down_monthly_taskc.dart';
import 'package:taskwarrior/app/modules/reports/views/burn_down_weekly_taskc.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ReportsHomeTaskc extends StatefulWidget {
  const ReportsHomeTaskc({
    super.key,
  });

  @override
  State<ReportsHomeTaskc> createState() => _ReportsHomeTaskcState();
}

class _ReportsHomeTaskcState extends State<ReportsHomeTaskc>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey daily = GlobalKey();
  final GlobalKey weekly = GlobalKey();
  final GlobalKey monthly = GlobalKey();

  bool isSaved = false;
  late TutorialCoachMark tutorialCoachMark;
  late ReportsController reportsController;
  int _selectedIndex = 0;
  late TaskDatabase taskDatabase;
  List<Tasks> allTasks = [];

  @override
  void initState() {
    super.initState();
    reportsController = Get.find<ReportsController>();
    reportsController.initReportsTour();
    reportsController.showReportsTour(context);
    _tabController = TabController(length: 3, vsync: this);

    // Initialize the database and fetch data
    taskDatabase = TaskDatabase();
    taskDatabase.open().then((_) {
      taskDatabase.fetchTasksFromDatabase().then((tasks) {
        setState(() {
          allTasks = tasks;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // Screen height

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
        title: Text(
          'Reports',
          style: GoogleFonts.poppins(color: TaskWarriorColors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            color: TaskWarriorColors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
              height * 0.1), // Adjust the preferred height as needed
          child: TabBar(
            controller: _tabController,
            labelColor: TaskWarriorColors.white,
            labelStyle: GoogleFonts.poppins(
              fontWeight: TaskWarriorFonts.medium,
              fontSize: TaskWarriorFonts.fontSizeSmall,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: TaskWarriorFonts.light,
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
      backgroundColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.white,
      body: allTasks.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.heart_broken,
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No Task found',
                      style: GoogleFonts.poppins(
                        fontWeight: TaskWarriorFonts.medium,
                        fontSize: TaskWarriorFonts.fontSizeSmall,
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.white
                            : TaskWarriorColors.black,
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
                        fontWeight: TaskWarriorFonts.light,
                        fontSize: TaskWarriorFonts.fontSizeSmall,
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.white
                            : TaskWarriorColors.black,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : IndexedStack(
              index: _selectedIndex,
              children: const [
                BurnDownDailyTaskc(),
                BurnDownWeeklyTask(),
                BurnDownMonthlyTaskc(),
              ],
            ),
    );
  }
}
