import 'package:taskwarrior/app/utils/language/sentences.dart';

class MarathiSentences extends Sentences {
  @override
  String get helloWorld => 'नमस्कार, जग!';
  @override
  String get homePageTitle => 'होम पेज';
  @override
  String get homePageLastModified => 'शेवटचा बदल';
  @override
  String get homePageDue => 'द्यावे';
  @override
  String get homePageTaskWarriorNotConfigured => 'TaskServer संरचीत नाही';
  @override
  String get homePageSetup => 'सेटअप';
  @override
  String get homePageFilter => 'फिल्टर';
  @override
  String get homePageMenu => 'मेनू';
  @override
  String get homePageExitApp => 'अ‍ॅप बंद करा';
  @override
  String get homePageAreYouSureYouWantToExit =>
      'आपण खात्री आहात की आपण अ‍ॅप बंद करू इच्छिता?';
  @override
  String get homePageExit => 'बाहेर पडा';
  @override
  String get homePageCancel => 'रद्द करा';
  @override
  String get homePageClickOnTheBottomRightButtonToStartAddingTasks =>
      'कार्ये जोडणे सुरू करण्यासाठी तळाशी उजव्या बटणावर क्लिक करा';
  @override
  String get homePageSearchNotFound => 'शोध सापडला नाही';
  @override
  String get homePageFetchingTasks => 'कार्ये आणत आहे';
  @override
  String get settingsPageTitle => 'सेटिंग्स पेज';
  @override
  String get settingsPageSubtitle => 'तुमची पसंती सेट करा';
  @override
  String get settingsPageMovingDataToNewDirectory =>
      'नवीन निर्देशिकेत डेटा हलवत आहे';
  @override
  String get settingsPageSyncOnStartTitle => 'सुरू करण्यावर सिंक करा';
  @override
  String get settingsPageSyncOnStartDescription =>
      'अ‍ॅप सुरू करताना डेटा स्वयंसिंक करा';
  @override
  String get settingsPageEnableSyncOnTaskCreateTitle =>
      'नवीन कार्य तयार करताना स्वयंसिंकिंग सक्षम करा';
  @override
  String get settingsPageEnableSyncOnTaskCreateDescription =>
      'नवीन कार्य तयार करताना स्वयंसिंकिंग सक्षम करा';
  @override
  String get settingsPageHighlightTaskTitle =>
      'फक्त 1 दिवस शेष असताना कार्याची सीमा बनवा';
  @override
  String get settingsPageHighlightTaskDescription =>
      'फक्त 1 दिवस शेष असताना कार्याची सीमा बनवा';
  @override
  String get settingsPageEnable24hrFormatTitle => '24 तासाचा स्वरूप सक्षम करा';
  @override
  String get settingsPageEnable24hrFormatDescription =>
      '24 तासाचा स्वरूप सक्षम करा';
  @override
  String get settingsPageSelectLanguage => 'भाषा निवडा';
  @override
  String get settingsPageToggleNativeLanguage =>
      'तुमच्या मूल भाषेतर्फे टॉगल करा';
  @override
  String get settingsPageSelectDirectoryTitle => 'निर्देशिका निवडा';
  @override
  String get settingsPageSelectDirectoryDescription =>
      'निर्देशिका निवडा जिथे Taskwarrior डेटा स्टोर केला जातो\nवर्तमान निर्देशिका: ';
  @override
  String get settingsPageChangeDirectory => 'डिरेक्टरी बदला';
  @override
  String get settingsPageSetToDefault => 'डीफॉल्टवर सेट करा';
  @override
  String get navDrawerProfile => 'प्रोफ़ाइल';
  @override
  String get navDrawerReports => 'अहवाल';
  @override
  String get navDrawerAbout => 'चरित्र';
  @override
  String get navDrawerSettings => 'सेटिंग्स';
  @override
  String get navDrawerExit => 'बाहेर पडा';

  @override
  String get detailPageDescription => 'वर्णन';
  @override
  String get detailPageStatus => 'स्थिती';
  @override
  String get detailPageEntry => 'प्रवेश';
  @override
  String get detailPageModified => 'संशोधित';
  @override
  String get detailPageStart => 'सुरूवात';
  @override
  String get detailPageEnd => 'शेवट';
  @override
  String get detailPageDue => 'देय';
  @override
  String get detailPageWait => 'प्रतीक्षा';
  @override
  String get detailPageUntil => 'पर्यंत';
  @override
  String get detailPagePriority => 'प्राधान्य';
  @override
  String get detailPageProject => 'प्रकल्प';
  @override
  String get detailPageTags => 'टॅग';
  @override
  String get detailPageUrgency => 'तातडी';
  @override
  String get detailPageID => 'आयडी';

  @override
  String get filterDrawerApplyFilters => 'फिल्टर लागू करा';
  @override
  String get filterDrawerHideWaiting => 'वाट लपवा';
  @override
  String get filterDrawerShowWaiting => 'वाट दाखवा';
  @override
  String get filterDrawerPending => 'प्रलंबित';
  @override
  String get filterDrawerCompleted => 'पूर्ण';
  @override
  String get filterDrawerFilterTagBy => 'टॅगवर फिल्टर करा';
  @override
  String get filterDrawerAND => 'आणि';
  @override
  String get filterDrawerOR => 'किंवा';
  @override
  String get filterDrawerSortBy => 'यानुसार क्रमबद्ध करा';
  @override
  String get filterDrawerCreated => 'सृष्ट';
  @override
  String get filterDrawerModified => 'संशोधित';
  @override
  String get filterDrawerStartTime => 'सुरूवातीचा वेळ';
  @override
  String get filterDrawerDueTill => 'पर्यंतचा देय';
  @override
  String get filterDrawerPriority => 'प्राधान्य';
  @override
  String get filterDrawerProject => 'प्रकल्प';
  @override
  String get filterDrawerTags => 'टॅग्ज';
  @override
  String get filterDrawerUrgency => 'तातडी';
  @override
  String get filterDrawerResetSort => 'क्रमवारी रीसेट करा';
  @override
  String get filterDrawerStatus => 'स्थिति';

  @override
  String get reportsPageTitle => 'अहवाल';
  @override
  String get reportsPageCompleted => 'पूर्ण';
  @override
  String get reportsPagePending => 'प्रलंबित';
  @override
  String get reportsPageTasks => 'काम';

  @override
  String get reportsPageDaily => 'दैनिक';
  @override
  String get reportsPageDailyBurnDownChart => 'दैनिक बर्न डाउन चार्ट';
  @override
  String get reportsPageDailyDayMonth => 'दिवस - महिना';

  @override
  String get reportsPageWeekly => 'साप्ताहिक';
  @override
  String get reportsPageWeeklyBurnDownChart => 'साप्ताहिक बर्न डाउन चार्ट';
  @override
  String get reportsPageWeeklyWeeksYear => 'सप्ताह - वर्ष';

  @override
  String get reportsPageMonthly => 'मासिक';
  @override
  String get reportsPageMonthlyBurnDownChart => 'मासिक बर्न डाउन चार्ट';
  @override
  String get reportsPageMonthlyMonthYear => 'महिना - वर्ष';

  @override
  String get reportsPageNoTasksFound => 'कोणतेही काम सापडले नाहीत';
  @override
  String get reportsPageAddTasksToSeeReports => 'अहवाल पाहण्यासाठी काम जोडा';

  @override
  String get taskchampionTileDescription =>
      'CCSync किंवा Taskchampion Sync Server सह Taskwarrior सिंक वर स्विच करा';

  @override
  String get taskchampionTileTitle => 'Taskchampion सिंक';

  @override
  String get ccsyncCredentials => 'CCync क्रेडेन्शियल';

  @override
  String get deleteTaskConfirmation => 'कार्य हटवा';

  @override
  String get deleteTaskTitle => 'सर्व कार्य हटवायचे का?';

  @override
  String get deleteTaskWarning =>
      'ही क्रिया अपरिवर्तनीय आहे आणि हे सर्व स्थानिक पातळीवर संग्रहित केलेले कार्य हटवेल.';

  @override
  String get profilePageProfile => 'प्रोफाइल';
  @override
  String get profilePageProfiles => 'प्रोफाइल्स';
  @override
  String get profilePageCurrentProfile => 'सद्याचा प्रोफाइल';
  @override
  String get profilePageManageSelectedProfile =>
      'चयनित प्रोफाइल व्यवस्थापित करा';
  @override
  String get profilePageRenameAlias => 'उपनाम पुनर्नामित करा';

  @override
  String get profilePageConfigureTaskserver => 'टास्क सर्व्हर कॉन्फिगर करा';
  @override
  String get profilePageExportTasks => 'टास्क निर्यात करा';
  @override
  String get profilePageCopyConfigToNewProfile =>
      'नवीन प्रोफाइलवर कॉन्फिगरेशन कॉपी करा';
  @override
  String get profilePageDeleteProfile => 'प्रोफाइल हटवा';
  @override
  String get profilePageAddNewProfile => 'नवीन प्रोफाइल जोडा';

  @override
  String get profilePageRenameAliasDialogueBoxTitle => 'उपनाम पुनर्नामित करा';
  @override
  String get profilePageRenameAliasDialogueBoxNewAlias => 'नवा उपनाम';
  @override
  String get profilePageRenameAliasDialogueBoxCancel => 'रद्द करा';
  @override
  String get profilePageRenameAliasDialogueBoxSubmit => 'सादर करा';

  @override
  String get profilePageExportTasksDialogueTitle => 'निर्यात प्रारूप';
  @override
  String get profilePageExportTasksDialogueSubtitle => 'निर्यात प्रारूप निवडा';

  @override
  String get manageTaskServerPageConfigureTaskserver =>
      'टास्क सर्व्हर कॉन्फिगर करा';
  @override
  String get manageTaskServerPageConfigureTASKRC => 'TASKRC कॉन्फिगर करा';
  @override
  String get manageTaskServerPageSetTaskRC => 'TaskRC सेट करा';
  @override
  String get manageTaskServerPageConfigureYourCertificate =>
      'आपला सर्टिफिकेट कॉन्फिगर करा';
  @override
  String get manageTaskServerPageSelectCertificate => 'सर्टिफिकेट निवडा';
  @override
  String get manageTaskServerPageConfigureTaskserverKey =>
      'टास्क सर्व्हर की कॉन्फिगर करा';
  @override
  String get manageTaskServerPageSelectKey => 'की निवडा';
  @override
  String get manageTaskServerPageConfigureServerCertificate =>
      'सर्व्हर सर्टिफिकेट कॉन्फिगर करा';
  @override
  String get manageTaskServerPageTaskRCFileIsVerified =>
      'Task RC फाइल पडताळली गेली आहे';

  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxTitle =>
      'TaskRC कॉन्फिगर करा';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxSubtitle =>
      'TaskRC सामग्री पेस्ट करा किंवा taskrc फाइल निवडा';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxInputFieldText =>
      'येथे आपली TaskRC सामग्री पेस्ट करा';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxOr => 'किंवा';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxSelectTaskRC =>
      'TaskRC फाइल निवडा';

  @override
  String get addTaskTitle => "काम जोडा";
  @override
  String get addTaskEnterTask => "काम प्रविष्ट करा";
  @override
  String get addTaskDue => "अखेर";
  @override
  String get addTaskSelectDueDate => "अखेरची तारीख निवडा";
  @override
  String get addTaskPriority => "प्राथमिकता";
  @override
  String get addTaskAddTags => "टॅग जोडा";
  @override
  String get addTaskCancel => "रद्द करा";
  @override
  String get addTaskAdd => "जोडा";
  @override
  String get addTaskTimeInPast => "निवडलेला वेळ भूतकाळात आहे.";
  @override
  String get addTaskFieldCannotBeEmpty =>
      "तुम्ही हा फील्ड रिकामा सोडू शकत नाही!";
  @override
  String get addTaskTaskAddedSuccessfully =>
      "काम यशस्वीपणे जोडले गेले. संपादित करण्यासाठी टॅप करा";

  @override
  String get aboutPageGitHubLink =>
      "या प्रकल्पाला सुधारण्यासाठी उत्सुक आहात का? आमच्या GitHub रिपॉझिटरीला भेट द्या.";
  @override
  String get aboutPageProjectDescription =>
      "या प्रकल्पाचे उद्दिष्ट Taskwarrior साठी एक अॅप तयार करणे आहे. हे आपल्या सर्व प्लॅटफॉर्मवरील कार्य व्यवस्थापन अॅप आहे. हे आपल्याला आपल्या कार्यांचे व्यवस्थापन करण्यात आणि त्यांना आपल्या गरजेनुसार फिल्टर करण्यात मदत करते.";
  @override
  String get aboutPageAppBarTitle => "विषयक";
}
