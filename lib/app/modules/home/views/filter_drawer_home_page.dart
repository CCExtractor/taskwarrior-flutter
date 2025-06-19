// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:taskwarrior/app/models/filters.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/home/views/project_column_home_page.dart';
import 'package:taskwarrior/app/modules/home/views/project_column_taskc.dart';
import 'package:taskwarrior/app/services/tag_filter.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class FilterDrawer extends StatelessWidget {
  final Filters filters;
  final HomeController homeController;
  const FilterDrawer(
      {required this.filters, required this.homeController, super.key});

  @override
  Widget build(BuildContext context) {
    homeController.initFilterDrawerTour();
    homeController.showFilterDrawerTour(context);
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    var tileColor = AppSettings.isDarkMode
        ? TaskWarriorColors.ksecondaryBackgroundColor
        : TaskWarriorColors.kLightPrimaryBackgroundColor;
    return Drawer(
      backgroundColor: tColors.dialogBackgroundColor,
      surfaceTintColor: tColors.primaryBackgroundColor,
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
                    SentenceManager(
                            currentLanguage:
                                homeController.selectedLanguage.value)
                        .sentences
                        .filterDrawerApplyFilters,
                    // style: GoogleFonts.poppins(
                    //     fontWeight: TaskWarriorFonts.bold,
                    //     color: (AppSettings.isDarkMode
                    //         ? TaskWarriorColors.kprimaryTextColor
                    //         : TaskWarriorColors.kLightPrimaryTextColor),
                    //     fontSize: TaskWarriorFonts.fontSizeExtraLarge),
                    style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontWeight: TaskWarriorFonts.bold,
                      color: tColors.primaryTextColor,
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
                    key: homeController.statusKey,
                    maxLines: 2,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                '${SentenceManager(currentLanguage: homeController.selectedLanguage.value).sentences.filterDrawerStatus} : ',
                            style: TextStyle(
                              fontFamily: FontFamily.poppins,
                              fontSize: TaskWarriorFonts.fontSizeMedium,
                              color: tColors.primaryTextColor,
                            )),
                        TextSpan(
                            text: filters.pendingFilter
                                ? SentenceManager(
                                        currentLanguage: homeController
                                            .selectedLanguage.value)
                                    .sentences
                                    .filterDrawerPending
                                : SentenceManager(
                                        currentLanguage: homeController
                                            .selectedLanguage.value)
                                    .sentences
                                    .filterDrawerCompleted,
                            style: TextStyle(
                              fontFamily: FontFamily.poppins,
                              fontSize: TaskWarriorFonts.fontSizeMedium,
                              color: tColors.primaryTextColor,
                            )),
                      ],
                    ),
                  ),
                  onTap: filters.togglePendingFilter,
                  textColor: tColors.primaryTextColor,
                ),
              ),
              const Divider(
                color: Color.fromARGB(0, 48, 46, 46),
              ),
              Container(
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: TaskWarriorColors.borderColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          !filters.waitingFilter
                              ? SentenceManager(
                                      currentLanguage:
                                          homeController.selectedLanguage.value)
                                  .sentences
                                  .filterDrawerShowWaiting
                              : SentenceManager(
                                      currentLanguage:
                                          homeController.selectedLanguage.value)
                                  .sentences
                                  .filterDrawerHideWaiting,
                          style: TextStyle(
                            fontFamily: FontFamily.poppins,
                            fontSize: TaskWarriorFonts.fontSizeMedium,
                            color: tColors.primaryTextColor,
                          )),
                      Switch(
                        value: filters.waitingFilter,
                        onChanged: (_) => filters.toggleWaitingFilter(),
                      )
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Color.fromARGB(0, 48, 46, 46),
              ),
              Visibility(
                visible: !homeController.taskchampion.value,
                child: Container(
                  key: homeController.projectsKey,
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
              ),
              Visibility(
                visible: homeController.taskchampion.value,
                child: FutureBuilder<List<String>>(
                  future: homeController.getUniqueProjects(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        key: homeController.projectsKeyTaskc,
                        width: MediaQuery.of(context).size.width * 1,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: tileColor,
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: TaskWarriorColors.borderColor),
                        ),
                        child: ProjectColumnTaskc(
                          callback: filters.toggleProjectFilter,
                          projects: snapshot.data!,
                          projectFilter: filters.projectFilter,
                        ),
                      );
                    } else {
                      return const Center(
                          child: Text('No projects available.'));
                    }
                  },
                ),
              ),
              const Divider(
                color: Color.fromARGB(0, 48, 46, 46),
              ),
              Visibility(
                visible: !homeController.taskchampion.value,
                child: Container(
                  key: homeController.filterTagKey,
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
                          SentenceManager(
                                  currentLanguage:
                                      homeController.selectedLanguage.value)
                              .sentences
                              .filterDrawerFilterTagBy,
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
                            color: tColors.primaryTextColor,
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
              ),
              Visibility(
                visible: !homeController.taskchampion.value,
                child: const Divider(
                  color: Color.fromARGB(0, 48, 46, 46),
                ),
              ),
              Container(
                key: homeController.sortByKey,
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
                      child: Text(
                          SentenceManager(
                                  currentLanguage:
                                      homeController.selectedLanguage.value)
                              .sentences
                              .filterDrawerSortBy,
                          // style: GoogleFonts.poppins(
                          //     color: (AppSettings.isDarkMode
                          //         ? TaskWarriorColors.kprimaryTextColor
                          //         : TaskWarriorColors.kLightPrimaryTextColor),
                          //     fontSize: TaskWarriorFonts.fontSizeLarge),
                          // textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: FontFamily.poppins,
                            fontSize: TaskWarriorFonts.fontSizeMedium,
                            color: tColors.primaryTextColor,
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
                            SentenceManager(
                                    currentLanguage:
                                        homeController.selectedLanguage.value)
                                .sentences
                                .filterDrawerCreated,
                            SentenceManager(
                                    currentLanguage:
                                        homeController.selectedLanguage.value)
                                .sentences
                                .filterDrawerModified,
                            SentenceManager(
                                    currentLanguage:
                                        homeController.selectedLanguage.value)
                                .sentences
                                .filterDrawerStartTime,
                            SentenceManager(
                                    currentLanguage:
                                        homeController.selectedLanguage.value)
                                .sentences
                                .filterDrawerDueTill,
                            SentenceManager(
                                    currentLanguage:
                                        homeController.selectedLanguage.value)
                                .sentences
                                .filterDrawerPriority,
                            SentenceManager(
                                    currentLanguage:
                                        homeController.selectedLanguage.value)
                                .sentences
                                .filterDrawerProject,
                            SentenceManager(
                                    currentLanguage:
                                        homeController.selectedLanguage.value)
                                .sentences
                                .filterDrawerTags,
                            SentenceManager(
                                    currentLanguage:
                                        homeController.selectedLanguage.value)
                                .sentences
                                .filterDrawerUrgency,
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
                        child: Text(
                            SentenceManager(
                                    currentLanguage:
                                        homeController.selectedLanguage.value)
                                .sentences
                                .filterDrawerResetSort,
                            // style: GoogleFonts.poppins(
                            //     fontSize: TaskWarriorFonts.fontSizeMedium,
                            //     color: AppSettings.isDarkMode
                            //         ? TaskWarriorColors.kLightSecondaryTextColor
                            //         : TaskWarriorColors.ksecondaryTextColor),
                            style: TextStyle(
                              fontFamily: FontFamily.poppins,
                              fontSize: TaskWarriorFonts.fontSizeMedium,
                              color: tColors.primaryTextColor,
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
