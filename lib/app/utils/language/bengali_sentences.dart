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
  String get settingsPageHighlightTaskTitle =>
      'শুধু 1 দিন বাকি থাকলে টাস্ক হাইলাইট করুন';
  @override
  String get settingsPageHighlightTaskDescription =>
      'শুধু 1 দিন বাকি থাকলে টাস্ক হাইলাইট করুন';
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
}
