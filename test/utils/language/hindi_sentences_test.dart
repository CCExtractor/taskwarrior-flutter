import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/language/hindi_sentences.dart';

void main() {
  final hindi = HindiSentences();

  test('should provide correct Hindi translations', () {
    expect(hindi.helloWorld, 'नमस्ते दुनिया!');
    expect(hindi.homePageTitle, 'होम पेज');
    expect(hindi.homePageLastModified, 'अंतिम बार संशोधित');
    expect(hindi.homePageDue, 'देय');
    expect(
        hindi.homePageTaskWarriorNotConfigured, 'TaskServer कॉन्फ़िगर नहीं है');
    expect(hindi.homePageSetup, 'सेटअप');
    expect(hindi.homePageFilter, 'फ़िल्टर');
    expect(hindi.homePageMenu, 'मेन्यू');
    expect(hindi.homePageExitApp, 'ऐप बंद करें');
    expect(hindi.homePageAreYouSureYouWantToExit,
        'क्या आप वाकई ऐप बंद करना चाहते हैं?');
    expect(hindi.homePageExit, 'बाहर जाओ');
    expect(hindi.homePageCancel, 'रद्द करें');
    expect(hindi.homePageClickOnTheBottomRightButtonToStartAddingTasks,
        'कार्यों को जोड़ना शुरू करने के लिए नीचे दाएं बटन पर क्लिक करें');
    expect(hindi.homePageSearchNotFound, 'खोजने पर नहीं मिला');
    expect(hindi.settingsPageTitle, 'सेटिंग्स पेज');
    expect(hindi.settingsPageSubtitle, 'अपनी पसंद सेट करें');
    expect(hindi.settingsPageMovingDataToNewDirectory,
        'नए निर्देशिका में डेटा को ले जा रहा है');
    expect(hindi.settingsPageSyncOnStartTitle,
        'ऐप स्टार्ट पर डेटा स्वचालित सिंक करें');
    expect(hindi.settingsPageSyncOnStartDescription, 'स्टार्ट पर सिंक करें');
    expect(hindi.settingsPageEnableSyncOnTaskCreateTitle,
        'नई टास्क बनाते समय स्वचालित सिंकिंग सक्षम करें');
    expect(hindi.settingsPageEnableSyncOnTaskCreateDescription,
        'नई टास्क बनाते समय स्वचालित सिंकिंग सक्षम करें');
    expect(
        hindi.settingsPageHighlightTaskTitle, 'तत्काल कार्यों को हाइलाइट करें');
    expect(hindi.settingsPageHighlightTaskDescription,
        '1 दिन के भीतर देय या अतिदेय कार्यों को हाइलाइट करें');
    expect(hindi.settingsPageEnable24hrFormatTitle,
        '24 घंटे का प्रारूप सक्षम करें');
    expect(hindi.settingsPageEnable24hrFormatDescription,
        '24 घंटे का प्रारूप सक्षम करें');
    expect(hindi.settingsPageSelectLanguage, 'भाषा चुनें');
    expect(hindi.settingsPageToggleNativeLanguage,
        'अपनी मातृभाषा के बीच टॉगल करें');
    expect(hindi.settingsPageSelectDirectoryTitle, 'निर्देशिका चुनें');
    expect(hindi.settingsPageSelectDirectoryDescription,
        'निर्देशिका चुनें जहां Taskwarrior डेटा स्टोर होता है\nवर्तमान निर्देशिका: ');
    expect(hindi.settingsPageChangeDirectory, 'निर्देशिका बदलें');
    expect(hindi.settingsPageSetToDefault, 'डिफॉल्ट पर सेट करें');
    expect(hindi.navDrawerProfile, 'प्रोफ़ाइल');
    expect(hindi.navDrawerReports, 'रिपोर्ट्स');
    expect(hindi.navDrawerAbout, 'के बारे में');
    expect(hindi.navDrawerSettings, 'सेटिंग्स');
    expect(hindi.navDrawerExit, 'बाहर जाओ');
    expect(hindi.detailPageDescription, 'विवरण');
    expect(hindi.detailPageStatus, 'स्थिति');
    expect(hindi.detailPageEntry, 'प्रवेश');
    expect(hindi.detailPageModified, 'संशोधित');
    expect(hindi.detailPageStart, 'प्रारंभ');
    expect(hindi.detailPageEnd, 'अंत');
    expect(hindi.detailPageDue, 'देय');
    expect(hindi.detailPageWait, 'प्रतीक्षा करें');
    expect(hindi.detailPageUntil, 'तक');
    expect(hindi.detailPagePriority, 'प्राथमिकता');
    expect(hindi.detailPageProject, 'परियोजना');
    expect(hindi.detailPageTags, 'टैग');
    expect(hindi.detailPageUrgency, 'तत्कालता');
    expect(hindi.detailPageID, 'आयडी');
    expect(hindi.filterDrawerApplyFilters, 'फिल्टर लागू करें');
    expect(hindi.filterDrawerHideWaiting, 'इंतजार छिपाएं');
    expect(hindi.filterDrawerShowWaiting, 'इंतजार दिखाएं');
    expect(hindi.filterDrawerPending, 'अपूर्ण');
    expect(hindi.filterDrawerCompleted, 'पूर्ण');
    expect(hindi.filterDrawerDeleted, 'हटाए गए');
    expect(hindi.filterDrawerFilterTagBy, 'टैग से फ़िल्टर करें');
    expect(hindi.filterDrawerAND, 'और');
    expect(hindi.filterDrawerOR, 'या');
    expect(hindi.filterDrawerSortBy, 'इसके आधार पर क्रमबद्ध करें');
    expect(hindi.filterDrawerCreated, 'निर्मित');
    expect(hindi.filterDrawerModified, 'संशोधित');
    expect(hindi.filterDrawerStartTime, 'शुरुआत समय');
    expect(hindi.filterDrawerDueTill, 'तक बकाया');
    expect(hindi.filterDrawerPriority, 'प्राथमिकता');
    expect(hindi.filterDrawerProject, 'परियोजना');
    expect(hindi.filterDrawerTags, 'टैग्स');
    expect(hindi.filterDrawerUrgency, 'तत्कालता');
    expect(hindi.filterDrawerResetSort, 'सॉर्ट रीसेट करें');
    expect(hindi.filterDrawerStatus, 'स्थिती');
    expect(hindi.reportsPageTitle, 'रिपोर्ट्स');
    expect(hindi.reportsPageCompleted, 'पूर्ण');
    expect(hindi.reportsPagePending, 'अपूर्ण');
    expect(hindi.reportsPageTasks, 'कार्य');
    expect(hindi.reportsPageDaily, 'दैनिक');
    expect(hindi.reportsPageDailyBurnDownChart, 'दैनिक बर्न डाउन चार्ट');
    expect(hindi.reportsPageDailyDayMonth, 'दिन - माह');
    expect(hindi.reportsPageWeekly, 'साप्ताहिक');
    expect(hindi.reportsPageWeeklyBurnDownChart, 'साप्ताहिक बर्न डाउन चार्ट');
    expect(hindi.reportsPageWeeklyWeeksYear, 'सप्ताह - वर्ष');
    expect(hindi.reportsPageMonthly, 'मासिक');
    expect(hindi.reportsPageMonthlyBurnDownChart, 'मासिक बर्न डाउन चार्ट');
    expect(hindi.reportsPageMonthlyMonthYear, 'माह - वर्ष');
    expect(hindi.reportsPageNoTasksFound, 'कोई कार्य नहीं मिला');
    expect(hindi.reportsPageAddTasksToSeeReports,
        'रिपोर्ट देखने के लिए कार्य जोड़ें');
    expect(hindi.taskchampionTileDescription,
        'CCSync या Taskchampion सिंक सर्वर के साथ Taskwarrior सिंक पर स्विच करें');
    expect(hindi.taskchampionTileTitle, 'Taskchampion सिंक');
    expect(hindi.ccsyncCredentials, 'CCync क्रेडेन्शियल');
    expect(hindi.deleteTaskConfirmation, 'कार्य हटाएं');
    expect(hindi.deleteTaskTitle, 'सभी कार्य हटाएं?');
    expect(hindi.deleteTaskWarning,
        'यह क्रिया अपरिवर्तनीय है और यह सभी स्थानीय रूप से संग्रहीत कार्यों को हटा देगी।');
    expect(hindi.profilePageProfile, 'प्रोफ़ाइल');
    expect(hindi.profilePageProfiles, 'प्रोफ़ाइल्स');
    expect(hindi.profilePageCurrentProfile, 'वर्तमान प्रोफ़ाइल');
    expect(hindi.profilePageManageSelectedProfile,
        'चुनी हुई प्रोफ़ाइल प्रबंधित करें');
    expect(hindi.profilePageRenameAlias, 'उपनाम बदलें');
    expect(hindi.profilePageConfigureTaskserver, 'टास्क सर्वर कॉन्फ़िगर करें');
    expect(hindi.profilePageExportTasks, 'कार्य निर्यात करें');
    expect(hindi.profilePageCopyConfigToNewProfile,
        'नई प्रोफ़ाइल पर कॉन्फ़िगरेशन कॉपी करें');
    expect(hindi.profilePageDeleteProfile, 'प्रोफ़ाइल हटाएँ');
    expect(hindi.profilePageAddNewProfile, 'नई प्रोफ़ाइल जोड़ें');
    expect(hindi.profilePageRenameAliasDialogueBoxTitle, 'उपनाम बदलें');
    expect(hindi.profilePageRenameAliasDialogueBoxNewAlias, 'नया उपनाम');
    expect(hindi.profilePageRenameAliasDialogueBoxCancel, 'रद्द करें');
    expect(hindi.profilePageRenameAliasDialogueBoxSubmit, 'प्रस्तुत करें');
    expect(hindi.profilePageExportTasksDialogueTitle, 'निर्यात प्रारूप');
    expect(
        hindi.profilePageExportTasksDialogueSubtitle, 'निर्यात प्रारूप चुनें');
    expect(hindi.manageTaskServerPageConfigureTaskserver,
        'टास्क सर्वर कॉन्फ़िगर करें');
    expect(hindi.manageTaskServerPageConfigureTASKRC, 'TASKRC कॉन्फ़िगर करें');
    expect(hindi.manageTaskServerPageSetTaskRC, 'TaskRC सेट करें');
    expect(hindi.manageTaskServerPageConfigureYourCertificate,
        'अपने सर्टिफिकेट को कॉन्फ़िगर करें');
    expect(hindi.manageTaskServerPageSelectCertificate, 'सर्टिफिकेट चुनें');
    expect(hindi.manageTaskServerPageConfigureTaskserverKey,
        'टास्क सर्वर की कॉन्फ़िगर करें');
    expect(hindi.manageTaskServerPageSelectKey, 'कुंजी चुनें');
    expect(hindi.manageTaskServerPageConfigureServerCertificate,
        'सर्वर सर्टिफिकेट कॉन्फ़िगर करें');
    expect(hindi.manageTaskServerPageTaskRCFileIsVerified,
        'Task RC फ़ाइल सत्यापित की गई है');
    expect(hindi.manageTaskServerPageConfigureTaskRCDialogueBoxTitle,
        'TaskRC कॉन्फ़िगर करें');
    expect(hindi.manageTaskServerPageConfigureTaskRCDialogueBoxSubtitle,
        'TaskRC सामग्री पेस्ट करें या taskrc फ़ाइल चुनें');
    expect(hindi.manageTaskServerPageConfigureTaskRCDialogueBoxInputFieldText,
        'यहाँ अपनी TaskRC सामग्री पेस्ट करें');
    expect(hindi.manageTaskServerPageConfigureTaskRCDialogueBoxOr, 'या');
    expect(hindi.manageTaskServerPageConfigureTaskRCDialogueBoxSelectTaskRC,
        'TaskRC फ़ाइल चुनें');
    expect(hindi.addTaskTitle, 'कार्य जोड़ें');
    expect(hindi.addTaskEnterTask, 'कार्य दर्ज करें');
    expect(hindi.addTaskDue, 'देय');
    expect(hindi.addTaskSelectDueDate, 'नियत तिथि चुनें');
    expect(hindi.addTaskPriority, 'प्राथमिकता');
    expect(hindi.addTaskAddTags, 'टैग जोड़ें');
    expect(hindi.addTaskCancel, 'रद्द करें');
    expect(hindi.addTaskAdd, 'जोड़ें');
    expect(hindi.addTaskTimeInPast, 'चुनी गई समय अतीत में है।');
    expect(hindi.addTaskFieldCannotBeEmpty,
        'आप इस फ़ील्ड को खाली नहीं छोड़ सकते!');
    expect(hindi.addTaskTaskAddedSuccessfully,
        'कार्य सफलतापूर्वक जोड़ा गया। संपादित करने के लिए टैप करें');
    expect(hindi.aboutPageGitHubLink,
        'इस परियोजना को बढ़ाने के लिए उत्सुक हैं? हमारे GitHub रिपॉज़िटरी पर जाएं।');
    expect(hindi.aboutPageProjectDescription,
        'यह परियोजना Taskwarrior के लिए एक ऐप बनाने का लक्ष्य रखती है। यह आपके सभी प्लेटफार्मों पर कार्य प्रबंधन ऐप है। यह आपको अपने कार्यों को प्रबंधित करने और उन्हें अपनी आवश्यकताओं के अनुसार छानने में मदद करता है।');
    expect(hindi.aboutPageAppBarTitle, 'के बारे में');
  });
}
