import 'package:taskwarrior/app/utils/language/sentences.dart';

class EnglishSentences extends Sentences {
  @override
  String get helloWorld => 'Hello, World!';

  @override
  String get homePageTitle => 'Home Page';
  @override
  String get homePageLastModified => 'Last Modified';
  @override
  String get homePageDue => 'Due';
  @override
  String get homePageTaskWarriorNotConfigured => 'TaskServer is not configured';
  @override
  String get homePageSetup => 'Setup';
  @override
  String get homePageFilter => 'Filter';
  @override
  String get homePageMenu => 'Menu';
  @override
  String get homePageExitApp => 'Exit App';
  @override
  String get homePageAreYouSureYouWantToExit =>
      'Are you sure you want to exit?';
  @override
  String get homePageExit => 'Exit';
  @override
  String get homePageCancel => 'Cancel';
  @override
  String get homePageClickOnTheBottomRightButtonToStartAddingTasks =>
      'Click on the bottom right button to start adding tasks';
  @override
  String get homePageSearchNotFound => 'Search Not Found';

  @override
  String get settingsPageTitle => 'Settings Page';
  @override
  String get settingsPageSubtitle => 'Configure your preferences';
  @override
  String get settingsPageMovingDataToNewDirectory =>
      'Moving data to new directory';
  @override
  String get settingsPageSyncOnStartTitle => 'Sync on Start';
  @override
  String get settingsPageSyncOnStartDescription =>
      'Automatically sync data on app start';
  @override
  String get settingsPageEnableSyncOnTaskCreateTitle => 'Sync on task create';
  @override
  String get settingsPageEnableSyncOnTaskCreateDescription =>
      'Enable automatic syncing when creating a new task';
  @override
  String get settingsPageHighlightTaskTitle => 'Highlight the task';
  @override
  String get settingsPageHighlightTaskDescription =>
      'Make the border of task if only 1 day left';
  @override
  String get settingsPageEnable24hrFormatTitle => 'Enable 24 hr format';
  @override
  String get settingsPageEnable24hrFormatDescription =>
      'Switch right to enable 24 hr format';
  @override
  String get settingsPageSelectLanguage => 'Select the language';
  @override
  String get settingsPageToggleNativeLanguage =>
      'Toggle between your native language';
  @override
  String get settingsPageSelectDirectoryTitle => 'Select the directory';
  @override
  String get settingsPageSelectDirectoryDescription =>
      'Select the directory where the TaskWarrior data is stored\nCurrent directory: ';
  @override
  String get settingsPageChangeDirectory => 'Change Directory';
  @override
  String get settingsPageSetToDefault => 'Set To Default';

  @override
  String get navDrawerProfile => 'Profile';
  @override
  String get navDrawerReports => 'Reports';
  @override
  String get navDrawerAbout => 'About';
  @override
  String get navDrawerSettings => 'Settings';
  @override
  String get navDrawerExit => 'Exit';

  @override
  String get detailPageDescription => 'Description';
  @override
  String get detailPageStatus => 'Status';
  @override
  String get detailPageEntry => 'Entry';
  @override
  String get detailPageModified => 'Modified';
  @override
  String get detailPageStart => 'Start';
  @override
  String get detailPageEnd => 'End';
  @override
  String get detailPageDue => 'Due';
  @override
  String get detailPageWait => 'Wait';
  @override
  String get detailPageUntil => 'Until';
  @override
  String get detailPagePriority => 'Priority';
  @override
  String get detailPageProject => 'Project';
  @override
  String get detailPageTags => 'Tags';
  @override
  String get detailPageUrgency => 'Urgency';
  @override
  String get detailPageID => 'ID';

  @override
  String get filterDrawerApplyFilters => 'Apply Filters';
  @override
  String get filterDrawerHideWaiting => 'Hide Waiting';
  @override
  String get filterDrawerShowWaiting => 'Show Waiting';
  @override
  String get filterDrawerPending => 'Pending';
  @override
  String get filterDrawerCompleted => 'Completed';
  @override
  String get filterDrawerFilterTagBy => 'Filter Tag By';
  @override
  String get filterDrawerAND => 'AND';
  @override
  String get filterDrawerOR => 'OR';
  @override
  String get filterDrawerSortBy => 'Sort By';
  @override
  String get filterDrawerCreated => 'Created';
  @override
  String get filterDrawerModified => 'Modified';
  @override
  String get filterDrawerStartTime => 'Start Time';
  @override
  String get filterDrawerDueTill => 'Due till';
  @override
  String get filterDrawerPriority => 'Priority';
  @override
  String get filterDrawerProject => 'Project';
  @override
  String get filterDrawerTags => 'Tags';
  @override
  String get filterDrawerUrgency => 'Urgency';
  @override
  String get filterDrawerResetSort => 'Reset Sort';
  @override
  String get filterDrawerStatus => 'Status';
  @override
  String get reportsPageTitle => 'Reports';
  @override
  String get reportsPageCompleted => 'Completed';
  @override
  String get reportsPagePending => 'Pending';
  @override
  String get reportsPageTasks => 'Tasks';

  @override
  String get reportsPageDaily => 'Daily';
  @override
  String get reportsPageDailyBurnDownChart => 'Daily Burn Down Chart';
  @override
  String get reportsPageDailyDayMonth => 'Day - Month';

  @override
  String get reportsPageWeekly => 'Weekly';
  @override
  String get reportsPageWeeklyBurnDownChart => 'Weekly Burn Down Chart';
  @override
  String get reportsPageWeeklyWeeksYear => 'Weeks - Year';

  @override
  String get reportsPageMonthly => 'Monthly';
  @override
  String get reportsPageMonthlyBurnDownChart => 'Monthly Burn Down Chart';
  @override
  String get reportsPageMonthlyMonthYear => 'Month - Year';

  @override
  String get reportsPageNoTasksFound => 'No Tasks Found';
  @override
  String get reportsPageAddTasksToSeeReports => 'Add Tasks To See Reports';

  @override
  String get taskchampionTileDescription =>
      'Switch to TaskWarrior sync with CCSync or Taskchampion Sync Server';
  @override
  String get taskchampionTileTitle => 'Taskchampion sync';

  @override
  String get ccsyncCredentials => 'CCync credentials';

  @override
  String get deleteTaskConfirmation => 'Delete Tasks';

  @override
  String get deleteTaskTitle => 'Delete All Tasks?';

  @override
  String get deleteTaskWarning =>
      'The action is irreversible and will delete all the tasks that are stored locally.';

  @override
  String get profilePageProfile => 'Profile';
  @override
  String get profilePageProfiles => 'Profiles';
  @override
  String get profilePageCurrentProfile => 'Current Profile';
  @override
  String get profilePageManageSelectedProfile => 'Manage Selected Profile';
  @override
  String get profilePageRenameAlias => 'Rename Alias';

  @override
  String get profilePageConfigureTaskserver => 'Configure Taskserver';
  @override
  String get profilePageExportTasks => 'Export Tasks';
  @override
  String get profilePageCopyConfigToNewProfile => 'Copy Config To New Profile';
  @override
  String get profilePageDeleteProfile => 'Delete Profile';
  @override
  String get profilePageAddNewProfile => 'Add New Profile';

  @override
  String get profilePageRenameAliasDialogueBoxTitle => 'Rename Alias';
  @override
  String get profilePageRenameAliasDialogueBoxNewAlias => 'New Alias';
  @override
  String get profilePageRenameAliasDialogueBoxCancel => 'Cancel';
  @override
  String get profilePageRenameAliasDialogueBoxSubmit => 'Submit';

  @override
  String get profilePageExportTasksDialogueTitle => 'Export format';
  @override
  String get profilePageExportTasksDialogueSubtitle =>
      'Choose the export format';

  @override
  String get manageTaskServerPageConfigureTaskserver => 'Configure Task Server';
  @override
  String get manageTaskServerPageConfigureTASKRC => 'Configure TASKRC';
  @override
  String get manageTaskServerPageSetTaskRC => 'Set TaskRC';
  @override
  String get manageTaskServerPageConfigureYourCertificate =>
      'Configure Your Certificate';
  @override
  String get manageTaskServerPageSelectCertificate => 'Select Certificate';
  @override
  String get manageTaskServerPageConfigureTaskserverKey =>
      'Configure Task Server Key';
  @override
  String get manageTaskServerPageSelectKey => 'Select Key';
  @override
  String get manageTaskServerPageConfigureServerCertificate =>
      'Configure Server Certificate';

  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxTitle =>
      'Configure TaskRC';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxSubtitle =>
      'Paste the TaskRC content or select taskrc file';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxInputFieldText =>
      'Paste your TaskRC content here';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxOr => 'Or';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxSelectTaskRC =>
      'Select TaskRC file';
  @override
  String get manageTaskServerPageTaskRCFileIsVerified =>
      'Task RC File Is Verified';
}
