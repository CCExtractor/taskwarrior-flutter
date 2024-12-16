import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';
import 'package:taskwarrior/app/utils/language/english_sentences.dart';
import 'package:taskwarrior/app/utils/language/hindi_sentences.dart';
import 'package:taskwarrior/app/utils/language/marathi_sentences.dart';
import 'package:taskwarrior/app/utils/language/french_sentences.dart';
import 'package:taskwarrior/app/utils/language/spanish_sentences.dart';
import 'package:taskwarrior/app/utils/language/bengali_sentences.dart';

void main() {
  group('SentenceManager', () {
    test('should return EnglishSentences when currentLanguage is English', () {
      final manager =
          SentenceManager(currentLanguage: SupportedLanguage.english);
      expect(manager.sentences, isA<EnglishSentences>());
    });

    test('should return HindiSentences when currentLanguage is Hindi', () {
      final manager = SentenceManager(currentLanguage: SupportedLanguage.hindi);
      expect(manager.sentences, isA<HindiSentences>());
    });

    test('should return MarathiSentences when currentLanguage is Marathi', () {
      final manager =
          SentenceManager(currentLanguage: SupportedLanguage.marathi);
      expect(manager.sentences, isA<MarathiSentences>());
    });

    test('should return FrenchSentences when currentLanguage is French', () {
      final manager =
          SentenceManager(currentLanguage: SupportedLanguage.french);
      expect(manager.sentences, isA<FrenchSentences>());
    });

    test('should return SpanishSentences when currentLanguage is Spanish', () {
      final manager =
          SentenceManager(currentLanguage: SupportedLanguage.spanish);
      expect(manager.sentences, isA<SpanishSentences>());
    });

    test('should return BengaliSentences when currentLanguage is Bengali', () {
      final manager =
          SentenceManager(currentLanguage: SupportedLanguage.bengali);
      expect(manager.sentences, isA<BengaliSentences>());
    });
  });
}
