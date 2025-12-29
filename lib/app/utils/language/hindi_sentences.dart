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
  String get homePageSearchTooltip => 'खोजें';
  @override
  String get homePageCancelSearchTooltip => 'रद्द करें';
  @override
  String get homePageAddTaskTooltip => 'कार्य जोड़ें';
  @override
  String get homePageTapBackToExit => 'बाहर निकलने के लिए फिर से वापस दबाएं';
  @override
  String get homePageSearchHint => 'खोजें';

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
  String get settingsPageHighlightTaskTitle => 'तत्काल कार्यों को हाइलाइट करें';
  @override
  String get settingsPageHighlightTaskDescription =>
      '1 दिन के भीतर देय या अतिदेय कार्यों को हाइलाइट करें';
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
  String get navDrawerConfirm => 'पुष्टि करें';

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
  String get filterDrawerNoProjectsAvailable => 'कोई परियोजना उपलब्ध नहीं।';
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
  String get deleteAllTasksWillBeMarkedAsDeleted =>
      'यह सभी कार्यों को हटाए गए के रूप में चिह्नित कर देगा और वे ऐप में दिखाई नहीं देंगे।';

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
  String get profilePageChangeProfileMode => 'सिंक सर्वर बदलें';
  @override
  String get profilePageSelectProfileMode => 'एक सर्वर चुनें';
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
  String get profilePageSuccessfullyChangedProfileModeTo =>
      'प्रोफ़ाइल मोड सफलतापूर्वक बदल दिया गया: ';
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

  @override
  String get version => "संस्करण";
  @override
  String get package => "पैकेज";

  @override
  String get notSelected => "चयनित नहीं";
  @override
  String get cantSetTimeinPast => "पिछले समय को सेट नहीं कर सकते";

  @override
  String get editDescription => "विवरण संपादित करें";
  @override
  String get editProject => "परियोजना संपादित करें";
  @override
  String get cancel => "रद्द करें";
  @override
  String get submit => "जमा करें";

  @override
  String get saveChangesConfirmation => 'क्या आप परिवर्तन सहेजना चाहते हैं?';
  @override
  String get yes => 'हाँ';
  @override
  String get no => 'नहीं';
  @override
  String get reviewChanges => 'परिवर्तनों की समीक्षा करें';
  @override
  String get oldChanges => 'पुराना';
  @override
  String get newChanges => 'नया';

  @override
  String get tags => 'टैग';
  @override
  String get addedTagsWillAppearHere => 'जोड़े गए टैग यहाँ दिखाई देंगे';
  @override
  String get addTag => 'टैग जोड़ें';

  @override
  String get enterProject => 'परियोजना दर्ज करें';
  @override
  String get allProjects => 'सभी परियोजनाएँ';
  @override
  String get noProjectsFound => 'कोई परियोजना नहीं मिली';
  @override
  String get project => 'परियोजना';

  @override
  String get select => 'चुनें';
  @override
  String get save => 'सहेजें';
  @override
  String get dontSave => 'सहेजें नहीं';
  @override
  String get unsavedChanges => 'असहेजित परिवर्तन';
  @override
  String get unsavedChangesWarning =>
      'आपके पास असहेजित परिवर्तन हैं। आप क्या करना चाहेंगे?';
  @override
  String get enterNew => 'नया दर्ज करें';
  @override
  String get edit => 'संपादित करें';
  @override
  String get task => 'कार्य';

  @override
  String get confirmDeleteTask => 'हटाने की पुष्टि करें';
  @override
  String get taskUpdated => 'कार्य अपडेट किया गया';
  @override
  String get undo => 'पूर्ववत करें';
  @override
  String get taskMarkedAsCompleted =>
      'कार्य को पूर्ण रूप में चिह्नित किया गया। परिवर्तनों को देखने के लिए रिफ्रेश करें!';
  @override
  String get taskMarkedAsDeleted =>
      'कार्य को हटाए गए रूप में चिह्नित किया गया। परिवर्तनों को देखने के लिए रिफ्रेश करें!';
  @override
  String get refreshToViewChanges => 'परिवर्तनों को देखने के लिए रिफ्रेश करें';
  @override
  String get clickOnBottomRightButtonToStartAddingTasks =>
      'कार्य जोड़ने के लिए नीचे दाईं ओर बटन पर क्लिक करें';
  @override
  String get complete => 'पूर्ण';
  @override
  String get delete => 'हटाएँ';

  @override
  String get taskServerInfo => 'टास्क सर्वर जानकारी';
  @override
  String get taskServerCredentials => 'टास्क सर्वर क्रेडेंशियल';
  @override
  String get notConfigured => 'कॉन्फ़िगर नहीं किया गया';
  @override
  String get fetchingStatistics => 'सांख्यिकी लाया जा रहा है...';
  @override
  String get pleaseWait => 'कृपया प्रतीक्षा करें...';
  @override
  String get statistics => 'सांख्यिकी:';
  @override
  String get ok => 'ठीक';
  @override
  String get pleaseSetupTaskServer => 'कृपया अपना टास्क सर्वर सेट करें।';

  @override
  String get onboardingSkip => 'छोड़ें';
  @override
  String get onboardingNext => 'अगला';
  @override
  String get onboardingStart => 'शुरू करें';

  @override
  String get permissionPageTitle => 'हमें आपकी अनुमति की आवश्यकता क्यों है';
  @override
  String get storagePermissionTitle => 'संग्रहण अनुमति';
  @override
  String get storagePermissionDescription =>
      'हम आपके कार्य, प्राथमिकताएँ, और ऐप डेटा सुरक्षित रूप से सहेजने के लिए '
      'संग्रहण पहुँच का उपयोग करते हैं, जिससे आप किसी भी समय ऑफ़लाइन भी कार्य जारी रख सकते हैं।';
  @override
  String get notificationPermissionTitle => 'सूचना अनुमति';
  @override
  String get notificationPermissionDescription =>
      'सूचनाएँ आपको महत्वपूर्ण अनुस्मारक और अपडेट देती हैं, जिससे आप अपने कार्यों को आसानी से प्रबंधित कर सकते हैं।';
  @override
  String get privacyStatement =>
      'आपकी गोपनीयता हमारी प्राथमिकता है। हम आपकी व्यक्तिगत फ़ाइलें या डेटा आपकी सहमति के बिना कभी भी एक्सेस या साझा नहीं करते।';
  @override
  String get grantPermissions => 'अनुमतियाँ दें';
  @override
  String get managePermissionsLater =>
      'आप बाद में सेटिंग्स में अपनी अनुमतियाँ प्रबंधित कर सकते हैं';

  @override
  String get profileAllProfiles => 'सभी प्रोफाइल:';
  @override
  String get profileSwitchedToProfile => 'प्रोफ़ाइल पर स्विच किया गया';
  @override
  String get profileAddedSuccessfully => 'प्रोफ़ाइल सफलतापूर्वक जोड़ी गई';
  @override
  String get profileAdditionFailed => 'प्रोफ़ाइल जोड़ना विफल रहा';
  @override
  String get profileConfigCopied => 'प्रोफ़ाइल कॉन्फ़िग कॉपी किया गया';
  @override
  String get profileConfigCopyFailed => 'प्रोफ़ाइल कॉन्फ़िग कॉपी विफल';
  @override
  String get profileDeletedSuccessfully => 'सफलतापूर्वक हटाया गया';
  @override
  String get profileDeletionFailed => 'हटाने में विफल';
  @override
  String get profileDeleteConfirmation => 'पुष्टि करें';

  @override
  String get reportsDate => 'तारीख';
  @override
  String get reportsPending => 'लंबित';
  @override
  String get reportsCompleted => 'पूर्ण';
  @override
  String get reportsMonthYear => 'महीना-वर्ष';
  @override
  String get reportsWeek => 'सप्ताह';
  @override
  String get reportsDay => 'दिन';
  @override
  String get reportsYear => 'वर्ष';
  @override
  String get reportsError => 'त्रुटि';
  @override
  String get reportsLoading => 'लोड हो रहा है...';

  @override
  String get settingsResetToDefault => 'डिफ़ॉल्ट पर रीसेट करें';
  @override
  String get settingsAlreadyDefault => 'पहले से डिफ़ॉल्ट';
  @override
  String get settingsConfirmReset =>
      'क्या आप वाकई निर्देशिका को डिफ़ॉल्ट पर रीसेट करना चाहते हैं?';
  @override
  String get settingsNoButton => 'नहीं';
  @override
  String get settingsYesButton => 'हाँ';

  @override
  String get splashSettingUpApp => "ऐप सेटअप किया जा रहा है...";

  @override
  String get tourReportsDaily => "यहाँ अपनी दैनिक कार्य रिपोर्ट देखें";
  @override
  String get tourReportsWeekly => "यहाँ अपनी साप्ताहिक कार्य रिपोर्ट देखें";
  @override
  String get tourReportsMonthly => "यहाँ अपनी मासिक कार्य रिपोर्ट देखें";

  @override
  String get tourProfileCurrent => "यहाँ अपनी वर्तमान प्रोफ़ाइल देखें";
  @override
  String get tourProfileManage => "यहाँ अपनी वर्तमान प्रोफ़ाइल प्रबंधित करें";
  @override
  String get tourProfileAddNew => "यहाँ नई प्रोफ़ाइल जोड़ें";

  @override
  String get tourHomeAddTask => "नया कार्य जोड़ें";
  @override
  String get tourHomeSearch => "कार्य खोजें";
  @override
  String get tourHomeRefresh => "अपने कार्यों को ताज़ा करें या सिंक करें";
  @override
  String get tourHomeFilter => "कार्य और परियोजनाओं को फ़िल्टर करें";
  @override
  String get tourHomeMenu => "यहाँ अतिरिक्त सेटिंग्स एक्सेस करें";

  @override
  String get tourFilterStatus =>
      "कार्य की पूर्णता स्थिति के आधार पर फ़िल्टर करें";
  @override
  String get tourFilterProjects => "परियोजनाओं के आधार पर कार्य फ़िल्टर करें";
  @override
  String get tourFilterTagUnion =>
      "AND और OR टैग यूनियन प्रकारों के बीच टॉगल करें";
  @override
  String get tourFilterSort =>
      "निर्माण समय, तात्कालिकता, नियत तिथि, प्रारंभ तिथि आदि के आधार पर कार्यों को क्रमबद्ध करें।";

  @override
  String get tourDetailsDue => "यह कार्य की नियत तिथि को दर्शाता है";
  @override
  String get tourDetailsWait =>
      "यह कार्य की प्रतीक्षा तिथि को दर्शाता है \n कार्य इस तिथि के बाद दिखाई देगा";
  @override
  String get tourDetailsUntil => "यह कार्य की अंतिम तिथि को दर्शाता है";
  @override
  String get tourDetailsPriority =>
      "यह कार्यों की प्राथमिकता है \n L -> निम्न \n M -> मध्यम \n H -> उच्च";

  @override
  String get tourTaskServerTaskRC =>
      "यहां 'taskrc' नामक फ़ाइल चुनें या इसकी सामग्री पेस्ट करें";
  @override
  String get tourTaskServerCertificate =>
      "इसी तरह नामित फ़ाइल चुनें, जैसे <Your Email>.com.cert.pem";
  @override
  String get tourTaskServerKey =>
      "इसी तरह नामित फ़ाइल चुनें, जैसे <Your Email>.key.pem";
  @override
  String get tourTaskServerRootCert =>
      "इसी तरह नामित फ़ाइल चुनें, जैसे letsencrypt_root_cert.pem";
  @override
  String get descriprtionCannotBeEmpty => "विवरण खाली नहीं हो सकता";
  @override
  String get enterTaskDescription => "कार्य विवरण दर्ज करें";
  @override
  String get canNotHaveWhiteSpace => "सफेद स्थान नहीं हो सकता";
  @override
  String get high => "उच्च";
  @override
  String get medium => "मध्यम";
  @override
  String get low => "निम्न";
  @override
  String get priority => "प्राथमिकता";
  @override
  String get tagAlreadyExists => "टैग पहले से मौजूद है";
  @override
  String get tagShouldNotContainSpaces => "टैग में स्पेस नहीं होना चाहिए";
  @override
  String get date => "तारीख";
  @override
  String get add => "जोड़ें";
  @override
  String get change => "बदलें";
  @override
  String get dateCanNotBeInPast => "तारीख अतीत में नहीं हो सकती";
  @override
  String get configureTaskchampion => "Taskchampion कॉन्फ़िगर करें";
  @override
  String get encryptionSecret => 'एन्क्रिप्शन सीक्रेट';
  @override
  String get ccsyncBackendUrl => 'CCSync बैकएंड URL';
  @override
  String get ccsyncClientId => 'क्लाइंट आईडी';
  @override
  String get success => 'सफलता';
  @override
  String get credentialsSavedSuccessfully =>
      'क्रेडेंशियल्स सफलतापूर्वक सहेजे गए';
  @override
  String get saveCredentials => 'क्रेडेंशियल्स सहेजें';
  @override
  String get tip =>
      "टिप: अपनी क्रेडेंशियल्स प्राप्त करने के लिए ऊपर दाईं ओर स्थित जानकारी आइकन पर क्लिक करें";
  @override
  String get logs => 'लॉग्स';
  @override
  String get checkAllDebugLogsHere => 'यहाँ सभी डिबग लॉग्स देखें';
  // सेटिंग
  @override
  String get syncSetting => 'सिंक सेटिंग';
  @override
  String get displaySettings => 'डिस्प्ले सेटिंग्स';
  @override
  String get storageAndData => 'स्टोरेज और डेटा';
  @override
  String get advanced => 'अड्वांस्ड';
}
