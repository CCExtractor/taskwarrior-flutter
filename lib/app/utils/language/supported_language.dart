enum SupportedLanguage {
  english,
  hindi,
  marathi,
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
      default:
        return null;
    }
  }
}
