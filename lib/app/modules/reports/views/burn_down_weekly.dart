import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taskwarrior/app/models/chart.dart';
import 'package:taskwarrior/app/modules/reports/controllers/reports_controller.dart';
import 'package:taskwarrior/app/modules/reports/views/common_chart_indicator.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class BurnDownWeekly extends StatelessWidget {
  final ReportsController reportsController;
  const BurnDownWeekly({super.key, required this.reportsController});

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    var height = Get.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            height: height * 0.6,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                title: AxisTitle(
                    text: SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .reportsPageWeeklyWeeksYear,
                    textStyle: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontWeight: TaskWarriorFonts.bold,
                      fontSize: TaskWarriorFonts.fontSizeSmall,
                      color:
                          tColors.primaryTextColor,
                    )),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(
                    text: SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.reportsPageTasks,
                    textStyle: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontWeight: TaskWarriorFonts.bold,
                      fontSize: TaskWarriorFonts.fontSizeSmall,
                      color:
                          tColors.primaryTextColor,
                    )),
              ),
              tooltipBehavior: reportsController.weeklyBurndownTooltipBehaviour,
              series: <ChartSeries>[
                ///this is the completed tasks
                StackedColumnSeries<ChartData, String>(
                  groupName: 'Group A',
                  enableTooltip: true,
                  color: TaskWarriorColors.green,
                  dataSource: reportsController.allData
                      .map((task) => ChartData(
                            'Week ${Utils.getWeekNumbertoInt(task.entry)}, ${task.entry.year}',
                            reportsController.weeklyInfo[
                                        Utils.getWeekNumbertoInt(task.entry)]
                                    ?['pending'] ??
                                0,
                            reportsController.weeklyInfo[
                                        Utils.getWeekNumbertoInt(task.entry)]
                                    ?['completed'] ??
                                0,
                          ))
                      .toList(),
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y2,
                  name: 'Completed',
                ),

                ///this is the pending tasks
                StackedColumnSeries<ChartData, String>(
                  groupName: 'Group A',
                  color: TaskWarriorColors.yellow,
                  enableTooltip: true,
                  dataSource: reportsController.allData
                      .map((task) => ChartData(
                            'Week ${Utils.getWeekNumbertoInt(task.entry)}, ${task.entry.year}',
                            reportsController.weeklyInfo[
                                        Utils.getWeekNumbertoInt(task.entry)]
                                    ?['pending'] ??
                                0,
                            reportsController.weeklyInfo[
                                        Utils.getWeekNumbertoInt(task.entry)]
                                    ?['completed'] ??
                                0,
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
        CommonChartIndicator(
          title: SentenceManager(currentLanguage: AppSettings.selectedLanguage)
              .sentences
              .reportsPageWeeklyBurnDownChart,
        ),
      ],
    );
  }
}
