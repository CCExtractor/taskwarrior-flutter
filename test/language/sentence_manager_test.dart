import 'package:test/test.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';

void main() {
  group('SentenceManager Tests', () {
    test('Should return "Hello, World!" for English', () {
      final sentenceManager = SentenceManager(currentLanguage: SupportedLanguage.english);
      expect(sentenceManager.sentences.helloWorld, 'Hello, World!');
    });

    test('Should return "হ্যালো বিশ্ব!" for Bengali', () {
      final sentenceManager = SentenceManager(currentLanguage: SupportedLanguage.bengali);
      expect(sentenceManager.sentences.helloWorld, 'হ্যালো বিশ্ব!');
    });

    test('Should return "नमस्ते दुनिया!" for Hindi', () {
      final sentenceManager = SentenceManager(currentLanguage: SupportedLanguage.hindi);
      expect(sentenceManager.sentences.helloWorld, 'नमस्ते दुनिया!');
    });
    test('Should return "Bonjour, le monde!" for French', () {
      final sentenceManager = SentenceManager(currentLanguage: SupportedLanguage.french);
      expect(sentenceManager.sentences.helloWorld, 'Bonjour, le monde!');
    });

    test('Should return "¡Hola, Mundo!" for Spanish', () {
      final sentenceManager = SentenceManager(currentLanguage: SupportedLanguage.spanish);
      expect(sentenceManager.sentences.helloWorld, '¡Hola, mundo!');
    });

    test('Should return "नमस्ते दुनिया!" for Marathi', () {
      final sentenceManager = SentenceManager(currentLanguage: SupportedLanguage.marathi);
      expect(sentenceManager.sentences.helloWorld, 'नमस्कार, जग!');
    });
  });
}
