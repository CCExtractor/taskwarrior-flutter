enum SupportedLanguage {
  english,
  hindi,
  marathi,
  french,  
  spanish,  
  bengali,  
}


extension SupportedLanguageExtension on SupportedLanguage {
  String get languageCode {
    switch (this) {
      case SupportedLanguage.english:
        return 'en';
      case SupportedLanguage.hindi:
        return 'hi';
      case SupportedLanguage.marathi:
        return 'mr';
      case SupportedLanguage.french:
        return 'fr';  
      case SupportedLanguage.spanish:
        return 'es';  
      case SupportedLanguage.bengali:
        return 'bn';  
      default:
        return '';
    }
  }

  static SupportedLanguage? fromCode(String? code) {
    switch (code) {
      case 'en':
        return SupportedLanguage.english;
      case 'hi':
        return SupportedLanguage.hindi;
      case 'mr':
        return SupportedLanguage.marathi;
      case 'fr':
        return SupportedLanguage.french;  
      case 'es':
        return SupportedLanguage.spanish;  
      case 'bn':
        return SupportedLanguage.bengali;  
      default:
        return null;
    }
  }
}
