import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:taskwarrior/app/models/filters.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/home/views/project_column_home_page.dart';
import 'package:taskwarrior/app/services/tag_filter.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

class FilterDrawer extends StatelessWidget {
  final Filters filters;
  final HomeController homeController;

  const FilterDrawer(
      {required this.filters, required this.homeController, super.key});

  @override
  Widget build(BuildContext context) {
    var tileColor = AppSettings.isDarkMode
        ? TaskWarriorColors.ksecondaryBackgroundColor
        : TaskWarriorColors.kLightPrimaryBackgroundColor;
    return Drawer(
      backgroundColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.kLightPrimaryBackgroundColor,
      surfaceTintColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.kLightPrimaryBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView(
            primary: false,
            key: const PageStorageKey('tags-filter'),
            children: [
              const Divider(
                color: Color.fromARGB(0, 48, 46, 46),
              ),
              Container(
                height: 45,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Text(
                    'Apply Filters',
                    // style: GoogleFonts.poppins(
                    //     fontWeight: TaskWarriorFonts.bold,
                    //     color: (AppSettings.isDarkMode
                    //         ? TaskWarriorColors.kprimaryTextColor
                    //         : TaskWarriorColors.kLightPrimaryTextColor),
                    //     fontSize: TaskWarriorFonts.fontSizeExtraLarge),
                    style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontWeight: TaskWarriorFonts.bold,
                      color: (AppSettings.isDarkMode
                          ? TaskWarriorColors.kprimaryTextColor
                          : TaskWarriorColors.kLightPrimaryTextColor),
                      fontSize: TaskWarriorFonts.fontSizeExtraLarge,
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Color.fromARGB(0, 48, 46, 46),
              ),
              Container(
                // width: MediaQuery.of(context).size.width * 1,
                // padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: TaskWarriorColors.borderColor),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.only(
                    left: 8,
                  ),
                  title: RichText(
                    // key: statusKey,
                    maxLines: 2,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Status : ',
                            // style: GoogleFonts.poppins(
                            //   fontWeight: TaskWarriorFonts.bold,
                            //   fontSize: TaskWarriorFonts.fontSizeMedium,
                            //   color: AppSettings.isDarkMode ? TaskWarriorColors.white : TaskWarriorColors.black,
                            // ),
                            style: TextStyle(
                              fontFamily: FontFamily.poppins,
                              fontSize: TaskWarriorFonts.fontSizeMedium,
                              color: AppSettings.isDarkMode
                                  ? TaskWarriorColors.white
                                  : TaskWarriorColors.black,
                            )),
                        TextSpan(
                            text:
                                filters.pendingFilter ? 'pending' : 'completed',
                            // style: GoogleFonts.poppins(
                            //   fontSize: TaskWarriorFonts.fontSizeMedium,
                            //   color: AppSettings.isDarkMode ? TaskWarriorColors.white : TaskWarriorColors.black,
                            // ),
                            style: TextStyle(
                              fontFamily: FontFamily.poppins,
                              fontSize: TaskWarriorFonts.fontSizeMedium,
                              color: AppSettings.isDarkMode
                                  ? TaskWarriorColors.white
                                  : TaskWarriorColors.black,
                            )),
                      ],
                    ),
                  ),
                  onTap: filters.togglePendingFilter,
                  textColor: AppSettings.isDarkMode
                      ? TaskWarriorColors.kprimaryTextColor
                      : TaskWarriorColors.kLightSecondaryTextColor,
                ),
              ),
              const Divider(
                color: Color.fromARGB(0, 48, 46, 46),
              ),
              Container(
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: TaskWarriorColors.borderColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: filters.toggleWaitingFilter,
                    child: Text(
                        filters.waitingFilter ? 'Show waiting' : 'Hide waiting',
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontSize: TaskWarriorFonts.fontSizeMedium,
                          color: AppSettings.isDarkMode
                              ? TaskWarriorColors.kprimaryTextColor
                              : TaskWarriorColors.kLightSecondaryTextColor,
                        )),
                  ),
                ),
              ),
              const Divider(
                color: Color.fromARGB(0, 48, 46, 46),
              ),
              Container(
                // key: projectsKey,
                width: MediaQuery.of(context).size.width * 1,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: TaskWarriorColors.borderColor,
                  ),
                ),
                child: ProjectsColumn(
                  projects: filters.projects,
                  projectFilter: filters.projectFilter,
                  callback: filters.toggleProjectFilter,
                ),
              ),
              const Divider(
                color: Color.fromARGB(0, 48, 46, 46),
              ),
              Container(
                // key: filterTagKey,
                width: MediaQuery.of(context).size.width * 1,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: TaskWarriorColors.borderColor),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(
                      color: Color.fromARGB(0, 48, 46, 46),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Text(
                        'Filter Tag By:',
                        // style: GoogleFonts.poppins(
                        //     color: (AppSettings.isDarkMode
                        //         ? TaskWarriorColors.kprimaryTextColor
                        //         : TaskWarriorColors.kLightSecondaryTextColor),
                        //     //
                        //     fontSize: TaskWarriorFonts.fontSizeLarge),
                        //textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontSize: TaskWarriorFonts.fontSizeMedium,
                          color: AppSettings.isDarkMode
                              ? TaskWarriorColors.kprimaryTextColor
                              : TaskWarriorColors.kLightSecondaryTextColor,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Color.fromARGB(0, 48, 46, 46),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TagFiltersWrap(filters.tagFilters),
                    ),
                    const Divider(
                      color: Color.fromARGB(0, 48, 46, 46),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Color.fromARGB(0, 48, 46, 46),
              ),
              Container(
                // key: sortByKey,
                width: MediaQuery.of(context).size.width * 1,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: TaskWarriorColors.borderColor),
                ),
                //height: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(
                      color: Color.fromARGB(0, 48, 46, 46),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Text('Sort By',
                          // style: GoogleFonts.poppins(
                          //     color: (AppSettings.isDarkMode
                          //         ? TaskWarriorColors.kprimaryTextColor
                          //         : TaskWarriorColors.kLightPrimaryTextColor),
                          //     fontSize: TaskWarriorFonts.fontSizeLarge),
                          // textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: FontFamily.poppins,
                            fontSize: TaskWarriorFonts.fontSizeMedium,
                            color: AppSettings.isDarkMode
                                ? TaskWarriorColors.white
                                : TaskWarriorColors.black,
                          )),
                    ),
                    const Divider(
                      color: Color.fromARGB(0, 48, 46, 46),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          for (var sort in [
                            'Created',
                            'Modified',
                            'Start Time',
                            'Due till',
                            'Priority',
                            'Project',
                            'Tags',
                            'Urgency',
                          ])
                            Obx(
                              () => ChoiceChip(
                                label: (homeController.selectedSort.value
                                        .startsWith(sort))
                                    ? Text(
                                        homeController.selectedSort.value,
                                      )
                                    : Text(sort),
                                selected: false,
                                onSelected: (_) {
                                  if (homeController.selectedSort == '$sort+') {
                                    homeController.selectSort('$sort-');
                                  } else if (homeController.selectedSort ==
                                      '$sort-') {
                                    homeController.selectSort(sort);
                                  } else {
                                    homeController.selectSort('$sort+');
                                  }
                                },
                                // labelStyle: GoogleFonts.poppins(
                                //     color: AppSettings.isDarkMode
                                //         ? TaskWarriorColors.black
                                //         : TaskWarriorColors.white),
                                // backgroundColor: AppSettings.isDarkMode
                                //     ? TaskWarriorColors
                                //         .kLightSecondaryBackgroundColor
                                //     : TaskWarriorColors.ksecondaryBackgroundColor,
                              ),
                            )
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color.fromARGB(0, 48, 46, 46),
                    ),
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // color: AppSettings.isDarkMode
                        //     ? TaskWarriorColors.kLightSecondaryBackgroundColor
                        //     : TaskWarriorColors.ksecondaryBackgroundColor,
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (homeController.selectedSort.value.endsWith('+') ||
                              homeController.selectedSort.value.endsWith('-')) {
                            homeController.selectSort(
                                homeController.selectedSort.value.substring(
                                    0,
                                    homeController.selectedSort.value.length -
                                        1));
                          }
                        },
                        child: Text('Reset Sort',
                            // style: GoogleFonts.poppins(
                            //     fontSize: TaskWarriorFonts.fontSizeMedium,
                            //     color: AppSettings.isDarkMode
                            //         ? TaskWarriorColors.kLightSecondaryTextColor
                            //         : TaskWarriorColors.ksecondaryTextColor),
                            style: TextStyle(
                              fontFamily: FontFamily.poppins,
                              fontSize: TaskWarriorFonts.fontSizeMedium,
                              color: AppSettings.isDarkMode
                                  ? TaskWarriorColors.white
                                  : TaskWarriorColors.black,
                            )),
                      ),
                    ),
                    const Divider(
                      color: Color.fromARGB(0, 48, 46, 46),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
