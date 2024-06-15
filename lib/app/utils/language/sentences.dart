
import 'package:taskwarrior/app/utils/language/supported_language.dart';

abstract class Sentences {
  String get helloWorld;
  String get homePageTitle;
  String get settingsPageTitle;
  String get settingsPageSubtitle;
}



class EnglishSentences extends Sentences {
  @override
  String get helloWorld => 'Hello, World!';
  @override
  String get homePageTitle => 'Home Page';
  @override
  String get settingsPageTitle => 'Settings Page';
  @override
  String get settingsPageSubtitle => 'Configure your preferences';
}


class HindiSentences extends Sentences {
  @override
  String get helloWorld => 'नमस्ते दुनिया!';
  @override
  String get homePageTitle => 'होम पेज';
  @override
  String get settingsPageTitle => 'सेटिंग्स पेज';
  @override
  String get settingsPageSubtitle => 'अपनी पसंद सेट करें';
}



class MarathiSentences extends Sentences {
  @override
  String get helloWorld => 'नमस्कार, जग!';
  @override
  String get homePageTitle => 'होम पेज';
  @override
  String get settingsPageTitle => 'सेटिंग्स पेज';
  @override
  String get settingsPageSubtitle => 'तुमची पसंती सेट करा';
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
