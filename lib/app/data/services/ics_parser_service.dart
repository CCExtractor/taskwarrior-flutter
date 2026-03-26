import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:flutter/foundation.dart';

class IcsParsedTask {
  final String description;
  final DateTime? due;
  final String project;
  final List<String> tags;

  IcsParsedTask({
    required this.description,
    this.due,
    required this.project,
    required this.tags,
  });
}

class IcsParserService {
  /// Parses the raw .ics content into a list of tasks.
  static List<IcsParsedTask> parseIcsContent(String content) {
    try {
      final iCalendar = ICalendar.fromString(content);
      final List<IcsParsedTask> tasks = [];

      for (var element in iCalendar.data) {
        if (element['type'] == 'VEVENT' || element['type'] == 'VTODO') {
          // extract summary
          String summary = element['summary']?.toString() ?? 'Imported Task';
          DateTime? dueDate;
          
          if (element['dtstart'] != null && element['dtstart'] is IcsDateTime) {
            dueDate = (element['dtstart'] as IcsDateTime).toDateTime()?.toUtc();
          }
          if (element['due'] != null && element['due'] is IcsDateTime) {
            dueDate = (element['due'] as IcsDateTime).toDateTime()?.toUtc();
          }

          tasks.add(IcsParsedTask(
            description: summary,
            due: dueDate,
            project: 'Imported',
            tags: ['ics_import'],
          ));
        }
      }
      return tasks;
    } catch (e) {
      debugPrint('Error parsing ICS: $e');
      rethrow;
    }
  }
}
