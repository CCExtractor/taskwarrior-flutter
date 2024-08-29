import 'package:taskwarrior/app/utils/language/english_sentences.dart';
import 'package:taskwarrior/app/utils/language/hindi_sentences.dart';
import 'package:taskwarrior/app/utils/language/marathi_sentences.dart';
import 'package:taskwarrior/app/utils/language/french_sentences.dart';  // Import for French
import 'package:taskwarrior/app/utils/language/spanish_sentences.dart';  // Import for Spanish
import 'package:taskwarrior/app/utils/language/bengali_sentences.dart';  // Import for Bengali
import 'package:taskwarrior/app/utils/language/sentences.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';

class SentenceManager {
  final SupportedLanguage currentLanguage;

  SentenceManager({required this.currentLanguage});

  Sentences get sentences {
    switch (currentLanguage) {
      case SupportedLanguage.hindi:
        return HindiSentences();
      case SupportedLanguage.marathi:
        return MarathiSentences();
      case SupportedLanguage.french:
        return FrenchSentences(); 
      case SupportedLanguage.spanish:
        return SpanishSentences(); 
      case SupportedLanguage.bengali:
        return BengaliSentences(); 
      case SupportedLanguage.english:
      default:
        return EnglishSentences();
    }
  }
}
