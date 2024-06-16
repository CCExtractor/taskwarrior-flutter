import 'package:taskwarrior/app/utils/language/supported_language.dart';

abstract class Sentences {
  String get helloWorld;

  String get homePageTitle;
  String get homePageLastModified;
  String get homePageDue;
  String get homePageTaskWarriorNotConfigured;
  String get homePageSetup;
  String get homePageFilter;
  String get homePageMenu;

  String get settingsPageTitle;
  String get settingsPageSubtitle;
  String get settingsPageMovingDataToNewDirectory;

  String get settingsPageSyncOnStartTitle;
  String get settingsPageSyncOnStartDescription;

  String get settingsPageEnableSyncOnTaskCreateTitle;
  String get settingsPageEnableSyncOnTaskCreateDescription;

  String get settingsPageHighlightTaskTitle;
  String get settingsPageHighlightTaskDescription;

  String get settingsPageEnable24hrFormatTitle;
  String get settingsPageEnable24hrFormatDescription;

  String get settingsPageSelectLanguage;
  String get settingsPageToggleNativeLanguage;

  String get settingsPageSelectDirectoryTitle;
  String get settingsPageSelectDirectoryDescription;

  String get navDrawerProfile;
  String get navDrawerReports;
  String get navDrawerAbout;
  String get navDrawerSettings;
  String get navDrawerExit;
}

class EnglishSentences extends Sentences {
  @override
  String get helloWorld => 'Hello, World!';
  @override
  String get homePageTitle => 'Home Page';
  @override
  String get homePageLastModified => 'Last Modified';
  @override
  String get homePageDue => 'Due';
  @override
  String get homePageTaskWarriorNotConfigured => 'TaskServer is not configured';
  @override
  String get homePageSetup => 'Setup';
  @override
  String get homePageFilter => 'Filter';
  @override
  String get homePageMenu => 'Menu';
  @override
  String get settingsPageTitle => 'Settings Page';
  @override
  String get settingsPageSubtitle => 'Configure your preferences';
  @override
  String get settingsPageMovingDataToNewDirectory =>
      'Moving data to new directory';
  @override
  String get settingsPageSyncOnStartTitle => 'Sync on Start';
  @override
  String get settingsPageSyncOnStartDescription =>
      'Automatically sync data on app start';
  @override
  String get settingsPageEnableSyncOnTaskCreateTitle => 'Sync on task create';
  @override
  String get settingsPageEnableSyncOnTaskCreateDescription =>
      'Enable automatic syncing when creating a new task';
  @override
  String get settingsPageHighlightTaskTitle => 'Highlight the task';
  @override
  String get settingsPageHighlightTaskDescription =>
      'Make the border of task if only 1 day left';
  @override
  String get settingsPageEnable24hrFormatTitle => 'Enable 24 hr format';
  @override
  String get settingsPageEnable24hrFormatDescription =>
      'Switch right to enable 24 hr format';
  @override
  String get settingsPageSelectLanguage => 'Select the language';
  @override
  String get settingsPageToggleNativeLanguage =>
      'Toggle between your native language';
  @override
  String get settingsPageSelectDirectoryTitle => 'Select the directory';
  @override
  String get settingsPageSelectDirectoryDescription =>
      'Select the directory where the TaskWarrior data is stored\nCurrent directory: ';
  @override
  String get navDrawerProfile => 'Profile';
  @override
  String get navDrawerReports => 'Reports';
  @override
  String get navDrawerAbout => 'About';
  @override
  String get navDrawerSettings => 'Settings';
  @override
  String get navDrawerExit => 'Exit';
}

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
  String get navDrawerProfile => 'प्रोफ़ाइल';
  @override
  String get navDrawerReports => 'रिपोर्ट्स';
  @override
  String get navDrawerAbout => 'के बारे में';
  @override
  String get navDrawerSettings => 'सेटिंग्स';
  @override
  String get navDrawerExit => 'बाहर जाओ';
}

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

class SentenceManager {
  final SupportedLanguage currentLanguage;

  SentenceManager({required this.currentLanguage});

  Sentences get sentences {
    switch (currentLanguage) {
      case SupportedLanguage.hindi:
        return HindiSentences();
      case SupportedLanguage.marathi:
        return MarathiSentences();
      case SupportedLanguage.english:
      default:
        return EnglishSentences();
    }
  }
}
