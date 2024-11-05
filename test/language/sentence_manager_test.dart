import 'package:test/test.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';

void main() {
  group('SentenceManager Tests', () {
    test('Should return "Hello, World!" for English', () {
      final sentenceManager = SentenceManager(currentLanguage: SupportedLanguage.english);
      expect(sentenceManager.sentences.helloWorld, 'Hello, World!');
    });

    
  });
}
