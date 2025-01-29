import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/language/bengali_sentences.dart';

void main() {
  final bengali = BengaliSentences();

  test('should provide correct Bengali translations', () {
    expect(bengali.helloWorld, 'হ্যালো বিশ্ব!');
    expect(bengali.homePageTitle, 'হোম পেজ');
    expect(bengali.homePageLastModified, 'শেষবার পরিবর্তিত');
    expect(bengali.homePageDue, 'জরুরি');
    expect(bengali.homePageTaskWarriorNotConfigured,
        'TaskServer কনফিগার করা হয়নি');
    expect(bengali.homePageSetup, 'সেটআপ');
    expect(bengali.homePageFilter, 'ফিল্টার');
    expect(bengali.homePageMenu, 'মেনু');
    expect(bengali.homePageExitApp, 'অ্যাপ বন্ধ করুন');
    expect(bengali.homePageAreYouSureYouWantToExit,
        'আপনি কি সত্যিই অ্যাপ বন্ধ করতে চান?');
    expect(bengali.homePageExit, 'বাহির যান');
    expect(bengali.homePageCancel, 'বাতিল করুন');
    expect(bengali.homePageClickOnTheBottomRightButtonToStartAddingTasks,
        'টাস্ক যোগ করা শুরু করতে নিচে ডানদিকে বোতামে ক্লিক করুন');
    expect(bengali.homePageSearchNotFound, 'অনুসন্ধানে কিছু পাওয়া যায়নি');
    expect(bengali.settingsPageTitle, 'সেটিংস পেজ');
    expect(bengali.settingsPageSubtitle, 'আপনার পছন্দ সেট করুন');
    expect(bengali.settingsPageMovingDataToNewDirectory,
        'নতুন ডিরেক্টরিতে ডেটা স্থানান্তর করা হচ্ছে');
    expect(bengali.settingsPageSyncOnStartTitle,
        'অ্যাপ শুরুতে ডেটা স্বয়ংক্রিয়ভাবে সিঙ্ক করুন');
    expect(bengali.settingsPageSyncOnStartDescription, 'শুরুতে সিঙ্ক করুন');
    expect(bengali.settingsPageEnableSyncOnTaskCreateTitle,
        'নতুন টাস্ক তৈরি করার সময় স্বয়ংক্রিয় সিঙ্কিং সক্ষম করুন');
    expect(bengali.settingsPageEnableSyncOnTaskCreateDescription,
        'নতুন টাস্ক তৈরি করার সময় স্বয়ংক্রিয় সিঙ্কিং সক্ষম করুন');
    expect(bengali.settingsPageHighlightTaskTitle,
        'শুধু 1 দিন বাকি থাকলে টাস্ক হাইলাইট করুন');
    expect(bengali.settingsPageHighlightTaskDescription,
        'শুধু 1 দিন বাকি থাকলে টাস্ক হাইলাইট করুন');
    expect(bengali.settingsPageEnable24hrFormatTitle,
        '24 ঘণ্টার ফর্ম্যাট সক্রিয় করুন');
    expect(bengali.settingsPageEnable24hrFormatDescription,
        '24 ঘণ্টার ফর্ম্যাট সক্রিয় করুন');
    expect(bengali.settingsPageSelectLanguage, 'ভাষা নির্বাচন করুন');
    expect(bengali.settingsPageToggleNativeLanguage,
        'আপনার মাতৃভাষার মধ্যে টগল করুন');
    expect(bengali.settingsPageSelectDirectoryTitle, 'ডিরেক্টরি নির্বাচন করুন');
    expect(bengali.settingsPageSelectDirectoryDescription,
        'টাস্কওয়ারিয়র ডেটা যেখানে সংরক্ষিত হয় সেই ডিরেক্টরি নির্বাচন করুন\nবর্তমান ডিরেক্টরি: ');
    expect(bengali.settingsPageChangeDirectory, 'ডিরেক্টরি পরিবর্তন করুন');
    expect(bengali.settingsPageSetToDefault, 'ডিফল্টে সেট করুন');
    expect(bengali.navDrawerProfile, 'প্রোফাইল');
    expect(bengali.navDrawerReports, 'রিপোর্টস');
    expect(bengali.navDrawerAbout, 'সম্পর্কে');
    expect(bengali.navDrawerSettings, 'সেটিংস');
    expect(bengali.navDrawerExit, 'বাহির যান');
    expect(bengali.detailPageDescription, 'বর্ণনা');
    expect(bengali.detailPageStatus, 'অবস্থা');
    expect(bengali.detailPageEntry, 'এন্ট্রি');
    expect(bengali.detailPageModified, 'পরিবর্তিত');
    expect(bengali.detailPageStart, 'শুরু');
    expect(bengali.detailPageEnd, 'শেষ');
    expect(bengali.detailPageDue, 'জরুরি');
    expect(bengali.detailPageWait, 'অপেক্ষা করুন');
    expect(bengali.detailPageUntil, 'পর্যন্ত');
    expect(bengali.detailPagePriority, 'প্রাধান্য');
    expect(bengali.detailPageProject, 'প্রকল্প');
    expect(bengali.detailPageTags, 'ট্যাগ');
    expect(bengali.detailPageUrgency, 'জরুরি');
    expect(bengali.detailPageID, 'আইডি');
    expect(bengali.filterDrawerApplyFilters, 'ফিল্টার প্রয়োগ করুন');
    expect(bengali.filterDrawerHideWaiting, 'অপেক্ষা লুকান');
    expect(bengali.filterDrawerShowWaiting, 'অপেক্ষা প্রদর্শন করুন');
    expect(bengali.filterDrawerPending, 'মুলতুবি');
    expect(bengali.filterDrawerCompleted, 'সম্পন্ন');
    expect(bengali.filterDrawerFilterTagBy, 'ট্যাগ দ্বারা ফিল্টার করুন');
    expect(bengali.filterDrawerAND, 'এবং');
    expect(bengali.filterDrawerOR, 'অথবা');
    expect(bengali.filterDrawerSortBy, 'এর দ্বারা সাজান');
    expect(bengali.filterDrawerCreated, 'সৃষ্ট');
    expect(bengali.filterDrawerModified, 'পরিবর্তিত');
    expect(bengali.filterDrawerStartTime, 'শুরুর সময়');
    expect(bengali.filterDrawerDueTill, 'জরুরি পর্যন্ত');
    expect(bengali.filterDrawerPriority, 'প্রাধান্য');
    expect(bengali.filterDrawerProject, 'প্রকল্প');
    expect(bengali.filterDrawerTags, 'ট্যাগস');
    expect(bengali.filterDrawerUrgency, 'জরুরি');
    expect(bengali.filterDrawerResetSort, 'সাজানো রিসেট করুন');
    expect(bengali.filterDrawerStatus, 'অবস্থা');
    expect(bengali.reportsPageTitle, 'রিপোর্টস');
    expect(bengali.reportsPageCompleted, 'সম্পন্ন');
    expect(bengali.reportsPagePending, 'মুলতুবি');
    expect(bengali.reportsPageTasks, 'টাস্ক');
    expect(bengali.reportsPageDaily, 'দৈনিক');
    expect(bengali.reportsPageDailyBurnDownChart, 'দৈনিক বার্নডাউন চার্ট');
    expect(bengali.reportsPageDailyDayMonth, 'দিন - মাস');
    expect(bengali.reportsPageWeekly, 'সাপ্তাহিক');
    expect(bengali.reportsPageWeeklyBurnDownChart, 'সাপ্তাহিক বার্নডাউন চার্ট');
    expect(bengali.reportsPageWeeklyWeeksYear, 'সপ্তাহ - বছর');
    expect(bengali.reportsPageMonthly, 'মাসিক');
    expect(bengali.reportsPageMonthlyBurnDownChart, 'মাসিক বার্নডাউন চার্ট');
    expect(bengali.reportsPageMonthlyMonthYear, 'মাস - বছর');
    expect(bengali.reportsPageNoTasksFound, 'কোনও টাস্ক পাওয়া যায়নি');
    expect(bengali.reportsPageAddTasksToSeeReports,
        'রিপোর্ট দেখতে টাস্ক যোগ করুন');
    expect(bengali.taskchampionTileDescription,
        'Taskwarrior সিঙ্কিং CCSync বা Taskchampion সিঙ্ক সার্ভারে পরিবর্তন করুন');
    expect(bengali.taskchampionTileTitle, 'Taskchampion সিঙ্ক');
    expect(bengali.ccsyncCredentials, 'CCSync ক্রেডেনশিয়াল');
    expect(bengali.deleteTaskConfirmation, 'টাস্ক মুছুন');
    expect(bengali.deleteTaskTitle, 'সব টাস্ক মুছুন?');
    expect(bengali.deleteTaskWarning,
        'এই পদক্ষেপটি অপরিবর্তনীয় এবং সমস্ত স্থানীয়ভাবে সংরক্ষিত টাস্ক মুছে ফেলবে।');
    expect(bengali.profilePageProfile, 'প্রোফাইল');
    expect(bengali.profilePageProfiles, 'প্রোফাইলস');
    expect(bengali.profilePageCurrentProfile, 'বর্তমান প্রোফাইল');
    expect(bengali.profilePageManageSelectedProfile,
        'নির্বাচিত প্রোফাইল পরিচালনা করুন');
    expect(bengali.profilePageRenameAlias, 'অ্যালিয়াস পরিবর্তন করুন');
    expect(
        bengali.profilePageConfigureTaskserver, 'টাস্ক সার্ভার কনফিগার করুন');
    expect(bengali.profilePageExportTasks, 'টাস্ক রপ্তানী করুন');
    expect(bengali.profilePageCopyConfigToNewProfile,
        'নতুন প্রোফাইলে কনফিগারেশন কপি করুন');
    expect(bengali.profilePageDeleteProfile, 'প্রোফাইল মুছুন');
    expect(bengali.profilePageAddNewProfile, 'নতুন প্রোফাইল যোগ করুন');
    expect(bengali.profilePageRenameAliasDialogueBoxTitle,
        'অ্যালিয়াস পরিবর্তন করুন');
    expect(
        bengali.profilePageRenameAliasDialogueBoxNewAlias, 'নতুন অ্যালিয়াস');
    expect(bengali.profilePageRenameAliasDialogueBoxCancel, 'বাতিল করুন');
    expect(bengali.profilePageRenameAliasDialogueBoxSubmit, 'জমা দিন');
    expect(bengali.profilePageExportTasksDialogueTitle, 'রপ্তানি ফরম্যাট');
    expect(bengali.profilePageExportTasksDialogueSubtitle,
        'রপ্তানি ফরম্যাট নির্বাচন করুন');
    expect(bengali.manageTaskServerPageConfigureTaskserver,
        'টাস্ক সার্ভার কনফিগার করুন');
    expect(bengali.manageTaskServerPageConfigureTASKRC, 'TASKRC কনফিগার করুন');
    expect(bengali.manageTaskServerPageSetTaskRC, 'TaskRC সেট করুন');
    expect(bengali.manageTaskServerPageConfigureYourCertificate,
        'আপনার সার্টিফিকেট কনফিগার করুন');
    expect(bengali.manageTaskServerPageSelectCertificate,
        'সার্টিফিকেট নির্বাচন করুন');
    expect(bengali.manageTaskServerPageConfigureTaskserverKey,
        'টাস্ক সার্ভার কনফিগার করুন কী');
    expect(bengali.manageTaskServerPageSelectKey, 'কী নির্বাচন করুন');
    expect(bengali.manageTaskServerPageConfigureServerCertificate,
        'সার্ভার সার্টিফিকেট কনফিগার করুন');
    expect(bengali.manageTaskServerPageTaskRCFileIsVerified,
        'Task RC ফাইল যাচাই করা হয়েছে');
    expect(bengali.manageTaskServerPageConfigureTaskRCDialogueBoxTitle,
        'TaskRC কনফিগার করুন');
    expect(bengali.manageTaskServerPageConfigureTaskRCDialogueBoxSubtitle,
        'TaskRC সামগ্রী পেস্ট করুন বা taskrc ফাইল নির্বাচন করুন');
    expect(bengali.manageTaskServerPageConfigureTaskRCDialogueBoxInputFieldText,
        'এখানে আপনার TaskRC সামগ্রী পেস্ট করুন');
    expect(bengali.manageTaskServerPageConfigureTaskRCDialogueBoxOr, 'অথবা');
    expect(bengali.manageTaskServerPageConfigureTaskRCDialogueBoxSelectTaskRC,
        'TaskRC ফাইল নির্বাচন করুন');
    expect(bengali.addTaskTitle, 'কার্য যোগ করুন');
    expect(bengali.addTaskEnterTask, 'কার্য লিখুন');
    expect(bengali.addTaskDue, 'শেষ সময়');
    expect(bengali.addTaskSelectDueDate, 'শেষ সময় নির্বাচন করুন');
    expect(bengali.addTaskPriority, 'অগ্রাধিকার');
    expect(bengali.addTaskAddTags, 'ট্যাগ যোগ করুন');
    expect(bengali.addTaskCancel, 'বাতিল করুন');
    expect(bengali.addTaskAdd, 'যোগ করুন');
    expect(bengali.addTaskTimeInPast, 'নির্বাচিত সময় অতীতে রয়েছে।');
    expect(bengali.addTaskFieldCannotBeEmpty,
        'আপনি এই ক্ষেত্রটি খালি ছেড়ে দিতে পারবেন না!');
    expect(bengali.addTaskTaskAddedSuccessfully,
        'কর্ম সফলভাবে যোগ করা হয়েছে। সম্পাদনার জন্য ট্যাপ করুন');
    expect(bengali.aboutPageGitHubLink,
        'এই প্রকল্পটিকে উন্নত করতে আগ্রহী? আমাদের GitHub রিপোজিটরিতে যান।');
    expect(bengali.aboutPageProjectDescription,
        'এই প্রকল্পের লক্ষ্য Taskwarrior-এর জন্য একটি অ্যাপ তৈরি করা। এটি আপনার সকল প্ল্যাটফর্মে একটি টাস্ক ম্যানেজমেন্ট অ্যাপ। এটি আপনাকে আপনার কাজগুলি পরিচালনা করতে এবং আপনার প্রয়োজন অনুসারে সেগুলি ফিল্টার করতে সাহায্য করে।');
    expect(bengali.aboutPageAppBarTitle, 'সম্পর্কিত');
  });
}
