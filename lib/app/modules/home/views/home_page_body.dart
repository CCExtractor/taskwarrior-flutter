import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/home/views/show_tasks.dart';
import 'package:taskwarrior/app/modules/home/views/tasks_builder.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import '../controllers/home_controller.dart';

class HomePageBody extends StatefulWidget {
  final HomeController controller;
  const HomePageBody({required this.controller, super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  DateTime? _lastBackPressTime;
  Timer? _backPressTimer;

  @override
  void dispose() {
    _backPressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.initInAppTour();
    widget.controller.showInAppTour(context);
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (widget.controller.isHomeTourActive.value) {
            return;
          }

          final now = DateTime.now();
          if (_lastBackPressTime != null &&
              now.difference(_lastBackPressTime!) <=
                  const Duration(seconds: 2)) {
            _backPressTimer?.cancel();
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return;
          } else {
            _lastBackPressTime = now;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(SentenceManager(
                          currentLanguage: widget.controller.selectedLanguage.value)
                      .sentences
                      .homePageTapBackToExit)),
            );

            _backPressTimer?.cancel();
            _backPressTimer = Timer(const Duration(seconds: 2), () {
              _lastBackPressTime = null;
            });

            return;
          }
        },
        child: Container(
          color: tColors.dialogBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Obx(
              () => Column(
                children: <Widget>[
                  if (widget.controller.searchVisible.value)
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: SearchBar(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            (tColors.primaryBackgroundColor!)),
                        surfaceTintColor: WidgetStateProperty.all<Color>(
                            (tColors.primaryBackgroundColor!)),
                        controller: widget.controller.searchController,
                        // shape:,
                        onChanged: (value) {
                          widget.controller.search(value);
                        },

                        shape: WidgetStateProperty.resolveWith<OutlinedBorder?>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.focused)) {
                              return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(
                                  color: tColors.primaryTextColor!,
                                  width: 2.0,
                                ),
                              );
                            } else {
                              return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(
                                  color: tColors.primaryTextColor!,
                                  width: 1.5,
                                ),
                              );
                            }
                          },
                        ),
                        leading: const Icon(Icons.search_rounded),
                        trailing: <Widget>[
                          (widget.controller.searchController.text.isNotEmpty)
                              ? IconButton(
                                  key: GlobalKey(),
                                  icon: Icon(Icons.cancel,
                                      color: TaskWarriorColors.black),
                                  onPressed: () {
                                    widget.controller.searchController.clear();
                                    widget.controller.search(widget
                                        .controller.searchController.text);
                                  },
                                )
                              : const SizedBox(
                                  width: 0,
                                  height: 0,
                                )
                        ],

                        hintText: SentenceManager(
                                currentLanguage:
                                    widget.controller.selectedLanguage.value)
                            .sentences
                            .homePageSearchHint,
                      ),
                    ),
                  Visibility(
                    visible: !widget.controller.taskchampion.value,
                    child: Expanded(
                      child: Scrollbar(
                        child: Obx(
                          () => TasksBuilder(
                            // darkmode: AppSettings.isDarkMode,
                            useDelayTask: widget.controller.useDelayTask.value,
                            taskData: widget.controller.searchedTasks,
                            pendingFilter:
                                widget.controller.pendingFilter.value,
                            waitingFilter:
                                widget.controller.waitingFilter.value,
                            searchVisible:
                                widget.controller.searchVisible.value,
                            selectedLanguage:
                                widget.controller.selectedLanguage.value,
                            scrollController:
                                widget.controller.scrollController,
                            showbtn: widget.controller.showbtn.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: widget.controller.taskchampion.value,
                      child: Expanded(
                          child: Scrollbar(
                        child: TaskViewBuilder(
                          pendingFilter: widget.controller.pendingFilter.value,
                          selectedSort: widget.controller.selectedSort.value,
                          project: widget.controller.projectFilter.value,
                        ),
                      )))
                ],
              ),
            ),
          ),
        ));
  }
}
