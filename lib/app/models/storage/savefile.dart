import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:file_selector/file_selector.dart';
import 'package:file_picker_writable/file_picker_writable.dart';

Future<void> saveServerCert(String contents) async {
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    var saveLocation = await getSaveLocation(
      suggestedName: 'server.cert.pem',
    );

    if (saveLocation != null) {
      var data = Uint8List.fromList(contents.codeUnits);
      var file = XFile.fromData(data);
      await file.saveTo(saveLocation.path);
    }
  } else {
    await FilePickerWritable().openFileForCreate(
      fileName: 'server.cert.pem',
      writer: (tempFile) => tempFile.writeAsString(contents),
    );
  }
}

String formatDateValue(dynamic val) {
  if (val == null) return '-';

  try {
    final dt = DateTime.parse(val.toString()).toLocal();
    return '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}:'
        '${dt.second.toString().padLeft(2, '0')}';
  } catch (_) {
    return val.toString(); // fallback
  }
}

String formatTasksAsTxt(String contents) {
  Map<String, String> labelMap = {
    'description': 'Description',
    'status': 'Status',
    'due': 'Due',
    'project': 'Project',
    'priority': 'Priority',
    'uuid': 'UUID',
    'tags': 'Tags',
    'depends': 'Depends',
    'annotations': 'Annotations',
    'entry': 'Entry',
    'modified': 'Modified',
    'start': 'Start',
    'wait': 'Wait',
    'recur': 'Recur',
    'rtype': 'RType',
    'urgency': 'Urgency',
    'end': 'End',
    'id': 'ID'
  };

  String formatTaskMap(Map m) {
    final entryVal = m['entry'];
    final startVal = m['start'];

    List<String> order = [
      'id',
      'description',
      'status',
      'project',
      'due',
      'priority',
      'uuid',
      'entry',
      'modified',
      'start',
      'wait',
      'recur',
      'rtype',
      'urgency',
      'end',
      'tags',
      'depends',
      'annotations'
    ];
    List<String> lines = [];
    for (var key in order) {
      if (!m.containsKey(key) || m[key] == null) continue;
      if (key == 'start' &&
          startVal != null &&
          entryVal != null &&
          startVal.toString() == entryVal.toString()) {
        continue;
      }

      var val = m[key];
      if (key == 'tags' || key == 'depends') {
        if (val is List) {
          lines.add('${labelMap[key]}: ${val.join(', ')}');
        } else {
          lines.add('${labelMap[key]}: $val');
        }
      } else if (key == 'annotations') {
        if (val is List && val.isNotEmpty) {
          lines.add('${labelMap[key]}:');
          for (var a in val) {
            if (a is Map) {
              var entry = a['entry'] ?? '';
              var desc = a['description'] ?? '';
              lines.add('  - ${labelMap['entry']}: $entry');
              lines.add('    Description: $desc');
            } else {
              lines.add('  - $a');
            }
          }
        }
      } else {
        final isDateField =
            ['due', 'entry', 'modified', 'start', 'wait', 'end'].contains(key);

        lines.add(
          '${labelMap[key] ?? key}: '
          '${isDateField ? formatDateValue(val) : val.toString()}',
        );
      }
    }
    return lines.join('\n');
  }

  dynamic parsed;
  try {
    parsed = json.decode(contents);
  } catch (_) {
    try {
      // Attempt to convert Dart-style maps (single quotes) to JSON
      var fixed = contents.replaceAll("'", '"');
      parsed = json.decode(fixed);
    } catch (e) {
      return contents; // fallback to original if parsing fails
    }
  }

  if (parsed is List) {
    return parsed.map((e) {
      if (e is Map) return formatTaskMap(Map.from(e));
      return e.toString();
    }).join('\n\n');
  } else if (parsed is Map) {
    return formatTaskMap(Map.from(parsed));
  } else {
    return parsed.toString();
  }
}

Future<void> exportTasks({
  required String contents,
  required String suggestedName,
}) async {
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    var saveLocation = await getSaveLocation(
      suggestedName: suggestedName,
    );

    if (saveLocation != null) {
      var data = Uint8List.fromList(contents.codeUnits);
      var file = XFile.fromData(data);
      await file.saveTo(saveLocation.path);
    }
  } else {
    await FilePickerWritable().openFileForCreate(
      fileName: suggestedName,
      writer: (tempFile) => tempFile.writeAsString(contents),
    );
  }
}
