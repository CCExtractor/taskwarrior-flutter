import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taskwarrior/app/models/chart.dart';
import 'package:taskwarrior/app/modules/reports/controllers/reports_controller.dart';
import 'package:taskwarrior/app/modules/reports/views/common_chart_indicator.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

class BurnDownMonthly extends StatelessWidget {
  final ReportsController reportsController;
  const BurnDownMonthly({super.key, required this.reportsController});

  @override
  Widget build(BuildContext context) {
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
                        .reportsPageMonthlyMonthYear,
                    textStyle: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontWeight: TaskWarriorFonts.bold,
                      fontSize: TaskWarriorFonts.fontSizeSmall,
                      color:
                          AppSettings.isDarkMode ? Colors.white : Colors.black,
                    )),
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
                      fontSize: TaskWarriorFonts.fontSizeSmall,
                      color:
                          AppSettings.isDarkMode ? Colors.white : Colors.black,
                    )),
              ),
              tooltipBehavior:
                  reportsController.monthlyBurndownTooltipBehaviour,
              series: <ChartSeries>[
                StackedColumnSeries<ChartData, String>(
                  groupName: 'Group A',
                  enableTooltip: true,
                  color: Colors.green,
                  dataSource: reportsController.monthlyInfo.entries
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
                StackedColumnSeries<ChartData, String>(
                  groupName: 'Group A',
                  color: Colors.yellow,
                  enableTooltip: true,
                  dataSource: reportsController.monthlyInfo.entries
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
        CommonChartIndicator(
          title: SentenceManager(currentLanguage: AppSettings.selectedLanguage)
              .sentences
              .reportsPageMonthlyBurnDownChart,
        ),
      ],
    );
  }
}
