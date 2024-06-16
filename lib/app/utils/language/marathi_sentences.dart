import 'package:taskwarrior/app/utils/language/sentences.dart';

class MarathiSentences extends Sentences {
  @override
  String get helloWorld => 'नमस्कार, जग!';
  @override
  String get homePageTitle => 'होम पेज';
  @override
  String get homePageLastModified => 'गेल्या बदल';
  @override
  String get homePageDue => 'देय';
  @override
  String get homePageTaskWarriorNotConfigured => 'TaskServer कॉन्फ़िगर नाही';
  @override
  String get homePageSetup => 'सेटअप';
  @override
  String get homePageFilter => 'फिल्टर';
  @override
  String get homePageMenu => 'मेन्यू';
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
  String get navDrawerProfile => 'प्रोफ़ाइल';
  @override
  String get navDrawerReports => 'अहवाल';
  @override
  String get navDrawerAbout => 'चरित्र';
  @override
  String get navDrawerSettings => 'सेटिंग्स';
  @override
  String get navDrawerExit => 'बाहेर पडा';
}
