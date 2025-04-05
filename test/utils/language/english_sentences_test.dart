import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/language/english_sentences.dart';

void main() {
  final english = EnglishSentences();

  test('should provide correct English translations', () {
    expect(english.helloWorld, 'Hello, World!');
    expect(english.homePageTitle, 'Home Page');
    expect(english.homePageLastModified, 'Last Modified');
    expect(english.homePageDue, 'Due');
    expect(english.homePageTaskWarriorNotConfigured,
        'TaskServer is not configured');
    expect(english.homePageSetup, 'Setup');
    expect(english.homePageFilter, 'Filter');
    expect(english.homePageMenu, 'Menu');
    expect(english.homePageExitApp, 'Exit App');
    expect(english.homePageAreYouSureYouWantToExit,
        'Are you sure you want to exit?');
    expect(english.homePageExit, 'Exit');
    expect(english.homePageCancel, 'Cancel');
    expect(english.homePageClickOnTheBottomRightButtonToStartAddingTasks,
        'Click on the bottom right button to start adding tasks');
    expect(english.homePageSearchNotFound, 'Search Not Found');
    expect(english.settingsPageTitle, 'Settings Page');
    expect(english.settingsPageSubtitle, 'Configure your preferences');
    expect(english.settingsPageMovingDataToNewDirectory,
        'Moving data to new directory');
    expect(english.settingsPageSyncOnStartTitle, 'Sync on Start');
    expect(english.settingsPageSyncOnStartDescription,
        'Automatically sync data on app start');
    expect(
        english.settingsPageEnableSyncOnTaskCreateTitle, 'Sync on task create');
    expect(english.settingsPageEnableSyncOnTaskCreateDescription,
        'Enable automatic syncing when creating a new task');
    expect(english.settingsPageHighlightTaskTitle, 'Highlight urgent tasks');
    expect(english.settingsPageHighlightTaskDescription,
        'Highlight tasks due within 1 day or already overdue');
    expect(english.settingsPageEnable24hrFormatTitle, 'Enable 24 hr format');
    expect(english.settingsPageEnable24hrFormatDescription,
        'Switch right to enable 24 hr format');
    expect(english.settingsPageSelectLanguage, 'Select the language');
    expect(english.settingsPageToggleNativeLanguage,
        'Toggle between your native language');
    expect(english.settingsPageSelectDirectoryTitle, 'Select the directory');
    expect(english.settingsPageSelectDirectoryDescription,
        'Select the directory where the Taskwarrior data is stored\nCurrent directory: ');
    expect(english.settingsPageChangeDirectory, 'Change Directory');
    expect(english.settingsPageSetToDefault, 'Set To Default');
    expect(english.navDrawerProfile, 'Profile');
    expect(english.navDrawerReports, 'Reports');
    expect(english.navDrawerAbout, 'About');
    expect(english.navDrawerSettings, 'Settings');
    expect(english.navDrawerExit, 'Exit');
    expect(english.detailPageDescription, 'Description');
    expect(english.detailPageStatus, 'Status');
    expect(english.detailPageEntry, 'Entry');
    expect(english.detailPageModified, 'Modified');
    expect(english.detailPageStart, 'Start');
    expect(english.detailPageEnd, 'End');
    expect(english.detailPageDue, 'Due');
    expect(english.detailPageWait, 'Wait');
    expect(english.detailPageUntil, 'Until');
    expect(english.detailPagePriority, 'Priority');
    expect(english.detailPageProject, 'Project');
    expect(english.detailPageTags, 'Tags');
    expect(english.detailPageUrgency, 'Urgency');
    expect(english.detailPageID, 'ID');
    expect(english.filterDrawerApplyFilters, 'Apply Filters');
    expect(english.filterDrawerHideWaiting, 'Hide Waiting');
    expect(english.filterDrawerShowWaiting, 'Show Waiting');
    expect(english.filterDrawerPending, 'Pending');
    expect(english.filterDrawerCompleted, 'Completed');
    expect(english.filterDrawerFilterTagBy, 'Filter Tag By');
    expect(english.filterDrawerAND, 'AND');
    expect(english.filterDrawerOR, 'OR');
    expect(english.filterDrawerSortBy, 'Sort By');
    expect(english.filterDrawerCreated, 'Created');
    expect(english.filterDrawerModified, 'Modified');
    expect(english.filterDrawerStartTime, 'Start Time');
    expect(english.filterDrawerDueTill, 'Due till');
    expect(english.filterDrawerPriority, 'Priority');
    expect(english.filterDrawerProject, 'Project');
    expect(english.filterDrawerTags, 'Tags');
    expect(english.filterDrawerUrgency, 'Urgency');
    expect(english.filterDrawerResetSort, 'Reset Sort');
    expect(english.filterDrawerStatus, 'Status');
    expect(english.reportsPageTitle, 'Reports');
    expect(english.reportsPageCompleted, 'Completed');
    expect(english.reportsPagePending, 'Pending');
    expect(english.reportsPageTasks, 'Tasks');
    expect(english.reportsPageDaily, 'Daily');
    expect(english.reportsPageDailyBurnDownChart, 'Daily Burn Down Chart');
    expect(english.reportsPageDailyDayMonth, 'Day - Month');
    expect(english.reportsPageWeekly, 'Weekly');
    expect(english.reportsPageWeeklyBurnDownChart, 'Weekly Burn Down Chart');
    expect(english.reportsPageWeeklyWeeksYear, 'Weeks - Year');
    expect(english.reportsPageMonthly, 'Monthly');
    expect(english.reportsPageMonthlyBurnDownChart, 'Monthly Burn Down Chart');
    expect(english.reportsPageMonthlyMonthYear, 'Month - Year');
    expect(english.reportsPageNoTasksFound, 'No Tasks Found');
    expect(english.reportsPageAddTasksToSeeReports, 'Add Tasks To See Reports');
    expect(english.taskchampionTileDescription,
        'Switch to Taskwarrior sync with CCSync or Taskchampion Sync Server');
    expect(english.taskchampionTileTitle, 'Taskchampion sync');
    expect(english.ccsyncCredentials, 'CCync credentials');
    expect(english.deleteTaskConfirmation, 'Delete Tasks');
    expect(english.deleteTaskTitle, 'Delete All Tasks?');
    expect(english.deleteTaskWarning,
        'The action is irreversible and will delete all the tasks that are stored locally.');
    expect(english.profilePageProfile, 'Profile');
    expect(english.profilePageProfiles, 'Profiles');
    expect(english.profilePageCurrentProfile, 'Current Profile');
    expect(english.profilePageManageSelectedProfile, 'Manage Selected Profile');
    expect(english.profilePageRenameAlias, 'Rename Alias');
    expect(english.profilePageConfigureTaskserver, 'Configure Taskserver');
    expect(english.profilePageExportTasks, 'Export Tasks');
    expect(english.profilePageCopyConfigToNewProfile,
        'Copy Config To New Profile');
    expect(english.profilePageDeleteProfile, 'Delete Profile');
    expect(english.profilePageAddNewProfile, 'Add New Profile');
    expect(english.profilePageRenameAliasDialogueBoxTitle, 'Rename Alias');
    expect(english.profilePageRenameAliasDialogueBoxNewAlias, 'New Alias');
    expect(english.profilePageRenameAliasDialogueBoxCancel, 'Cancel');
    expect(english.profilePageRenameAliasDialogueBoxSubmit, 'Submit');
    expect(english.profilePageExportTasksDialogueTitle, 'Export format');
    expect(english.profilePageExportTasksDialogueSubtitle,
        'Choose the export format');
    expect(english.manageTaskServerPageConfigureTaskserver,
        'Configure Task Server');
    expect(english.manageTaskServerPageConfigureTASKRC, 'Configure TASKRC');
    expect(english.manageTaskServerPageSetTaskRC, 'Set TaskRC');
    expect(english.manageTaskServerPageConfigureYourCertificate,
        'Configure Your Certificate');
    expect(english.manageTaskServerPageSelectCertificate, 'Select Certificate');
    expect(english.manageTaskServerPageConfigureTaskserverKey,
        'Configure Task Server Key');
    expect(english.manageTaskServerPageSelectKey, 'Select Key');
    expect(english.manageTaskServerPageConfigureServerCertificate,
        'Configure Server Certificate');
    expect(english.manageTaskServerPageConfigureTaskRCDialogueBoxTitle,
        'Configure TaskRC');
    expect(english.manageTaskServerPageConfigureTaskRCDialogueBoxSubtitle,
        'Paste the TaskRC content or select taskrc file');
    expect(english.manageTaskServerPageConfigureTaskRCDialogueBoxInputFieldText,
        'Paste your TaskRC content here');
    expect(english.manageTaskServerPageConfigureTaskRCDialogueBoxOr, 'Or');
    expect(english.manageTaskServerPageConfigureTaskRCDialogueBoxSelectTaskRC,
        'Select TaskRC file');
    expect(english.addTaskTitle, 'Add Task');
    expect(english.addTaskEnterTask, 'Enter Task');
    expect(english.addTaskDue, 'Due');
    expect(english.addTaskSelectDueDate, 'Select Due Date');
    expect(english.addTaskPriority, 'Priority');
    expect(english.addTaskAddTags, 'Add Tags');
    expect(english.addTaskCancel, 'Cancel');
    expect(english.addTaskAdd, 'Add');
    expect(english.addTaskTimeInPast, 'The selected time is in the past.');
    expect(english.addTaskFieldCannotBeEmpty,
        'You cannot leave this field empty!');
    expect(english.addTaskTaskAddedSuccessfully,
        'Task Added Successfully. Tap to Edit');
    expect(english.aboutPageGitHubLink,
        'Eager to enhance this project? Visit our GitHub repository.');
    expect(english.aboutPageProjectDescription,
        'This project aims to build an app for Taskwarrior. It is your task management app across all platforms. It helps you manage your tasks and filter them as per your needs.');
    expect(english.aboutPageAppBarTitle, 'About');
  });
}
