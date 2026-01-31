import 'package:taskwarrior/app/utils/language/sentences.dart';

class BengaliSentences extends Sentences {
  @override
  String get helloWorld => 'হ্যালো বিশ্ব!';
  @override
  String get homePageTitle => 'হোম পেজ';
  @override
  String get homePageLastModified => 'শেষবার পরিবর্তিত';
  @override
  String get homePageDue => 'জরুরি';
  @override
  String get homePageTaskWarriorNotConfigured => 'TaskServer কনফিগার করা হয়নি';
  @override
  String get homePageSetup => 'সেটআপ';
  @override
  String get homePageFilter => 'ফিল্টার';
  @override
  String get homePageMenu => 'মেনু';
  @override
  String get homePageExitApp => 'অ্যাপ বন্ধ করুন';
  @override
  String get homePageAreYouSureYouWantToExit =>
      'আপনি কি সত্যিই অ্যাপ বন্ধ করতে চান?';
  @override
  String get homePageExit => 'বাহির যান';
  @override
  String get homePageCancel => 'বাতিল করুন';
  @override
  String get homePageClickOnTheBottomRightButtonToStartAddingTasks =>
      'টাস্ক যোগ করা শুরু করতে নিচে ডানদিকে বোতামে ক্লিক করুন';
  @override
  String get homePageSearchNotFound => 'অনুসন্ধানে কিছু পাওয়া যায়নি';
  @override
  String get homePageFetchingTasks => 'টাস্ক আনা হচ্ছে';
  @override
  String get settingsPageTitle => 'সেটিংস পেজ';
  @override
  String get settingsPageSubtitle => 'আপনার পছন্দ সেট করুন';
  @override
  String get settingsPageMovingDataToNewDirectory =>
      'নতুন ডিরেক্টরিতে ডেটা স্থানান্তর করা হচ্ছে';
  @override
  String get settingsPageSyncOnStartTitle =>
      'অ্যাপ শুরুতে ডেটা স্বয়ংক্রিয়ভাবে সিঙ্ক করুন';
  @override
  String get settingsPageSyncOnStartDescription => 'শুরুতে সিঙ্ক করুন';
  @override
  String get settingsPageEnableSyncOnTaskCreateTitle =>
      'নতুন টাস্ক তৈরি করার সময় স্বয়ংক্রিয় সিঙ্কিং সক্ষম করুন';
  @override
  String get settingsPageEnableSyncOnTaskCreateDescription =>
      'নতুন টাস্ক তৈরি করার সময় স্বয়ংক্রিয় সিঙ্কিং সক্ষম করুন';
  @override
  String get settingsPageHighlightTaskTitle => 'জরুরি টাস্ক হাইলাইট করুন';
  @override
  String get settingsPageHighlightTaskDescription =>
      '1 দিনের মধ্যে বা অতিক্রান্ত সময়ের টাস্ক হাইলাইট করুন';
  @override
  String get settingsPageEnable24hrFormatTitle =>
      '24 ঘণ্টার ফর্ম্যাট সক্রিয় করুন';
  @override
  String get settingsPageEnable24hrFormatDescription =>
      '24 ঘণ্টার ফর্ম্যাট সক্রিয় করুন';
  @override
  String get settingsPageSelectLanguage => 'ভাষা নির্বাচন করুন';
  @override
  String get settingsPageToggleNativeLanguage =>
      'আপনার মাতৃভাষার মধ্যে টগল করুন';
  @override
  String get settingsPageSelectDirectoryTitle => 'ডিরেক্টরি নির্বাচন করুন';
  @override
  String get settingsPageSelectDirectoryDescription =>
      'টাস্কওয়ারিয়র ডেটা যেখানে সংরক্ষিত হয় সেই ডিরেক্টরি নির্বাচন করুন\nবর্তমান ডিরেক্টরি: ';
  @override
  String get settingsPageChangeDirectory => 'ডিরেক্টরি পরিবর্তন করুন';
  @override
  String get settingsPageSetToDefault => 'ডিফল্টে সেট করুন';
  @override
  String get navDrawerProfile => 'প্রোফাইল';
  @override
  String get navDrawerReports => 'রিপোর্টস';
  @override
  String get navDrawerAbout => 'সম্পর্কে';
  @override
  String get navDrawerSettings => 'সেটিংস';
  @override
  String get navDrawerExit => 'বাহির যান';

  @override
  String get detailPageDescription => 'বর্ণনা';
  @override
  String get detailPageStatus => 'অবস্থা';
  @override
  String get detailPageEntry => 'এন্ট্রি';
  @override
  String get detailPageModified => 'পরিবর্তিত';
  @override
  String get detailPageStart => 'শুরু';
  @override
  String get detailPageEnd => 'শেষ';
  @override
  String get detailPageDue => 'জরুরি';
  @override
  String get detailPageWait => 'অপেক্ষা করুন';
  @override
  String get detailPageUntil => 'পর্যন্ত';
  @override
  String get detailPagePriority => 'প্রাধান্য';
  @override
  String get detailPageProject => 'প্রকল্প';
  @override
  String get detailPageTags => 'ট্যাগ';
  @override
  String get detailPageUrgency => 'জরুরি';
  @override
  String get detailPageID => 'আইডি';

  @override
  String get filterDrawerApplyFilters => 'ফিল্টার প্রয়োগ করুন';
  @override
  String get filterDrawerHideWaiting => 'অপেক্ষা লুকান';
  @override
  String get filterDrawerShowWaiting => 'অপেক্ষা প্রদর্শন করুন';
  @override
  String get filterDrawerPending => 'মুলতুবি';
  @override
  String get filterDrawerCompleted => 'সম্পন্ন';
  @override
  String get filterDrawerDeleted => 'মুছে ফেলা হয়েছে';
  @override
  String get filterDrawerFilterTagBy => 'ট্যাগ দ্বারা ফিল্টার করুন';
  @override
  String get filterDrawerAND => 'এবং';
  @override
  String get filterDrawerOR => 'অথবা';
  @override
  String get filterDrawerSortBy => 'এর দ্বারা সাজান';
  @override
  String get filterDrawerCreated => 'সৃষ্ট';
  @override
  String get filterDrawerModified => 'পরিবর্তিত';
  @override
  String get filterDrawerStartTime => 'শুরুর সময়';
  @override
  String get filterDrawerDueTill => 'জরুরি পর্যন্ত';
  @override
  String get filterDrawerPriority => 'প্রাধান্য';
  @override
  String get filterDrawerProject => 'প্রকল্প';
  @override
  String get filterDrawerTags => 'ট্যাগস';
  @override
  String get filterDrawerUrgency => 'জরুরি';
  @override
  String get filterDrawerResetSort => 'সাজানো রিসেট করুন';
  @override
  String get filterDrawerStatus => 'অবস্থা';
  @override
  String get reportsPageTitle => 'রিপোর্টস';
  @override
  String get reportsPageCompleted => 'সম্পন্ন';
  @override
  String get reportsPagePending => 'মুলতুবি';
  @override
  String get reportsPageTasks => 'টাস্ক';

  @override
  String get reportsPageDaily => 'দৈনিক';
  @override
  String get reportsPageDailyBurnDownChart => 'দৈনিক বার্নডাউন চার্ট';
  @override
  String get reportsPageDailyDayMonth => 'দিন - মাস';

  @override
  String get reportsPageWeekly => 'সাপ্তাহিক';
  @override
  String get reportsPageWeeklyBurnDownChart => 'সাপ্তাহিক বার্নডাউন চার্ট';
  @override
  String get reportsPageWeeklyWeeksYear => 'সপ্তাহ - বছর';

  @override
  String get reportsPageMonthly => 'মাসিক';
  @override
  String get reportsPageMonthlyBurnDownChart => 'মাসিক বার্নডাউন চার্ট';
  @override
  String get reportsPageMonthlyMonthYear => 'মাস - বছর';

  @override
  String get reportsPageNoTasksFound => 'কোনও টাস্ক পাওয়া যায়নি';
  @override
  String get reportsPageAddTasksToSeeReports => 'রিপোর্ট দেখতে টাস্ক যোগ করুন';

  @override
  String get taskchampionTileDescription =>
      'Taskwarrior সিঙ্কিং CCSync বা Taskchampion সিঙ্ক সার্ভারে পরিবর্তন করুন';

  @override
  String get taskchampionTileTitle => 'Taskchampion সিঙ্ক';

  @override
  String get ccsyncCredentials => 'CCSync ক্রেডেনশিয়াল';

  @override
  String get deleteTaskConfirmation => 'টাস্ক মুছুন';

  @override
  String get deleteTaskTitle => 'সব টাস্ক মুছুন?';

  @override
  String get deleteTaskWarning =>
      'এই পদক্ষেপটি অপরিবর্তনীয় এবং সমস্ত স্থানীয়ভাবে সংরক্ষিত টাস্ক মুছে ফেলবে।';
  @override
  String get deleteAllTasksWillBeMarkedAsDeleted =>
      '\u099f\u09be\u09b8\u09cd\u0995\u09b0 \u09ac\u09a7\u09be \u09b8\u09be\u09b0\u09cd\u099a\u09c7 \u09a8\u09be\u09b9\u09c0\u0995\u09c7 \u0995\u09b0\u09c1\u09a8\u099f\u09be\u09b8\u09cd\u0995 \u0995\u09be\u09b0\u09cd\u092f\u09cb\u09b0 \u09b9\u09be\u09b7\u09c7 \u0995\u09b0\u09be\u09b8\u09cd\u09a4\u09c7 \u099f\u09be\u09b8\u09cd\u0995 \u0995\u09b0\u09c7\u0964';

  @override
  String get profilePageProfile => 'প্রোফাইল';
  @override
  String get profilePageProfiles => 'প্রোফাইলস';
  @override
  String get profilePageCurrentProfile => 'বর্তমান প্রোফাইল';
  @override
  String get profilePageManageSelectedProfile =>
      'নির্বাচিত প্রোফাইল পরিচালনা করুন';
  @override
  String get profilePageRenameAlias => 'অ্যালিয়াস পরিবর্তন করুন';

  @override
  String get profilePageConfigureTaskserver => 'টাস্ক সার্ভার কনফিগার করুন';
  @override
  String get profilePageExportTasks => 'টাস্ক রপ্তানী করুন';
  @override
  String get profilePageChangeProfileMode => 'সিঙ্ক সার্ভার পরিবর্তন করুন';
  @override
  String get profilePageSelectProfileMode => 'একটি সার্ভার নির্বাচন করুন';
  @override
  String get profilePageCopyConfigToNewProfile =>
      'নতুন প্রোফাইলে কনফিগারেশন কপি করুন';
  @override
  String get profilePageDeleteProfile => 'প্রোফাইল মুছুন';
  @override
  String get profilePageAddNewProfile => 'নতুন প্রোফাইল যোগ করুন';

  @override
  String get profilePageRenameAliasDialogueBoxTitle =>
      'অ্যালিয়াস পরিবর্তন করুন';
  @override
  String get profilePageRenameAliasDialogueBoxNewAlias => 'নতুন অ্যালিয়াস';
  @override
  String get profilePageRenameAliasDialogueBoxCancel => 'বাতিল করুন';
  @override
  String get profilePageRenameAliasDialogueBoxSubmit => 'জমা দিন';

  @override
  String get profilePageSuccessfullyChangedProfileModeTo =>
      'সফলভাবে প্রোফাইল মোড পরিবর্তিত হয়েছে: ';

  @override
  String get profilePageExportTasksDialogueTitle => 'রপ্তানি ফরম্যাট';
  @override
  String get profilePageExportTasksDialogueSubtitle =>
      'রপ্তানি ফরম্যাট নির্বাচন করুন';

  @override
  String get manageTaskServerPageConfigureTaskserver =>
      'টাস্ক সার্ভার কনফিগার করুন';
  @override
  String get manageTaskServerPageConfigureTASKRC => 'TASKRC কনফিগার করুন';
  @override
  String get manageTaskServerPageSetTaskRC => 'TaskRC সেট করুন';
  @override
  String get manageTaskServerPageConfigureYourCertificate =>
      'আপনার সার্টিফিকেট কনফিগার করুন';
  @override
  String get manageTaskServerPageSelectCertificate =>
      'সার্টিফিকেট নির্বাচন করুন';
  @override
  String get manageTaskServerPageConfigureTaskserverKey =>
      'টাস্ক সার্ভার কনফিগার করুন কী';
  @override
  String get manageTaskServerPageSelectKey => 'কী নির্বাচন করুন';
  @override
  String get manageTaskServerPageConfigureServerCertificate =>
      'সার্ভার সার্টিফিকেট কনফিগার করুন';
  @override
  String get manageTaskServerPageTaskRCFileIsVerified =>
      'Task RC ফাইল যাচাই করা হয়েছে';

  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxTitle =>
      'TaskRC কনফিগার করুন';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxSubtitle =>
      'TaskRC সামগ্রী পেস্ট করুন বা taskrc ফাইল নির্বাচন করুন';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxInputFieldText =>
      'এখানে আপনার TaskRC সামগ্রী পেস্ট করুন';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxOr => 'অথবা';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxSelectTaskRC =>
      'TaskRC ফাইল নির্বাচন করুন';

  @override
  String get addTaskTitle => "কার্য যোগ করুন";
  @override
  String get addTaskEnterTask => "কার্য লিখুন";
  @override
  String get addTaskDue => "শেষ সময়";
  @override
  String get addTaskSelectDueDate => "শেষ সময় নির্বাচন করুন";
  @override
  String get addTaskPriority => "অগ্রাধিকার";
  @override
  String get addTaskAddTags => "ট্যাগ যোগ করুন";
  @override
  String get addTaskCancel => "বাতিল করুন";
  @override
  String get addTaskAdd => "যোগ করুন";
  @override
  String get addTaskTimeInPast => "নির্বাচিত সময় অতীতে রয়েছে।";
  @override
  String get addTaskFieldCannotBeEmpty =>
      "আপনি এই ক্ষেত্রটি খালি ছেড়ে দিতে পারবেন না!";
  @override
  String get addTaskTaskAddedSuccessfully =>
      "কর্ম সফলভাবে যোগ করা হয়েছে। সম্পাদনার জন্য ট্যাপ করুন";

  @override
  String get aboutPageGitHubLink =>
      "এই প্রকল্পটিকে উন্নত করতে আগ্রহী? আমাদের GitHub রিপোজিটরিতে যান।";
  @override
  String get aboutPageProjectDescription =>
      "এই প্রকল্পের লক্ষ্য Taskwarrior-এর জন্য একটি অ্যাপ তৈরি করা। এটি আপনার সকল প্ল্যাটফর্মে একটি টাস্ক ম্যানেজমেন্ট অ্যাপ। এটি আপনাকে আপনার কাজগুলি পরিচালনা করতে এবং আপনার প্রয়োজন অনুসারে সেগুলি ফিল্টার করতে সাহায্য করে।";
  @override
  String get aboutPageAppBarTitle => "সম্পর্কিত";

  @override
  String get homePageSearchTooltip => 'অনুসন্ধান করুন';
  @override
  String get homePageCancelSearchTooltip => 'বাতিল করুন';
  @override
  String get homePageAddTaskTooltip => 'টাস্ক যোগ করুন';
  @override
  String get homePageTapBackToExit => 'প্রস্থান করতে আবার ব্যাক চাপুন';
  @override
  String get homePageSearchHint => 'অনুসন্ধান করুন';

  @override
  String get navDrawerConfirm => 'নিশ্চিত করুন';

  @override
  String get filterDrawerNoProjectsAvailable => 'কোনো প্রকল্প উপলব্ধ নেই।';

  @override
  String get version => "সংস্করণ";
  @override
  String get package => "প্যাকেজ";

  @override
  String get notSelected => "নির্বাচিত নয়";
  @override
  String get cantSetTimeinPast => "অতীতে সময় নির্ধারণ করা সম্ভব নয়";

  @override
  String get editDescription => "বিবরণ সম্পাদনা করুন";
  @override
  String get editProject => "প্রকল্প সম্পাদনা করুন";
  @override
  String get cancel => "বাতিল করুন";
  @override
  String get submit => "জমা দিন";

  @override
  String get saveChangesConfirmation =>
      'আপনি কি পরিবর্তনগুলি সংরক্ষণ করতে চান?';
  @override
  String get yes => 'হ্যাঁ';
  @override
  String get no => 'না';
  @override
  String get reviewChanges => 'পরিবর্তন পর্যালোচনা করুন';
  @override
  String get oldChanges => 'পুরানো';
  @override
  String get newChanges => 'নতুন';

  @override
  String get tags => 'ট্যাগ';
  @override
  String get addedTagsWillAppearHere => 'যোগ করা ট্যাগ এখানে প্রদর্শিত হবে';
  @override
  String get addTag => 'ট্যাগ যোগ করুন';

  @override
  String get enterProject => 'প্রকল্প প্রবেশ করান';
  @override
  String get allProjects => 'সমস্ত প্রকল্প';
  @override
  String get noProjectsFound => 'কোনো প্রকল্প পাওয়া যায়নি';
  @override
  String get project => 'প্রকল্প';

  @override
  String get select => 'নির্বাচন করুন';
  @override
  String get save => 'সংরক্ষণ করুন';
  @override
  String get dontSave => 'সংরক্ষণ করবেন না';
  @override
  String get unsavedChanges => 'সংরক্ষিত নয় এমন পরিবর্তন';
  @override
  String get unsavedChangesWarning =>
      'আপনার পরিবর্তনগুলি সংরক্ষিত হয়নি। আপনি কি করতে চান?';
  @override
  String get enterNew => 'নতুন লিখুন';
  @override
  String get edit => 'সম্পাদনা করুন';
  @override
  String get task => 'টাস্ক';

// task action strings
  @override
  String get confirmDeleteTask => 'মুছে ফেলার নিশ্চয়তা দিন';
  @override
  String get taskUpdated => 'টাস্ক আপডেট হয়েছে';
  @override
  String get undo => 'পূর্বাবস্থায় ফেরান';
  @override
  String get taskMarkedAsCompleted =>
      'টাস্ক সম্পন্ন হয়েছে। পরিবর্তন দেখতে রিফ্রেশ করুন!';
  @override
  String get taskMarkedAsDeleted =>
      'টাস্ক মুছে ফেলা হয়েছে। পরিবর্তন দেখতে রিফ্রেশ করুন!';
  @override
  String get refreshToViewChanges => 'পরিবর্তন দেখতে রিফ্রেশ করুন';
  @override
  String get clickOnBottomRightButtonToStartAddingTasks =>
      'টাস্ক যোগ করতে নিচের ডানদিকের বোতামে ক্লিক করুন';
  @override
  String get complete => 'সম্পন্ন';
  @override
  String get delete => 'মুছে ফেলুন';

// task server management strings
  @override
  String get taskServerInfo => 'TaskD সার্ভারের তথ্য';
  @override
  String get taskServerCredentials => 'TaskD সার্ভারের শংসাপত্র';
  @override
  String get notConfigured => 'কনফিগার করা হয়নি';
  @override
  String get fetchingStatistics => 'পরিসংখ্যান আনা হচ্ছে...';
  @override
  String get pleaseWait => 'অনুগ্রহ করে অপেক্ষা করুন...';
  @override
  String get statistics => 'পরিসংখ্যান:';
  @override
  String get ok => 'ঠিক আছে';
  @override
  String get pleaseSetupTaskServer =>
      'অনুগ্রহ করে আপনার TaskD সার্ভার সেটআপ করুন।';

// onboarding strings
  @override
  String get onboardingSkip => 'এড়িয়ে যান';
  @override
  String get onboardingNext => 'পরবর্তী';
  @override
  String get onboardingStart => 'শুরু করুন';

// permission strings
  @override
  String get permissionPageTitle => 'আমাদের আপনার অনুমতি কেন দরকার';
  @override
  String get storagePermissionTitle => 'সংগ্রহস্থল অনুমতি';
  @override
  String get storagePermissionDescription =>
      'আপনার ডিভাইসে টাস্ক, পছন্দ এবং অ্যাপের ডেটা নিরাপদে সংরক্ষণ করতে আমরা '
      'সংগ্রহস্থল অ্যাক্সেস ব্যবহার করি। এটি নিশ্চিত করে যে আপনি অফলাইনে থাকলেও '
      'আপনার কাজ অব্যাহত রাখতে পারবেন।';
  @override
  String get notificationPermissionTitle => 'বিজ্ঞপ্তি অনুমতি';
  @override
  String get notificationPermissionDescription =>
      'বিজ্ঞপ্তি আপনাকে গুরুত্বপূর্ণ অনুস্মারক এবং আপডেটগুলির বিষয়ে অবহিত রাখে, '
      'যাতে আপনি সহজেই আপনার কাজ পরিচালনা করতে পারেন।';
  @override
  String get privacyStatement =>
      'আপনার গোপনীয়তা আমাদের অগ্রাধিকার। আমরা আপনার ফাইল বা ব্যক্তিগত ডেটা '
      'আপনার অনুমতি ছাড়া কখনও অ্যাক্সেস বা ভাগ করি না।';
  @override
  String get grantPermissions => 'অনুমতি দিন';
  @override
  String get managePermissionsLater =>
      'আপনি পরে সেটিংস থেকে অনুমতিগুলি পরিচালনা করতে পারেন';

// Profile page strings
  @override
  String get profileAllProfiles => 'সমস্ত প্রোফাইল:';
  @override
  String get profileSwitchedToProfile => 'প্রোফাইল পরিবর্তন করা হয়েছে';
  @override
  String get profileAddedSuccessfully => 'প্রোফাইল সফলভাবে যোগ করা হয়েছে';
  @override
  String get profileAdditionFailed => 'প্রোফাইল যোগ করা ব্যর্থ হয়েছে';
  @override
  String get profileConfigCopied => 'প্রোফাইল কনফিগারেশন কপি করা হয়েছে';
  @override
  String get profileConfigCopyFailed => 'প্রোফাইল কনফিগারেশন কপি ব্যর্থ হয়েছে';
  @override
  String get profileDeletedSuccessfully => 'প্রোফাইল সফলভাবে মুছে ফেলা হয়েছে';
  @override
  String get profileDeletionFailed => 'প্রোফাইল মুছে ফেলা ব্যর্থ হয়েছে';
  @override
  String get profileDeleteConfirmation => 'আপনি কি প্রোফাইল মুছে ফেলতে চান?';

// Reports strings
  @override
  String get reportsDate => 'তারিখ';
  @override
  String get reportsPending => 'অপেক্ষমান';
  @override
  String get reportsCompleted => 'সম্পন্ন';
  @override
  String get reportsMonthYear => 'মাস-বছর';
  @override
  String get reportsWeek => 'সপ্তাহ';
  @override
  String get reportsDay => 'দিন';
  @override
  String get reportsYear => 'বছর';
  @override
  String get reportsError => 'ত্রুটি';
  @override
  String get reportsLoading => 'লোড হচ্ছে...';

// Settings strings
  @override
  String get settingsResetToDefault => 'ডিফল্টে রিসেট করুন';
  @override
  String get settingsAlreadyDefault => 'ইতিমধ্যে ডিফল্ট অবস্থানে রয়েছে';
  @override
  String get settingsConfirmReset =>
      'আপনি কি নিশ্চিত যে আপনি সেটিংস ডিফল্টে রিসেট করতে চান?';
  @override
  String get settingsNoButton => 'না';
  @override
  String get settingsYesButton => 'হ্যাঁ';

// Splash screen strings
  @override
  String get splashSettingUpApp => "অ্যাপ সেটআপ করা হচ্ছে...";

// Tour strings
  @override
  String get tourHomeAddTask => "নতুন টাস্ক যোগ করুন";
  @override
  String get tourHomeSearch => "টাস্ক অনুসন্ধান করুন";
  @override
  String get tourHomeRefresh => "আপনার টাস্ক রিফ্রেশ বা সিঙ্ক করুন";
  @override
  String get tourHomeFilter => "টাস্ক ও প্রকল্প ফিল্টার করুন";
  @override
  String get tourHomeMenu => "অতিরিক্ত সেটিংস অ্যাক্সেস করুন";

  @override
  String get tourDetailsDue => "টাস্কের নির্ধারিত সময় দেখুন";

  @override
  String get tourDetailsPriority => "টাস্কের অগ্রাধিকার নির্ধারণ করুন";

  @override
  String get tourDetailsUntil => "টাস্কের শেষ তারিখ দেখুন";

  @override
  String get tourDetailsWait => "টাস্কের অপেক্ষার সময় দেখুন";

  @override
  String get tourFilterProjects => "আপনার প্রকল্প ফিল্টার করুন";

  @override
  String get tourFilterSort => "টাস্ক সাজানোর বিকল্প দেখুন";

  @override
  String get tourFilterStatus => "টাস্কের বর্তমান অবস্থা দেখুন";

  @override
  String get tourFilterTagUnion => "ট্যাগ ফিল্টার করার নিয়ম সেট করুন";

  @override
  String get tourProfileAddNew => "একটি নতুন প্রোফাইল যোগ করুন";

  @override
  String get tourProfileCurrent => "বর্তমান প্রোফাইল দেখুন";

  @override
  String get tourProfileManage => "আপনার প্রোফাইল পরিচালনা করুন";

  @override
  String get tourReportsDaily => "দৈনিক প্রতিবেদন দেখুন";

  @override
  String get tourReportsMonthly => "মাসিক প্রতিবেদন দেখুন";

  @override
  String get tourReportsWeekly => "সাপ্তাহিক প্রতিবেদন দেখুন";

  @override
  String get tourTaskServerCertificate =>
      "আপনার TaskD সার্ভারের সার্টিফিকেট যোগ করুন";

  @override
  String get tourTaskServerKey => "আপনার TaskD সার্ভারের কী সেট করুন";

  @override
  String get tourTaskServerRootCert => "Root সার্টিফিকেট কনফিগার করুন";

  @override
  String get tourTaskServerTaskRC => "আপনার TaskRC ফাইল সেট করুন";
  @override
  String get descriprtionCannotBeEmpty => "বর্ণনা খালি হতে পারে না";
  @override
  String get enterTaskDescription => "টাস্কের বর্ণনা লিখুন";
  @override
  String get canNotHaveWhiteSpace => "সাদা স্থান থাকতে পারে না";
  @override
  String get high => "উচ্চ";
  @override
  String get medium => "মধ্যম";
  @override
  String get low => "নিম্ন";
  @override
  String get priority => "অগ্রাধিকার";
  @override
  String get tagAlreadyExists => "ট্যাগ ইতিমধ্যে বিদ্যমান";
  @override
  String get tagShouldNotContainSpaces => "ট্যাগে স্পেস থাকা উচিত নয়";
  @override
  String get date => "তারিখ";
  @override
  String get add => "যোগ করুন";
  @override
  String get change => "পরিবর্তন করুন";
  @override
  String get dateCanNotBeInPast => "তারিখ অতীতে থাকতে পারে না";
  @override
  String get configureTaskchampion => 'Taskchampion সিঙ্ক কনফিগার করুন';
  @override
  String get encryptionSecret => 'এনক্রিপশন সিক্রেট';
  @override
  String get ccsyncBackendUrl => 'CCSync ব্যাকএন্ড URL';
  @override
  String get ccsyncClientId => 'ক্লায়েন্ট আইডি';
  @override
  String get success => 'সফল হয়েছে';
  @override
  String get credentialsSavedSuccessfully => 'শংসাপত্র সফলভাবে সংরক্ষিত হয়েছে';
  @override
  String get saveCredentials => 'ক্রেডেনশিয়ালস সংরক্ষণ করুন';
  @override
  String get tip =>
      "টিপ: আপনার শংসাপত্র পেতে উপরের ডানদিকে তথ্য আইকনে ক্লিক করুন";
  @override
  String get logs => 'লগস';
  @override
  String get checkAllDebugLogsHere => 'এখানে সমস্ত ডিবাগ লগ পরীক্ষা করুন';
  // সেটিংস
  @override
  String get syncSetting => 'সিঙ্ক সেটিংস';
  @override
  String get displaySettings => 'প্রদর্শন সেটিংস';
  @override
  String get storageAndData => 'স্টোরেজ এবং ডাটা';
  @override
  String get advanced => 'উন্নত';
  @override
  String get taskchampionBackendUrl => 'Taskchampion ব্যাকএন্ড URL';
}
