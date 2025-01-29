import 'package:taskwarrior/app/utils/language/sentences.dart';

class HindiSentences extends Sentences {
  @override
  String get helloWorld => 'नमस्ते दुनिया!';
  @override
  String get homePageTitle => 'होम पेज';
  @override
  String get homePageLastModified => 'अंतिम बार संशोधित';
  @override
  String get homePageDue => 'देय';
  @override
  String get homePageTaskWarriorNotConfigured => 'TaskServer कॉन्फ़िगर नहीं है';
  @override
  String get homePageSetup => 'सेटअप';
  @override
  String get homePageFilter => 'फ़िल्टर';
  @override
  String get homePageMenu => 'मेन्यू';
  @override
  String get homePageExitApp => 'ऐप बंद करें';
  @override
  String get homePageAreYouSureYouWantToExit =>
      'क्या आप वाकई ऐप बंद करना चाहते हैं?';
  @override
  String get homePageExit => 'बाहर जाओ';
  @override
  String get homePageCancel => 'रद्द करें';
  @override
  String get homePageClickOnTheBottomRightButtonToStartAddingTasks =>
      'कार्यों को जोड़ना शुरू करने के लिए नीचे दाएं बटन पर क्लिक करें';
  @override
  String get homePageSearchNotFound => 'खोजने पर नहीं मिला';
  @override
  String get homePageFetchingTasks => 'कार्य लाये जा रहे हैं';
  @override
  String get settingsPageTitle => 'सेटिंग्स पेज';
  @override
  String get settingsPageSubtitle => 'अपनी पसंद सेट करें';
  @override
  String get settingsPageMovingDataToNewDirectory =>
      'नए निर्देशिका में डेटा को ले जा रहा है';
  @override
  String get settingsPageSyncOnStartTitle =>
      'ऐप स्टार्ट पर डेटा स्वचालित सिंक करें';
  @override
  String get settingsPageSyncOnStartDescription => 'स्टार्ट पर सिंक करें';
  @override
  String get settingsPageEnableSyncOnTaskCreateTitle =>
      'नई टास्क बनाते समय स्वचालित सिंकिंग सक्षम करें';
  @override
  String get settingsPageEnableSyncOnTaskCreateDescription =>
      'नई टास्क बनाते समय स्वचालित सिंकिंग सक्षम करें';
  @override
  String get settingsPageHighlightTaskTitle =>
      'केवल 1 दिन शेष होने पर कार्य की सीमा बनाएं';
  @override
  String get settingsPageHighlightTaskDescription =>
      'केवल 1 दिन शेष होने पर कार्य की सीमा बनाएं';
  @override
  String get settingsPageEnable24hrFormatTitle =>
      '24 घंटे का प्रारूप सक्षम करें';
  @override
  String get settingsPageEnable24hrFormatDescription =>
      '24 घंटे का प्रारूप सक्षम करें';
  @override
  String get settingsPageSelectLanguage => 'भाषा चुनें';
  @override
  String get settingsPageToggleNativeLanguage =>
      'अपनी मातृभाषा के बीच टॉगल करें';
  @override
  String get settingsPageSelectDirectoryTitle => 'निर्देशिका चुनें';
  @override
  String get settingsPageSelectDirectoryDescription =>
      'निर्देशिका चुनें जहां Taskwarrior डेटा स्टोर होता है\nवर्तमान निर्देशिका: ';
  @override
  String get settingsPageChangeDirectory => 'निर्देशिका बदलें';
  @override
  String get settingsPageSetToDefault => 'डिफॉल्ट पर सेट करें';
  @override
  String get navDrawerProfile => 'प्रोफ़ाइल';
  @override
  String get navDrawerReports => 'रिपोर्ट्स';
  @override
  String get navDrawerAbout => 'के बारे में';
  @override
  String get navDrawerSettings => 'सेटिंग्स';
  @override
  String get navDrawerExit => 'बाहर जाओ';

  @override
  String get detailPageDescription => 'विवरण';
  @override
  String get detailPageStatus => 'स्थिति';
  @override
  String get detailPageEntry => 'प्रवेश';
  @override
  String get detailPageModified => 'संशोधित';
  @override
  String get detailPageStart => 'प्रारंभ';
  @override
  String get detailPageEnd => 'अंत';
  @override
  String get detailPageDue => 'देय';
  @override
  String get detailPageWait => 'प्रतीक्षा करें';
  @override
  String get detailPageUntil => 'तक';
  @override
  String get detailPagePriority => 'प्राथमिकता';
  @override
  String get detailPageProject => 'परियोजना';
  @override
  String get detailPageTags => 'टैग';
  @override
  String get detailPageUrgency => 'तत्कालता';
  @override
  String get detailPageID => 'आयडी';

  @override
  String get filterDrawerApplyFilters => 'फिल्टर लागू करें';
  @override
  String get filterDrawerHideWaiting => 'इंतजार छिपाएं';
  @override
  String get filterDrawerShowWaiting => 'इंतजार दिखाएं';
  @override
  String get filterDrawerPending => 'अपूर्ण';
  @override
  String get filterDrawerCompleted => 'पूर्ण';
  @override
  String get filterDrawerFilterTagBy => 'टैग से फ़िल्टर करें';
  @override
  String get filterDrawerAND => 'और';
  @override
  String get filterDrawerOR => 'या';
  @override
  String get filterDrawerSortBy => 'इसके आधार पर क्रमबद्ध करें';
  @override
  String get filterDrawerCreated => 'निर्मित';
  @override
  String get filterDrawerModified => 'संशोधित';
  @override
  String get filterDrawerStartTime => 'शुरुआत समय';
  @override
  String get filterDrawerDueTill => 'तक बकाया';
  @override
  String get filterDrawerPriority => 'प्राथमिकता';
  @override
  String get filterDrawerProject => 'परियोजना';
  @override
  String get filterDrawerTags => 'टैग्स';
  @override
  String get filterDrawerUrgency => 'तत्कालता';
  @override
  String get filterDrawerResetSort => 'सॉर्ट रीसेट करें';
  @override
  String get filterDrawerStatus => 'स्थिती';
  @override
  String get reportsPageTitle => 'रिपोर्ट्स';
  @override
  String get reportsPageCompleted => 'पूर्ण';
  @override
  String get reportsPagePending => 'अपूर्ण';
  @override
  String get reportsPageTasks => 'कार्य';

  @override
  String get reportsPageDaily => 'दैनिक';
  @override
  String get reportsPageDailyBurnDownChart => 'दैनिक बर्न डाउन चार्ट';
  @override
  String get reportsPageDailyDayMonth => 'दिन - माह';

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
  String get reportsPageMonthlyMonthYear => 'माह - वर्ष';

  @override
  String get reportsPageNoTasksFound => 'कोई कार्य नहीं मिला';
  @override
  String get reportsPageAddTasksToSeeReports =>
      'रिपोर्ट देखने के लिए कार्य जोड़ें';

  @override
  String get taskchampionTileDescription =>
      'CCSync या Taskchampion सिंक सर्वर के साथ Taskwarrior सिंक पर स्विच करें';

  @override
  String get taskchampionTileTitle => 'Taskchampion सिंक';

  @override
  String get ccsyncCredentials => 'CCync क्रेडेन्शियल';

  @override
  String get deleteTaskConfirmation => 'कार्य हटाएं';

  @override
  String get deleteTaskTitle => 'सभी कार्य हटाएं?';

  @override
  String get deleteTaskWarning =>
      'यह क्रिया अपरिवर्तनीय है और यह सभी स्थानीय रूप से संग्रहीत कार्यों को हटा देगी।';

  @override
  String get profilePageProfile => 'प्रोफ़ाइल';
  @override
  String get profilePageProfiles => 'प्रोफ़ाइल्स';
  @override
  String get profilePageCurrentProfile => 'वर्तमान प्रोफ़ाइल';
  @override
  String get profilePageManageSelectedProfile =>
      'चुनी हुई प्रोफ़ाइल प्रबंधित करें';
  @override
  String get profilePageRenameAlias => 'उपनाम बदलें';

  @override
  String get profilePageConfigureTaskserver => 'टास्क सर्वर कॉन्फ़िगर करें';
  @override
  String get profilePageExportTasks => 'कार्य निर्यात करें';
  @override
  String get profilePageCopyConfigToNewProfile =>
      'नई प्रोफ़ाइल पर कॉन्फ़िगरेशन कॉपी करें';
  @override
  String get profilePageDeleteProfile => 'प्रोफ़ाइल हटाएँ';
  @override
  String get profilePageAddNewProfile => 'नई प्रोफ़ाइल जोड़ें';

  @override
  String get profilePageRenameAliasDialogueBoxTitle => 'उपनाम बदलें';
  @override
  String get profilePageRenameAliasDialogueBoxNewAlias => 'नया उपनाम';
  @override
  String get profilePageRenameAliasDialogueBoxCancel => 'रद्द करें';
  @override
  String get profilePageRenameAliasDialogueBoxSubmit => 'प्रस्तुत करें';

  @override
  String get profilePageExportTasksDialogueTitle => 'निर्यात प्रारूप';
  @override
  String get profilePageExportTasksDialogueSubtitle => 'निर्यात प्रारूप चुनें';

  @override
  String get manageTaskServerPageConfigureTaskserver =>
      'टास्क सर्वर कॉन्फ़िगर करें';
  @override
  String get manageTaskServerPageConfigureTASKRC => 'TASKRC कॉन्फ़िगर करें';
  @override
  String get manageTaskServerPageSetTaskRC => 'TaskRC सेट करें';
  @override
  String get manageTaskServerPageConfigureYourCertificate =>
      'अपने सर्टिफिकेट को कॉन्फ़िगर करें';
  @override
  String get manageTaskServerPageSelectCertificate => 'सर्टिफिकेट चुनें';
  @override
  String get manageTaskServerPageConfigureTaskserverKey =>
      'टास्क सर्वर की कॉन्फ़िगर करें';
  @override
  String get manageTaskServerPageSelectKey => 'कुंजी चुनें';
  @override
  String get manageTaskServerPageConfigureServerCertificate =>
      'सर्वर सर्टिफिकेट कॉन्फ़िगर करें';
  @override
  String get manageTaskServerPageTaskRCFileIsVerified =>
      'Task RC फ़ाइल सत्यापित की गई है';

  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxTitle =>
      'TaskRC कॉन्फ़िगर करें';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxSubtitle =>
      'TaskRC सामग्री पेस्ट करें या taskrc फ़ाइल चुनें';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxInputFieldText =>
      'यहाँ अपनी TaskRC सामग्री पेस्ट करें';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxOr => 'या';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxSelectTaskRC =>
      'TaskRC फ़ाइल चुनें';

  @override
  String get addTaskTitle => "कार्य जोड़ें";
  @override
  String get addTaskEnterTask => "कार्य दर्ज करें";
  @override
  String get addTaskDue => "देय";
  @override
  String get addTaskSelectDueDate => "नियत तिथि चुनें";
  @override
  String get addTaskPriority => "प्राथमिकता";
  @override
  String get addTaskAddTags => "टैग जोड़ें";
  @override
  String get addTaskCancel => "रद्द करें";
  @override
  String get addTaskAdd => "जोड़ें";
  @override
  String get addTaskTimeInPast => "चुनी गई समय अतीत में है।";
  @override
  String get addTaskFieldCannotBeEmpty =>
      "आप इस फ़ील्ड को खाली नहीं छोड़ सकते!";
  @override
  String get addTaskTaskAddedSuccessfully =>
      "कार्य सफलतापूर्वक जोड़ा गया। संपादित करने के लिए टैप करें";

  @override
  String get aboutPageGitHubLink =>
      "इस परियोजना को बढ़ाने के लिए उत्सुक हैं? हमारे GitHub रिपॉज़िटरी पर जाएं।";
  @override
  String get aboutPageProjectDescription =>
      "यह परियोजना Taskwarrior के लिए एक ऐप बनाने का लक्ष्य रखती है। यह आपके सभी प्लेटफार्मों पर कार्य प्रबंधन ऐप है। यह आपको अपने कार्यों को प्रबंधित करने और उन्हें अपनी आवश्यकताओं के अनुसार छानने में मदद करता है।";
  @override
  String get aboutPageAppBarTitle => "के बारे में";
}
