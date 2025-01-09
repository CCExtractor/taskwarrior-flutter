import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/language/english_sentences.dart';
import 'package:taskwarrior/app/utils/language/hindi_sentences.dart';
import 'package:taskwarrior/app/utils/language/marathi_sentences.dart';
import 'package:taskwarrior/app/utils/language/french_sentences.dart';
import 'package:taskwarrior/app/utils/language/spanish_sentences.dart';
import 'package:taskwarrior/app/utils/language/bengali_sentences.dart';

void main() {
  group('Sentences subclass implementations', () {
    final sentenceClasses = [
      EnglishSentences(),
      HindiSentences(),
      MarathiSentences(),
      FrenchSentences(),
      SpanishSentences(),
      BengaliSentences(),
    ];

    for (var sentences in sentenceClasses) {
      test('should have all required getters for ${sentences.runtimeType}', () {
        expect(sentences.helloWorld, isA<String>());
        expect(sentences.homePageTitle, isA<String>());
        expect(sentences.homePageLastModified, isA<String>());
        expect(sentences.homePageDue, isA<String>());
        expect(sentences.homePageTaskWarriorNotConfigured, isA<String>());
        expect(sentences.homePageSetup, isA<String>());
        expect(sentences.homePageFilter, isA<String>());
        expect(sentences.homePageMenu, isA<String>());
        expect(sentences.homePageExitApp, isA<String>());
        expect(sentences.homePageAreYouSureYouWantToExit, isA<String>());
        expect(sentences.homePageExit, isA<String>());
        expect(sentences.homePageCancel, isA<String>());
        expect(sentences.homePageClickOnTheBottomRightButtonToStartAddingTasks,
            isA<String>());
        expect(sentences.homePageSearchNotFound, isA<String>());
        expect(sentences.settingsPageTitle, isA<String>());
        expect(sentences.settingsPageSubtitle, isA<String>());
        expect(sentences.settingsPageMovingDataToNewDirectory, isA<String>());
        expect(sentences.settingsPageChangeDirectory, isA<String>());
        expect(sentences.settingsPageSetToDefault, isA<String>());
        expect(sentences.settingsPageSyncOnStartTitle, isA<String>());
        expect(sentences.settingsPageSyncOnStartDescription, isA<String>());
        expect(
            sentences.settingsPageEnableSyncOnTaskCreateTitle, isA<String>());
        expect(sentences.settingsPageEnableSyncOnTaskCreateDescription,
            isA<String>());
        expect(sentences.settingsPageHighlightTaskTitle, isA<String>());
        expect(sentences.settingsPageHighlightTaskDescription, isA<String>());
        expect(sentences.settingsPageEnable24hrFormatTitle, isA<String>());
        expect(
            sentences.settingsPageEnable24hrFormatDescription, isA<String>());
        expect(sentences.taskchampionTileTitle, isA<String>());
        expect(sentences.taskchampionTileDescription, isA<String>());
        expect(sentences.settingsPageSelectLanguage, isA<String>());
        expect(sentences.settingsPageToggleNativeLanguage, isA<String>());
        expect(sentences.settingsPageSelectDirectoryTitle, isA<String>());
        expect(sentences.settingsPageSelectDirectoryDescription, isA<String>());
        expect(sentences.navDrawerProfile, isA<String>());
        expect(sentences.navDrawerReports, isA<String>());
        expect(sentences.navDrawerAbout, isA<String>());
        expect(sentences.navDrawerSettings, isA<String>());
        expect(sentences.ccsyncCredentials, isA<String>());
        expect(sentences.deleteTaskTitle, isA<String>());
        expect(sentences.deleteTaskConfirmation, isA<String>());
        expect(sentences.deleteTaskWarning, isA<String>());
        expect(sentences.navDrawerExit, isA<String>());
        expect(sentences.detailPageDescription, isA<String>());
        expect(sentences.detailPageStatus, isA<String>());
        expect(sentences.detailPageEntry, isA<String>());
        expect(sentences.detailPageModified, isA<String>());
        expect(sentences.detailPageStart, isA<String>());
        expect(sentences.detailPageEnd, isA<String>());
        expect(sentences.detailPageDue, isA<String>());
        expect(sentences.detailPageWait, isA<String>());
        expect(sentences.detailPageUntil, isA<String>());
        expect(sentences.detailPagePriority, isA<String>());
        expect(sentences.detailPageProject, isA<String>());
        expect(sentences.detailPageTags, isA<String>());
        expect(sentences.detailPageUrgency, isA<String>());
        expect(sentences.detailPageID, isA<String>());
        expect(sentences.filterDrawerApplyFilters, isA<String>());
        expect(sentences.filterDrawerHideWaiting, isA<String>());
        expect(sentences.filterDrawerShowWaiting, isA<String>());
        expect(sentences.filterDrawerPending, isA<String>());
        expect(sentences.filterDrawerCompleted, isA<String>());
        expect(sentences.filterDrawerFilterTagBy, isA<String>());
        expect(sentences.filterDrawerAND, isA<String>());
        expect(sentences.filterDrawerOR, isA<String>());
        expect(sentences.filterDrawerSortBy, isA<String>());
        expect(sentences.filterDrawerCreated, isA<String>());
        expect(sentences.filterDrawerModified, isA<String>());
        expect(sentences.filterDrawerStartTime, isA<String>());
        expect(sentences.filterDrawerDueTill, isA<String>());
        expect(sentences.filterDrawerPriority, isA<String>());
        expect(sentences.filterDrawerProject, isA<String>());
        expect(sentences.filterDrawerTags, isA<String>());
        expect(sentences.filterDrawerUrgency, isA<String>());
        expect(sentences.filterDrawerResetSort, isA<String>());
        expect(sentences.filterDrawerStatus, isA<String>());
        expect(sentences.reportsPageTitle, isA<String>());
        expect(sentences.reportsPageCompleted, isA<String>());
        expect(sentences.reportsPagePending, isA<String>());
        expect(sentences.reportsPageTasks, isA<String>());
        expect(sentences.reportsPageDaily, isA<String>());
        expect(sentences.reportsPageDailyBurnDownChart, isA<String>());
        expect(sentences.reportsPageDailyDayMonth, isA<String>());
        expect(sentences.reportsPageWeekly, isA<String>());
        expect(sentences.reportsPageWeeklyBurnDownChart, isA<String>());
        expect(sentences.reportsPageWeeklyWeeksYear, isA<String>());
        expect(sentences.reportsPageMonthly, isA<String>());
        expect(sentences.reportsPageMonthlyBurnDownChart, isA<String>());
        expect(sentences.reportsPageMonthlyMonthYear, isA<String>());
        expect(sentences.reportsPageNoTasksFound, isA<String>());
        expect(sentences.reportsPageAddTasksToSeeReports, isA<String>());
        expect(sentences.profilePageProfile, isA<String>());
        expect(sentences.profilePageProfiles, isA<String>());
        expect(sentences.profilePageCurrentProfile, isA<String>());
        expect(sentences.profilePageManageSelectedProfile, isA<String>());
        expect(sentences.profilePageRenameAlias, isA<String>());
        expect(sentences.profilePageConfigureTaskserver, isA<String>());
        expect(sentences.profilePageExportTasks, isA<String>());
        expect(sentences.profilePageCopyConfigToNewProfile, isA<String>());
        expect(sentences.profilePageDeleteProfile, isA<String>());
        expect(sentences.profilePageAddNewProfile, isA<String>());
        expect(sentences.profilePageExportTasksDialogueTitle, isA<String>());
        expect(sentences.profilePageExportTasksDialogueSubtitle, isA<String>());
        expect(sentences.profilePageRenameAliasDialogueBoxTitle, isA<String>());
        expect(
            sentences.profilePageRenameAliasDialogueBoxNewAlias, isA<String>());
        expect(
            sentences.profilePageRenameAliasDialogueBoxCancel, isA<String>());
        expect(
            sentences.profilePageRenameAliasDialogueBoxSubmit, isA<String>());
        expect(
            sentences.manageTaskServerPageConfigureTaskserver, isA<String>());
        expect(sentences.manageTaskServerPageConfigureTASKRC, isA<String>());
        expect(sentences.manageTaskServerPageSetTaskRC, isA<String>());
        expect(sentences.manageTaskServerPageConfigureYourCertificate,
            isA<String>());
        expect(sentences.manageTaskServerPageSelectCertificate, isA<String>());
        expect(sentences.manageTaskServerPageConfigureTaskserverKey,
            isA<String>());
        expect(sentences.manageTaskServerPageSelectKey, isA<String>());
        expect(sentences.manageTaskServerPageConfigureServerCertificate,
            isA<String>());
        expect(
            sentences.manageTaskServerPageTaskRCFileIsVerified, isA<String>());
        expect(sentences.manageTaskServerPageConfigureTaskRCDialogueBoxTitle,
            isA<String>());
        expect(sentences.manageTaskServerPageConfigureTaskRCDialogueBoxSubtitle,
            isA<String>());
        expect(
            sentences
                .manageTaskServerPageConfigureTaskRCDialogueBoxInputFieldText,
            isA<String>());
        expect(sentences.manageTaskServerPageConfigureTaskRCDialogueBoxOr,
            isA<String>());
        expect(
            sentences
                .manageTaskServerPageConfigureTaskRCDialogueBoxSelectTaskRC,
            isA<String>());
        expect(sentences.addTaskTitle, isA<String>());
        expect(sentences.addTaskEnterTask, isA<String>());
        expect(sentences.addTaskDue, isA<String>());
        expect(sentences.addTaskSelectDueDate, isA<String>());
        expect(sentences.addTaskPriority, isA<String>());
        expect(sentences.addTaskAddTags, isA<String>());
        expect(sentences.addTaskCancel, isA<String>());
        expect(sentences.addTaskAdd, isA<String>());
        expect(sentences.addTaskTimeInPast, isA<String>());
        expect(sentences.addTaskFieldCannotBeEmpty, isA<String>());
        expect(sentences.addTaskTaskAddedSuccessfully, isA<String>());
        expect(sentences.aboutPageGitHubLink, isA<String>());
        expect(sentences.aboutPageProjectDescription, isA<String>());
        expect(sentences.aboutPageAppBarTitle, isA<String>());
      });
    }
  });
}
