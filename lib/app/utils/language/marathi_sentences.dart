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
      'निर्देशिका निवडा जिथे TaskWarrior डेटा स्टोर केला जातो\nवर्तमान निर्देशिका: ';
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
}
