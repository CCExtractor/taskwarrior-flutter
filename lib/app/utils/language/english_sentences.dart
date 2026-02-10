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
  String get homePageFetchingTasks => 'Fetching Tasks';
  @override
  String get homePageSearchTooltip => 'Search';
  @override
  String get homePageCancelSearchTooltip => 'Cancel';
  @override
  String get homePageAddTaskTooltip => 'Add Task';
  @override
  String get homePageTapBackToExit => 'Tap back again to exit';
  @override
  String get homePageSearchHint => 'Search';

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
  String get settingsPageHighlightTaskTitle => 'Highlight urgent tasks';
  @override
  String get settingsPageHighlightTaskDescription =>
      'Highlight tasks due within 1 day or already overdue';
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
      'Select the directory where the Taskwarrior data is stored\nCurrent directory: ';
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
  String get navDrawerConfirm => 'Confirm';

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
  String get filterDrawerNoProjectsAvailable => 'No projects available.';
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
      'Switch to Taskwarrior sync with CCSync or Taskchampion Sync Server';
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
  String get deleteAllTasksWillBeMarkedAsDeleted =>
      'This will mark all tasks as deleted and will not be shown in app';

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
  String get profilePageChangeProfileMode => 'Change Sync Server';
  @override
  String get profilePageSelectProfileMode => 'Select One Server';
  @override
  String get profilePageSuccessfullyChangedProfileModeTo =>
      'Successfully changed profile mode to';
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

  @override
  String get addTaskTitle => "Add Task";
  @override
  String get addTaskEnterTask => "Enter Task";
  @override
  String get addTaskDue => "Due";
  @override
  String get addTaskSelectDueDate => "Select Due Date";
  @override
  String get addTaskPriority => "Priority";
  @override
  String get addTaskAddTags => "Add Tags";
  @override
  String get addTaskCancel => "Cancel";
  @override
  String get addTaskAdd => "Add";
  @override
  String get addTaskTimeInPast => "The selected time is in the past.";
  @override
  String get addTaskFieldCannotBeEmpty => "You cannot leave this field empty!";
  @override
  String get addTaskTaskAddedSuccessfully =>
      "Task Added Successfully. Tap to Edit";

  @override
  String get aboutPageGitHubLink =>
      "Eager to enhance this project? Visit our GitHub repository.";
  @override
  String get aboutPageProjectDescription =>
      "This project aims to build an app for Taskwarrior. It is your task management app across all platforms. It helps you manage your tasks and filter them as per your needs.";
  @override
  String get aboutPageAppBarTitle => "About";

  @override
  String get version => "Version";
  @override
  String get package => "Package";

  @override
  String get notSelected => "Not Selected";
  @override
  String get cantSetTimeinPast => "Can't set times in the past";

  @override
  String get editDescription => "Edit Description";
  @override
  String get editProject => "Edit Project";
  @override
  String get cancel => "Cancel";
  @override
  String get submit => "Submit";

  @override
  String get saveChangesConfirmation => 'Do you want to save changes?';
  @override
  String get yes => 'Yes';
  @override
  String get no => 'No';
  @override
  String get reviewChanges => 'Review Changes';
  @override
  String get oldChanges => 'Old';
  @override
  String get newChanges => 'New';

  @override
  String get tags => 'Tags';
  @override
  String get addedTagsWillAppearHere => 'Added tags will appear here';
  @override
  String get addTag => 'Add Tag';

  @override
  String get enterProject => 'Enter Project';
  @override
  String get allProjects => 'All Projects';
  @override
  String get noProjectsFound => 'No Projects Found';
  @override
  String get project => 'Project';

  @override
  String get select => 'Select';
  @override
  String get save => 'Save';
  @override
  String get dontSave => 'Don\'t Save';
  @override
  String get unsavedChanges => 'Unsaved Changes';
  @override
  String get unsavedChangesWarning =>
      'You have unsaved changes. What would you like to do?';
  @override
  String get enterNew => 'Enter New';
  @override
  String get edit => 'Edit';
  @override
  String get task => 'Task';

  // task action strings
  @override
  String get confirmDeleteTask => 'Confirm Delete';
  @override
  String get taskUpdated => 'Task Updated';
  @override
  String get undo => 'Undo';
  @override
  String get taskMarkedAsCompleted =>
      'Task Marked As Completed. Refresh to view changes!';
  @override
  String get taskMarkedAsDeleted =>
      'Task Marked As Deleted. Refresh to view changes!';
  @override
  String get refreshToViewChanges => 'Refresh to view changes';
  @override
  String get clickOnBottomRightButtonToStartAddingTasks =>
      'Click on the bottom right button to start adding tasks';
  @override
  String get complete => 'COMPLETE';
  @override
  String get delete => 'DELETE';

  // task server management strings
  @override
  String get taskServerInfo => 'TaskD Server Info';
  @override
  String get taskServerCredentials => 'TaskD Server Credentials';
  @override
  String get notConfigured => 'Not Configured';
  @override
  String get fetchingStatistics => 'Fetching statistics...';
  @override
  String get pleaseWait => 'Please wait...';
  @override
  String get statistics => 'Statistics:';
  @override
  String get ok => 'Ok';
  @override
  String get pleaseSetupTaskServer => 'Please set up your TaskServer.';

  // onboarding strings
  @override
  String get onboardingSkip => 'Skip';
  @override
  String get onboardingNext => 'Next';
  @override
  String get onboardingStart => 'Start';

  // permission strings
  @override
  String get permissionPageTitle => 'Why We Need Your Permission';
  @override
  String get storagePermissionTitle => 'Storage Permission';
  @override
  String get storagePermissionDescription =>
      'We use storage access to save your tasks, preferences, '
      'and app data securely on your device. This ensures that you can '
      'pick up where you left off seamlessly, even offline.';
  @override
  String get notificationPermissionTitle => 'Notification Permission';
  @override
  String get notificationPermissionDescription =>
      'Notifications keep you updated with important reminders '
      'and updates, ensuring you stay on top of your tasks effortlessly.';
  @override
  String get privacyStatement =>
      'Your privacy is our top priority. We never access or share your '
      'personal files or data without your consent.';
  @override
  String get grantPermissions => 'Grant Permissions';
  @override
  String get managePermissionsLater =>
      'You can manage your permissions anytime later in Settings';

  // Profile page strings
  @override
  String get profileAllProfiles => 'All Profiles:';
  @override
  String get profileSwitchedToProfile => 'Switched to Profile';
  @override
  String get profileAddedSuccessfully => 'Profile Added Successfully';
  @override
  String get profileAdditionFailed => 'Profile Addition Failed';
  @override
  String get profileConfigCopied => 'Profile Config Copied';
  @override
  String get profileConfigCopyFailed => 'Profile Config Copy Failed';
  @override
  String get profileDeletedSuccessfully => 'Deleted Successfully';
  @override
  String get profileDeletionFailed => 'Deletion Failed';
  @override
  String get profileDeleteConfirmation => 'Confirm';

  // Reports strings
  @override
  String get reportsDate => 'Date';
  @override
  String get reportsPending => 'Pending';
  @override
  String get reportsCompleted => 'Completed';
  @override
  String get reportsMonthYear => 'Month-Year';
  @override
  String get reportsWeek => 'Week';
  @override
  String get reportsDay => 'Day';
  @override
  String get reportsYear => 'Year';
  @override
  String get reportsError => 'Error';
  @override
  String get reportsLoading => 'Loading...';

  // Settings strings
  @override
  String get settingsResetToDefault => 'Reset to default';
  @override
  String get settingsAlreadyDefault => 'Already default';
  @override
  String get settingsConfirmReset =>
      'Are you sure you want to reset the directory to the default?';
  @override
  String get settingsNoButton => 'No';
  @override
  String get settingsYesButton => 'Yes';

  // Splash screen strings
  @override
  String get splashSettingUpApp => "Setting up the app...";

  // Tour strings - reports
  @override
  String get tourReportsDaily => "Access your daily task report here";
  @override
  String get tourReportsWeekly => "Access your weekly task reports here";
  @override
  String get tourReportsMonthly => "Access your monthly task reports here";

  // Tour strings - profile
  @override
  String get tourProfileCurrent => "See your current profile here";
  @override
  String get tourProfileManage => "Manage your current profile here";
  @override
  String get tourProfileAddNew => "Add a new profile here";

  // Tour strings - task server
  @override
  String get tourTaskServerTaskRC =>
      "Select the file named taskrc here or paste it's content";
  @override
  String get tourTaskServerCertificate =>
      "Select file similarly named like <Your Email>.com.cert.pem here";
  @override
  String get tourTaskServerKey =>
      "Select file similarly named like <Your Email>.key.pem here";
  @override
  String get tourTaskServerRootCert =>
      "Select file similarly named like letsencrypt_root_cert.pem here";

  // Tour strings - home page
  @override
  String get tourHomeAddTask => "Add a new task";
  @override
  String get tourHomeSearch => "Search for tasks";
  @override
  String get tourHomeRefresh => "Refresh or sync your tasks";
  @override
  String get tourHomeFilter => "Add filters to sort your tasks and projects";
  @override
  String get tourHomeMenu => "Access additional settings here";

  // Tour strings - filter drawer
  @override
  String get tourFilterStatus =>
      "Filter tasks based on their completion status";
  @override
  String get tourFilterProjects => "Filter tasks based on the projects";
  @override
  String get tourFilterTagUnion => "Toggle between AND and OR tag union types";
  @override
  String get tourFilterSort =>
      "Sort tasks based on time of creation, urgency, due date, start date, etc.";

  // Tour strings - details page
  @override
  String get tourDetailsDue => "This signifies the due date of the task";
  @override
  String get tourDetailsWait =>
      "This signifies the waiting date of the task \n Task will be visible after this date";
  @override
  String get tourDetailsUntil => "This shows the last date of the task";
  @override
  String get tourDetailsPriority =>
      "This is the priority of the Tasks \n L -> Low \n M -> Medium \n H -> Hard";
  // Dialogue for adding new task
  @override
  String get descriprtionCannotBeEmpty => "Description cannot be empty";
  @override
  String get enterTaskDescription => "Enter Task Description";
  @override
  String get canNotHaveWhiteSpace => "Can not have white space";
  @override
  String get high => "High";
  @override
  String get medium => "Medium";
  @override
  String get low => "Low";
  @override
  String get priority => "Priority";
  @override
  String get tagAlreadyExists => "Tag already exists";
  @override
  String get tagShouldNotContainSpaces => "Tag should not contain spaces";
  @override
  String get date => "Date";
  @override
  String get add => "Add";
  @override
  String get change => "Change";
  @override
  String get dateCanNotBeInPast => "Date can not be in past";
  @override
  String get configureTaskchampion => 'Configure Taskchampion';
  @override
  String get encryptionSecret => 'Encryption Secret';
  @override
  String get ccsyncBackendUrl => 'CCSync Backend URL';
  @override
  String get ccsyncClientId => 'Client ID';
  @override
  String get success => 'Success';
  @override
  String get credentialsSavedSuccessfully => 'Credentials saved successfully';
  @override
  String get saveCredentials => 'Save';
  @override
  String get tip =>
      "Tip: Click on the info icon in the top right corner to get your credentials";
  @override
  String get logs => 'Logs';
  @override
  String get checkAllDebugLogsHere => 'Check all debug logs here';
  // Settings
  @override
  String get syncSetting => 'Sync Settings';
  @override
  String get displaySettings => 'Display Settings';
  @override
  String get storageAndData => 'Storage and Data';
  @override
  String get advanced => 'Advanced';
  @override
  String get taskchampionBackendUrl => 'Taskchampion URL';
}
