import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taskwarrior/app/models/chart.dart';
import 'package:taskwarrior/app/modules/reports/controllers/reports_controller.dart';
import 'package:taskwarrior/app/modules/reports/views/common_chart_indicator.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

class BurnDownDaily extends StatelessWidget {
  final ReportsController reportsController;
  const BurnDownDaily({super.key, required this.reportsController});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: height * 0.6,
                child: RepaintBoundary(
                  key: reportsController.chartKey,
                  child: Obx(
                    () => SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        title: AxisTitle(
                          text: SentenceManager(
                                  currentLanguage: AppSettings.selectedLanguage)
                              .sentences
                              .reportsPageDailyDayMonth,
                          textStyle: TextStyle(
                            fontFamily: FontFamily.poppins,
                            fontWeight: TaskWarriorFonts.bold,
                            color: AppSettings.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontSize: TaskWarriorFonts.fontSizeSmall,
                          ),
                        ),
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(
                          text: SentenceManager(
                                  currentLanguage: AppSettings.selectedLanguage)
                              .sentences
                              .reportsPageTasks,
                          textStyle: TextStyle(
                            fontFamily: FontFamily.poppins,
                            fontWeight: TaskWarriorFonts.bold,
                            color: AppSettings.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontSize: TaskWarriorFonts.fontSizeSmall,
                          ),
                        ),
                      ),
                      tooltipBehavior:
                          reportsController.dailyBurndownTooltipBehaviour,
                      series: <ChartSeries>[
                        /// This is the completed tasks
                        StackedColumnSeries<ChartData, String>(
                          groupName: 'Group A',
                          enableTooltip: true,
                          color: TaskWarriorColors.green,
                          dataSource: reportsController.dailyInfo.entries
                              .map((entry) => ChartData(
                                    entry.key,
                                    entry.value['pending'] ?? 0,
                                    entry.value['completed'] ?? 0,
                                  ))
                              .toList(),
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y2,
                          name: 'Completed',
                        ),

                        /// This is the pending tasks
                        StackedColumnSeries<ChartData, String>(
                          groupName: 'Group A',
                          color: TaskWarriorColors.yellow,
                          enableTooltip: true,
                          dataSource: reportsController.dailyInfo.entries
                              .map((entry) => ChartData(
                                    entry.key,
                                    entry.value['pending'] ?? 0,
                                    entry.value['completed'] ?? 0,
                                  ))
                              .toList(),
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y1,
                          name: 'Pending',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CommonChartIndicator(
              title:
                  SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .reportsPageDailyBurnDownChart,
            ),
          ],
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: InkWell(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                reportsController.captureChart();
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3), // Adjust opacity as needed
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
