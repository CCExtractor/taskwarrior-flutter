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
      'तातडीच्या कार्यांना हायलाईट करा';
  @override
  String get settingsPageHighlightTaskDescription =>
      '1 दिवसाच्या आत देय किंवा मुदत संपलेल्या कार्यांना हायलाईट करा';
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
  String get deleteAllTasksWillBeMarkedAsDeleted =>
      'हे सर्व कार्य हटवले म्हणून चिन्हांकित केले जातील आणि अ‍ॅपमध्ये दिसणार नाहीत.';

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
  String get profilePageChangeProfileMode => 'प्रोफाइल मोड बदला';
  @override
  String get profilePageSelectProfileMode => 'प्रोफाइल मोड निवडा';
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

  // मुख्य पृष्ठ
  @override
  String get homePageSearchTooltip => 'शोधा';
  @override
  String get homePageCancelSearchTooltip => 'रद्द करा';
  @override
  String get homePageAddTaskTooltip => 'कार्य जोडा';
  @override
  String get homePageTapBackToExit => 'बाहेर पडण्यासाठी पुन्हा मागे टॅप करा';
  @override
  String get homePageSearchHint => 'शोधा';

// नेव्हिगेशन ड्रॉवर
  @override
  String get navDrawerConfirm => 'निश्चित करा';

// फिल्टर ड्रॉवर
  @override
  String get filterDrawerNoProjectsAvailable => 'कोणतेही प्रकल्प उपलब्ध नाहीत.';

// सामान्य सेटिंग्ज
  @override
  String get version => "आवृत्ती";
  @override
  String get package => "पॅकेज";

  @override
  String get notSelected => "निवडलेले नाही";
  @override
  String get cantSetTimeinPast => "मागील वेळ सेट करू शकत नाही";

  @override
  String get editDescription => "वर्णन संपादित करा";
  @override
  String get editProject => "प्रकल्प संपादित करा";
  @override
  String get cancel => "रद्द करा";
  @override
  String get submit => "सबमिट करा";

  @override
  String get saveChangesConfirmation => 'तुम्हाला बदल जतन करायचे आहेत का?';
  @override
  String get yes => 'होय';
  @override
  String get no => 'नाही';
  @override
  String get reviewChanges => 'बदल पहा';
  @override
  String get oldChanges => 'जुने';
  @override
  String get newChanges => 'नवीन';

  @override
  String get tags => 'टॅग्स';
  @override
  String get addedTagsWillAppearHere => 'जोडलेले टॅग येथे दिसतील';
  @override
  String get addTag => 'टॅग जोडा';

  @override
  String get enterProject => 'प्रकल्प प्रविष्ट करा';
  @override
  String get allProjects => 'सर्व प्रकल्प';
  @override
  String get noProjectsFound => 'प्रकल्प सापडले नाहीत';
  @override
  String get project => 'प्रकल्प';

  @override
  String get select => 'निवडा';
  @override
  String get save => 'जतन करा';
  @override
  String get dontSave => 'जतन करू नका';
  @override
  String get unsavedChanges => 'जतन न केलेले बदल';
  @override
  String get unsavedChangesWarning =>
      'तुमच्याकडे जतन न केलेले बदल आहेत. तुम्हाला काय करायचे आहे?';
  @override
  String get enterNew => 'नवीन प्रविष्ट करा';
  @override
  String get edit => 'संपादित करा';
  @override
  String get task => 'कार्य';

// कार्य क्रिया
  @override
  String get confirmDeleteTask => 'हटवण्याची खात्री करा';
  @override
  String get taskUpdated => 'कार्य अद्यतनित झाले';
  @override
  String get undo => 'पूर्ववत करा';
  @override
  String get taskMarkedAsCompleted =>
      'कार्य पूर्ण म्हणून चिन्हांकित केले. बदल पाहण्यासाठी रीफ्रेश करा!';
  @override
  String get taskMarkedAsDeleted => 'कार्य हटवले. बदल पाहण्यासाठी रीफ्रेश करा!';
  @override
  String get refreshToViewChanges => 'बदल पाहण्यासाठी रीफ्रेश करा';
  @override
  String get clickOnBottomRightButtonToStartAddingTasks =>
      'कार्ये जोडण्यास सुरुवात करण्यासाठी खालील उजव्या कोपऱ्यातील बटणावर क्लिक करा';
  @override
  String get complete => 'पूर्ण';
  @override
  String get delete => 'हटवा';

// कार्य सर्व्हर व्यवस्थापन
  @override
  String get taskServerInfo => 'TaskD सर्व्हर माहिती';
  @override
  String get taskServerCredentials => 'TaskD सर्व्हर क्रेडेन्शियल्स';
  @override
  String get notConfigured => 'संयोजित नाही';
  @override
  String get fetchingStatistics => 'आकडेवारी मिळवत आहोत...';
  @override
  String get pleaseWait => 'कृपया प्रतीक्षा करा...';
  @override
  String get statistics => 'आकडेवारी:';
  @override
  String get ok => 'ठीक आहे';
  @override
  String get pleaseSetupTaskServer => 'कृपया TaskServer सेटअप करा.';

// ऑनबोर्डिंग
  @override
  String get onboardingSkip => 'वगळा';
  @override
  String get onboardingNext => 'पुढे';
  @override
  String get onboardingStart => 'सुरु करा';

// परवानगी सेटिंग्ज
  @override
  String get permissionPageTitle => 'आम्हाला तुमच्या परवानगीची गरज का आहे';
  @override
  String get storagePermissionTitle => 'साठवण परवानगी';
  @override
  String get storagePermissionDescription =>
      'तुमचे कार्य, प्राधान्ये आणि अ‍ॅप डेटा सुरक्षित ठेवण्यासाठी आम्ही स्टोरेज प्रवेशाचा उपयोग करतो.';
  @override
  String get notificationPermissionTitle => 'सूचना परवानगी';
  @override
  String get notificationPermissionDescription =>
      'महत्वाच्या आठवणी आणि अद्यतनांसाठी सूचना आवश्यक आहेत.';
  @override
  String get privacyStatement =>
      'तुमचा गोपनीयता आमच्यासाठी महत्त्वाची आहे. आम्ही तुमचा डेटा शेअर करत नाही.';
  @override
  String get grantPermissions => 'परवानगी द्या';
  @override
  String get managePermissionsLater =>
      'तुम्ही नंतर सेटिंग्जमध्ये परवानग्या व्यवस्थापित करू शकता';

// प्रोफाइल पृष्ठ
  @override
  String get profileAllProfiles => 'सर्व प्रोफाइल:';
  @override
  String get profileSwitchedToProfile => 'प्रोफाइल स्विच केले';
  @override
  String get profileAddedSuccessfully => 'प्रोफाइल यशस्वीरित्या जोडले';
  @override
  String get profileAdditionFailed => 'प्रोफाइल जोडण्यात अयशस्वी';
  @override
  String get profileConfigCopied => 'प्रोफाइल कॉन्फिगरेशन कॉपी केले';
  @override
  String get profileConfigCopyFailed =>
      'प्रोफाइल कॉन्फिगरेशन कॉपी करण्यात अयशस्वी';
  @override
  String get profileDeletedSuccessfully => 'प्रोफाइल हटवले';
  @override
  String get profileDeletionFailed => 'प्रोफाइल हटवण्यात अयशस्वी';
  @override
  String get profileDeleteConfirmation => 'खात्री करा';

// अहवाल
  @override
  String get reportsDate => 'तारीख';
  @override
  String get reportsPending => 'प्रलंबित';
  @override
  String get reportsCompleted => 'पूर्ण झाले';
  @override
  String get reportsMonthYear => 'महिना-वर्ष';
  @override
  String get reportsWeek => 'आठवडा';
  @override
  String get reportsDay => 'दिवस';
  @override
  String get reportsYear => 'वर्ष';
  @override
  String get reportsError => 'त्रुटी';
  @override
  String get reportsLoading => 'लोड करत आहे...';

// सेटिंग्ज
  @override
  String get settingsResetToDefault => 'मूळ सेटिंग्जवर पुनर्स्थित करा';
  @override
  String get settingsAlreadyDefault => 'मूळ सेटिंग्जमध्ये आधीच आहेत';
  @override
  String get settingsConfirmReset =>
      'तुम्हाला सेटिंग्ज डिफॉल्टवर रीसेट करायच्या आहेत का?';
  @override
  String get settingsNoButton => 'नाही';
  @override
  String get settingsYesButton => 'होय';

// स्प्लॅश स्क्रीन
  @override
  String get splashSettingUpApp => "अ‍ॅप सेटअप करत आहे...";

// टूर - अहवाल
  @override
  String get tourReportsDaily => "येथे तुमचा दैनंदिन अहवाल पहा";
  @override
  String get tourReportsWeekly => "येथे तुमचा साप्ताहिक अहवाल पहा";
  @override
  String get tourReportsMonthly => "येथे तुमचा मासिक अहवाल पहा";

// टूर - प्रोफाइल
  @override
  String get tourProfileCurrent => "सध्याचे प्रोफाइल पहा";
  @override
  String get tourProfileManage => "तुमचे प्रोफाइल व्यवस्थापित करा";
  @override
  String get tourProfileAddNew => "नवीन प्रोफाइल जोडा";

// टूर - मुख्य पृष्ठ
  @override
  String get tourHomeAddTask => "नवीन कार्य जोडा";
  @override
  String get tourHomeSearch => "कार्य शोधा";
  @override
  String get tourHomeRefresh => "तुमची कार्ये रीफ्रेश किंवा समक्रमित करा";
  @override
  String get tourHomeFilter => "कार्ये आणि प्रकल्प फिल्टर करा";
  @override
  String get tourHomeMenu => "अतिरिक्त सेटिंग्ज पहा";

// टूर - कार्य तपशील
  @override
  String get tourDetailsDue => "हे कार्याची अंतिम मुदत दर्शवते";
  @override
  String get tourDetailsPriority => "हे कार्याची प्राधान्यता दर्शवते";

  @override
  String get tourDetailsUntil => "ही कार्याची अंतिम तारीख दर्शवते";

  @override
  String get tourDetailsWait =>
      "ही कार्याची प्रतीक्षा तारीख दर्शवते \n हे कार्य या तारखेनंतर दिसेल";

  @override
  String get tourFilterProjects => "प्रकल्पांवर आधारित कार्य फिल्टर करा";

  @override
  String get tourFilterSort =>
      "निर्मिती वेळ, तातडी, मुदत, प्रारंभ तारीख इत्यादीवर आधारित कार्य क्रमवारी लावा";

  @override
  String get tourFilterStatus => "पूर्णता स्थितीनुसार कार्य फिल्टर करा";

  @override
  String get tourFilterTagUnion =>
      "AND आणि OR टॅग युनियन प्रकारांमध्ये टॉगल करा";

  @override
  String get tourTaskServerCertificate =>
      "येथे तुमच्या ईमेलसह नाव असलेली फाईल निवडा (उदा. <तुमचा ईमेल>.com.cert.pem)";

  @override
  String get tourTaskServerKey =>
      "येथे तुमच्या ईमेलसह नाव असलेली फाईल निवडा (उदा. <तुमचा ईमेल>.key.pem)";

  @override
  String get tourTaskServerRootCert =>
      "येथे letsencrypt_root_cert.pem नाव असलेली फाईल निवडा";

  @override
  String get tourTaskServerTaskRC =>
      "येथे taskrc नावाची फाईल निवडा किंवा तिची सामग्री पेस्ट करा";
  @override
  String get descriprtionCannotBeEmpty => "वर्णन रिक्त असू शकत नाही";
  @override
  String get enterTaskDescription => "कार्याचे वर्णन प्रविष्ट करा";
  @override
  String get canNotHaveWhiteSpace => "रिक्त जागा असू शकत नाही";
  @override
  String get high => "उच्च";
  @override
  String get medium => "मध्यम";
  @override
  String get low => "कमी";
  @override
  String get priority => "प्राधान्य";
  @override
  String get tagAlreadyExists => "टॅग आधीच अस्तित्वात आहे";
  @override
  String get tagShouldNotContainSpaces => "टॅगमध्ये रिक्त जागा असू शकत नाही";
  @override
  String get date => 'तारीख';
  @override
  String get add => 'जोडा';
  @override
  String get change => 'बदल';
  @override
  String get dateCanNotBeInPast => "तारीख भूतकाळात असू शकत नाही";
  @override
  String get configureTaskchampion => "Taskchampion कॉन्फिगर करा";
  @override
  String get encryptionSecret => 'एन्क्रिप्शन गुपित';
  @override
  String get ccsyncBackendUrl => 'CCSync बॅकएंड URL';
  @override
  String get ccsyncClientId => 'क्लायंट आयडी';
  @override
  String get success => 'यशस्वी';
  @override
  String get credentialsSavedSuccessfully =>
      'क्रेडेन्शियल्स यशस्वीरित्या जतन केले';
  @override
  String get saveCredentials => 'क्रेडेन्शियल्स जतन करा';
  @override
  String get tip =>
      "टीप: तुमची क्रेडेन्शियल्स मिळवण्यासाठी वरच्या उजव्या कोपऱ्यातील माहिती चिन्हावर क्लिक करा";
  @override
  String get logs => 'लॉग्ज';
  @override
  String get checkAllDebugLogsHere => 'येथे सर्व डीबग लॉग्ज तपासा';
}
