import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';

void main() {
  group('SupportedLanguageExtension', () {
    test('should return correct language code', () {
      expect(SupportedLanguage.english.languageCode, 'en');
      expect(SupportedLanguage.hindi.languageCode, 'hi');
      expect(SupportedLanguage.marathi.languageCode, 'mr');
      expect(SupportedLanguage.french.languageCode, 'fr');
      expect(SupportedLanguage.spanish.languageCode, 'es');
      expect(SupportedLanguage.bengali.languageCode, 'bn');
    });

    test('should return correct SupportedLanguage from code', () {
      expect(
          SupportedLanguageExtension.fromCode('en'), SupportedLanguage.english);
      expect(
          SupportedLanguageExtension.fromCode('hi'), SupportedLanguage.hindi);
      expect(
          SupportedLanguageExtension.fromCode('mr'), SupportedLanguage.marathi);
      expect(
          SupportedLanguageExtension.fromCode('fr'), SupportedLanguage.french);
      expect(
          SupportedLanguageExtension.fromCode('es'), SupportedLanguage.spanish);
      expect(
          SupportedLanguageExtension.fromCode('bn'), SupportedLanguage.bengali);
      expect(SupportedLanguageExtension.fromCode('unknown'), null);
    });
  });
}
