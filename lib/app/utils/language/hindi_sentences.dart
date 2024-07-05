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
      'निर्देशिका चुनें जहां TaskWarrior डेटा स्टोर होता है\nवर्तमान निर्देशिका: ';
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
      'CCSync या Taskchampion सिंक सर्वर के साथ TaskWarrior सिंक पर स्विच करें';

  @override
  String get taskchampionTileTitle => 'Taskchampion सिंक';
}
