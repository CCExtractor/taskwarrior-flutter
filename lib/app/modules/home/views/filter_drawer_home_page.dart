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
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
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
              Visibility(
                visible: !homeController.taskReplica.value,
                child: Container(
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
                                        currentLanguage: homeController
                                            .selectedLanguage.value)
                                    .sentences
                                    .filterDrawerShowWaiting
                                : SentenceManager(
                                        currentLanguage: homeController
                                            .selectedLanguage.value)
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
              ),
              const Divider(
                color: Color.fromARGB(0, 48, 46, 46),
              ),
              Visibility(
                visible: !homeController.taskchampion.value &&
                    !homeController.taskReplica.value,
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
                visible: homeController.taskchampion.value ||
                    homeController.taskReplica.value,
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
                      return Center(
                          child: Text(SentenceManager(
                                  currentLanguage:
                                      homeController.selectedLanguage.value)
                              .sentences
                              .filterDrawerNoProjectsAvailable));
                    }
                  },
                ),
              ),
              const Divider(
                color: Color.fromARGB(0, 48, 46, 46),
              ),
              Visibility(
                visible: !homeController.taskchampion.value &&
                    !homeController.taskReplica.value,
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
                visible: !homeController.taskchampion.value &&
                    !homeController.taskReplica.value,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Text(
                          SentenceManager(
                                  currentLanguage:
                                      homeController.selectedLanguage.value)
                              .sentences
                              .filterDrawerSortBy,
                          style: TextStyle(
                            fontFamily: FontFamily.poppins,
                            fontSize: TaskWarriorFonts.fontSizeMedium,
                            color: tColors.primaryTextColor,
                          )),
                    ),
                    const SizedBox(height: 12),
                    // Dropdown and toggle switch row
                    Obx(() {
                      final sortOptions = [
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
                      ];

                      // Extract current sort category and order from selectedSort
                      String currentSort = homeController.selectedSort.value;
                      String? selectedCategory;
                      bool isAscending = false;

                      if (currentSort.isNotEmpty) {
                        if (currentSort.endsWith('+')) {
                          selectedCategory =
                              currentSort.substring(0, currentSort.length - 1);
                          isAscending = true;
                        } else if (currentSort.endsWith('-')) {
                          selectedCategory =
                              currentSort.substring(0, currentSort.length - 1);
                          isAscending = false;
                        } else {
                          selectedCategory = currentSort;
                        }
                      }

                      // Validate selectedCategory is in sortOptions
                      if (selectedCategory != null &&
                          !sortOptions.contains(selectedCategory)) {
                        selectedCategory = null;
                      }

                      return Row(
                        children: [
                          // Dropdown
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: TaskWarriorColors.borderColor),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedCategory,
                                  hint: Text(
                                    SentenceManager(
                                            currentLanguage: homeController
                                                .selectedLanguage.value)
                                        .sentences
                                        .filterDrawerSortBy,
                                    style: TextStyle(
                                      fontFamily: FontFamily.poppins,
                                      fontSize: TaskWarriorFonts.fontSizeSmall,
                                      color: tColors.primaryTextColor,
                                    ),
                                  ),
                                  dropdownColor: tileColor,
                                  style: TextStyle(
                                    fontFamily: FontFamily.poppins,
                                    fontSize: TaskWarriorFonts.fontSizeSmall,
                                    color: tColors.primaryTextColor,
                                  ),
                                  items: sortOptions.map((String option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(option),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      // Default to ascending when selecting a new category
                                      homeController.selectSort('$newValue+');
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Toggle switch with + and - labels
                          Row(
                            children: [
                              Text(
                                '+',
                                style: TextStyle(
                                  fontFamily: FontFamily.poppins,
                                  fontSize: TaskWarriorFonts.fontSizeMedium,
                                  fontWeight: FontWeight.bold,
                                  color: tColors.primaryTextColor,
                                ),
                              ),
                              Switch(
                                value: !isAscending,
                                onChanged: selectedCategory != null
                                    ? (bool value) {
                                        if (value) {
                                          // Switch to descending (-)
                                          homeController
                                              .selectSort('$selectedCategory-');
                                        } else {
                                          // Switch to ascending (+)
                                          homeController
                                              .selectSort('$selectedCategory+');
                                        }
                                      }
                                    : null,
                              ),
                              Text(
                                '-',
                                style: TextStyle(
                                  fontFamily: FontFamily.poppins,
                                  fontSize: TaskWarriorFonts.fontSizeMedium,
                                  fontWeight: FontWeight.bold,
                                  color: tColors.primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 12),
                    // Clear sort button
                    TextButton.icon(
                      onPressed: () {
                        homeController.selectSort('urgency+');
                      },
                      icon: Icon(
                        Icons.clear,
                        size: 18,
                        color: tColors.primaryTextColor,
                      ),
                      label: Text(
                          SentenceManager(
                                  currentLanguage:
                                      homeController.selectedLanguage.value)
                              .sentences
                              .filterDrawerResetSort,
                          style: TextStyle(
                            fontFamily: FontFamily.poppins,
                            fontSize: TaskWarriorFonts.fontSizeMedium,
                            color: tColors.primaryTextColor,
                          )),
                    ),
                    const SizedBox(height: 8),
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
