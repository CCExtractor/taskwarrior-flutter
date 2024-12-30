import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/language/marathi_sentences.dart';

void main() {
  final marathi = MarathiSentences();

  test('should provide correct Marathi translations', () {
    expect(marathi.helloWorld, 'नमस्कार, जग!');
    expect(marathi.homePageTitle, 'होम पेज');
    expect(marathi.homePageLastModified, 'शेवटचा बदल');
    expect(marathi.homePageDue, 'द्यावे');
    expect(marathi.homePageTaskWarriorNotConfigured, 'TaskServer संरचीत नाही');
    expect(marathi.homePageSetup, 'सेटअप');
    expect(marathi.homePageFilter, 'फिल्टर');
    expect(marathi.homePageMenu, 'मेनू');
    expect(marathi.homePageExitApp, 'अ‍ॅप बंद करा');
    expect(marathi.homePageAreYouSureYouWantToExit,
        'आपण खात्री आहात की आपण अ‍ॅप बंद करू इच्छिता?');
    expect(marathi.homePageExit, 'बाहेर पडा');
    expect(marathi.homePageCancel, 'रद्द करा');
    expect(marathi.homePageClickOnTheBottomRightButtonToStartAddingTasks,
        'कार्ये जोडणे सुरू करण्यासाठी तळाशी उजव्या बटणावर क्लिक करा');
    expect(marathi.homePageSearchNotFound, 'शोध सापडला नाही');
    expect(marathi.settingsPageTitle, 'सेटिंग्स पेज');
    expect(marathi.settingsPageSubtitle, 'तुमची पसंती सेट करा');
    expect(marathi.settingsPageMovingDataToNewDirectory,
        'नवीन निर्देशिकेत डेटा हलवत आहे');
    expect(marathi.settingsPageSyncOnStartTitle, 'सुरू करण्यावर सिंक करा');
    expect(marathi.settingsPageSyncOnStartDescription,
        'अ‍ॅप सुरू करताना डेटा स्वयंसिंक करा');
    expect(marathi.settingsPageEnableSyncOnTaskCreateTitle,
        'नवीन कार्य तयार करताना स्वयंसिंकिंग सक्षम करा');
    expect(marathi.settingsPageEnableSyncOnTaskCreateDescription,
        'नवीन कार्य तयार करताना स्वयंसिंकिंग सक्षम करा');
    expect(marathi.settingsPageHighlightTaskTitle,
        'फक्त 1 दिवस शेष असताना कार्याची सीमा बनवा');
    expect(marathi.settingsPageHighlightTaskDescription,
        'फक्त 1 दिवस शेष असताना कार्याची सीमा बनवा');
    expect(marathi.settingsPageEnable24hrFormatTitle,
        '24 तासाचा स्वरूप सक्षम करा');
    expect(marathi.settingsPageEnable24hrFormatDescription,
        '24 तासाचा स्वरूप सक्षम करा');
    expect(marathi.settingsPageSelectLanguage, 'भाषा निवडा');
    expect(marathi.settingsPageToggleNativeLanguage,
        'तुमच्या मूल भाषेतर्फे टॉगल करा');
    expect(marathi.settingsPageSelectDirectoryTitle, 'निर्देशिका निवडा');
    expect(marathi.settingsPageSelectDirectoryDescription,
        'निर्देशिका निवडा जिथे Taskwarrior डेटा स्टोर केला जातो\nवर्तमान निर्देशिका: ');
    expect(marathi.settingsPageChangeDirectory, 'डिरेक्टरी बदला');
    expect(marathi.settingsPageSetToDefault, 'डीफॉल्टवर सेट करा');
    expect(marathi.navDrawerProfile, 'प्रोफ़ाइल');
    expect(marathi.navDrawerReports, 'अहवाल');
    expect(marathi.navDrawerAbout, 'चरित्र');
    expect(marathi.navDrawerSettings, 'सेटिंग्स');
    expect(marathi.navDrawerExit, 'बाहेर पडा');
    expect(marathi.detailPageDescription, 'वर्णन');
    expect(marathi.detailPageStatus, 'स्थिती');
    expect(marathi.detailPageEntry, 'प्रवेश');
    expect(marathi.detailPageModified, 'संशोधित');
    expect(marathi.detailPageStart, 'सुरूवात');
    expect(marathi.detailPageEnd, 'शेवट');
    expect(marathi.detailPageDue, 'देय');
    expect(marathi.detailPageWait, 'प्रतीक्षा');
    expect(marathi.detailPageUntil, 'पर्यंत');
    expect(marathi.detailPagePriority, 'प्राधान्य');
    expect(marathi.detailPageProject, 'प्रकल्प');
    expect(marathi.detailPageTags, 'टॅग');
    expect(marathi.detailPageUrgency, 'तातडी');
    expect(marathi.detailPageID, 'आयडी');
    expect(marathi.filterDrawerApplyFilters, 'फिल्टर लागू करा');
    expect(marathi.filterDrawerHideWaiting, 'वाट लपवा');
    expect(marathi.filterDrawerShowWaiting, 'वाट दाखवा');
    expect(marathi.filterDrawerPending, 'प्रलंबित');
    expect(marathi.filterDrawerCompleted, 'पूर्ण');
    expect(marathi.filterDrawerFilterTagBy, 'टॅगवर फिल्टर करा');
    expect(marathi.filterDrawerAND, 'आणि');
    expect(marathi.filterDrawerOR, 'किंवा');
    expect(marathi.filterDrawerSortBy, 'यानुसार क्रमबद्ध करा');
    expect(marathi.filterDrawerCreated, 'सृष्ट');
    expect(marathi.filterDrawerModified, 'संशोधित');
    expect(marathi.filterDrawerStartTime, 'सुरूवातीचा वेळ');
    expect(marathi.filterDrawerDueTill, 'पर्यंतचा देय');
    expect(marathi.filterDrawerPriority, 'प्राधान्य');
    expect(marathi.filterDrawerProject, 'प्रकल्प');
    expect(marathi.filterDrawerTags, 'टॅग्ज');
    expect(marathi.filterDrawerUrgency, 'तातडी');
    expect(marathi.filterDrawerResetSort, 'क्रमवारी रीसेट करा');
    expect(marathi.filterDrawerStatus, 'स्थिति');
    expect(marathi.reportsPageTitle, 'अहवाल');
    expect(marathi.reportsPageCompleted, 'पूर्ण');
    expect(marathi.reportsPagePending, 'प्रलंबित');
    expect(marathi.reportsPageTasks, 'काम');
    expect(marathi.reportsPageDaily, 'दैनिक');
    expect(marathi.reportsPageDailyBurnDownChart, 'दैनिक बर्न डाउन चार्ट');
    expect(marathi.reportsPageDailyDayMonth, 'दिवस - महिना');
    expect(marathi.reportsPageWeekly, 'साप्ताहिक');
    expect(marathi.reportsPageWeeklyBurnDownChart, 'साप्ताहिक बर्न डाउन चार्ट');
    expect(marathi.reportsPageWeeklyWeeksYear, 'सप्ताह - वर्ष');
    expect(marathi.reportsPageMonthly, 'मासिक');
    expect(marathi.reportsPageMonthlyBurnDownChart, 'मासिक बर्न डाउन चार्ट');
    expect(marathi.reportsPageMonthlyMonthYear, 'महिना - वर्ष');
    expect(marathi.reportsPageNoTasksFound, 'कोणतेही काम सापडले नाहीत');
    expect(
        marathi.reportsPageAddTasksToSeeReports, 'अहवाल पाहण्यासाठी काम जोडा');
    expect(marathi.taskchampionTileDescription,
        'CCSync किंवा Taskchampion Sync Server सह Taskwarrior सिंक वर स्विच करा');
    expect(marathi.taskchampionTileTitle, 'Taskchampion सिंक');
    expect(marathi.ccsyncCredentials, 'CCync क्रेडेन्शियल');
    expect(marathi.deleteTaskConfirmation, 'कार्य हटवा');
    expect(marathi.deleteTaskTitle, 'सर्व कार्य हटवायचे का?');
    expect(marathi.deleteTaskWarning,
        'ही क्रिया अपरिवर्तनीय आहे आणि हे सर्व स्थानिक पातळीवर संग्रहित केलेले कार्य हटवेल.');
    expect(marathi.profilePageProfile, 'प्रोफाइल');
    expect(marathi.profilePageProfiles, 'प्रोफाइल्स');
    expect(marathi.profilePageCurrentProfile, 'सद्याचा प्रोफाइल');
    expect(marathi.profilePageManageSelectedProfile,
        'चयनित प्रोफाइल व्यवस्थापित करा');
    expect(marathi.profilePageRenameAlias, 'उपनाम पुनर्नामित करा');
    expect(
        marathi.profilePageConfigureTaskserver, 'टास्क सर्व्हर कॉन्फिगर करा');
    expect(marathi.profilePageExportTasks, 'टास्क निर्यात करा');
    expect(marathi.profilePageCopyConfigToNewProfile,
        'नवीन प्रोफाइलवर कॉन्फिगरेशन कॉपी करा');
    expect(marathi.profilePageDeleteProfile, 'प्रोफाइल हटवा');
    expect(marathi.profilePageAddNewProfile, 'नवीन प्रोफाइल जोडा');
    expect(
        marathi.profilePageRenameAliasDialogueBoxTitle, 'उपनाम पुनर्नामित करा');
    expect(marathi.profilePageRenameAliasDialogueBoxNewAlias, 'नवा उपनाम');
    expect(marathi.profilePageRenameAliasDialogueBoxCancel, 'रद्द करा');
    expect(marathi.profilePageRenameAliasDialogueBoxSubmit, 'सादर करा');
    expect(marathi.profilePageExportTasksDialogueTitle, 'निर्यात प्रारूप');
    expect(marathi.profilePageExportTasksDialogueSubtitle,
        'निर्यात प्रारूप निवडा');
    expect(marathi.manageTaskServerPageConfigureTaskserver,
        'टास्क सर्व्हर कॉन्फिगर करा');
    expect(marathi.manageTaskServerPageConfigureTASKRC, 'TASKRC कॉन्फिगर करा');
    expect(marathi.manageTaskServerPageSetTaskRC, 'TaskRC सेट करा');
    expect(marathi.manageTaskServerPageConfigureYourCertificate,
        'आपला सर्टिफिकेट कॉन्फिगर करा');
    expect(marathi.manageTaskServerPageSelectCertificate, 'सर्टिफिकेट निवडा');
    expect(marathi.manageTaskServerPageConfigureTaskserverKey,
        'टास्क सर्व्हर की कॉन्फिगर करा');
    expect(marathi.manageTaskServerPageSelectKey, 'की निवडा');
    expect(marathi.manageTaskServerPageConfigureServerCertificate,
        'सर्व्हर सर्टिफिकेट कॉन्फिगर करा');
    expect(marathi.manageTaskServerPageTaskRCFileIsVerified,
        'Task RC फाइल पडताळली गेली आहे');
    expect(marathi.manageTaskServerPageConfigureTaskRCDialogueBoxTitle,
        'TaskRC कॉन्फिगर करा');
    expect(marathi.manageTaskServerPageConfigureTaskRCDialogueBoxSubtitle,
        'TaskRC सामग्री पेस्ट करा किंवा taskrc फाइल निवडा');
    expect(marathi.manageTaskServerPageConfigureTaskRCDialogueBoxInputFieldText,
        'येथे आपली TaskRC सामग्री पेस्ट करा');
    expect(marathi.manageTaskServerPageConfigureTaskRCDialogueBoxOr, 'किंवा');
    expect(marathi.manageTaskServerPageConfigureTaskRCDialogueBoxSelectTaskRC,
        'TaskRC फाइल निवडा');
    expect(marathi.addTaskTitle, 'काम जोडा');
    expect(marathi.addTaskEnterTask, 'काम प्रविष्ट करा');
    expect(marathi.addTaskDue, 'अखेर');
    expect(marathi.addTaskSelectDueDate, 'अखेरची तारीख निवडा');
    expect(marathi.addTaskPriority, 'प्राथमिकता');
    expect(marathi.addTaskAddTags, 'टॅग जोडा');
    expect(marathi.addTaskCancel, 'रद्द करा');
    expect(marathi.addTaskAdd, 'जोडा');
    expect(marathi.addTaskTimeInPast, 'निवडलेला वेळ भूतकाळात आहे.');
    expect(marathi.addTaskFieldCannotBeEmpty,
        'तुम्ही हा फील्ड रिकामा सोडू शकत नाही!');
    expect(marathi.addTaskTaskAddedSuccessfully,
        'काम यशस्वीपणे जोडले गेले. संपादित करण्यासाठी टॅप करा');
    expect(marathi.aboutPageGitHubLink,
        'या प्रकल्पाला सुधारण्यासाठी उत्सुक आहात का? आमच्या GitHub रिपॉझिटरीला भेट द्या.');
    expect(marathi.aboutPageProjectDescription,
        'या प्रकल्पाचे उद्दिष्ट Taskwarrior साठी एक अॅप तयार करणे आहे. हे आपल्या सर्व प्लॅटफॉर्मवरील कार्य व्यवस्थापन अॅप आहे. हे आपल्याला आपल्या कार्यांचे व्यवस्थापन करण्यात आणि त्यांना आपल्या गरजेनुसार फिल्टर करण्यात मदत करते.');
    expect(marathi.aboutPageAppBarTitle, 'विषयक');
  });
}
