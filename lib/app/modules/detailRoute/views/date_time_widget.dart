import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/attribute_card.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

/// Due / wait / until editor: tap picks a future date and time, long-press
/// clears it.
class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({
    super.key,
    required this.name,
    required this.value,
    required this.displayValue,
    required this.callback,
    required this.globalKey,
    this.isEditable = true,
  });

  final String name;

  /// The stored date, used to seed the picker.
  final DateTime? value;

  /// [value] formatted for display.
  final String? displayValue;
  final void Function(dynamic) callback;
  final GlobalKey globalKey;
  final bool isEditable;

  Future<void> _pickDateTime(BuildContext context) async {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    var now = DateTime.now();
    var current = value?.toLocal() ?? now;
    var initialDate = current.isBefore(now) ? now : current;

    var date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(2037, 12, 31), // < 2038-01-19T03:14:08.000Z
    );
    if (date == null || !context.mounted) return;

    var time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: AppSettings.use24HourFormatRx.value,
          ),
          child: child!,
        );
      },
    );
    if (time == null || !context.mounted) return;

    var dateTime = date.add(
      Duration(
        hours: time.hour,
        minutes: time.minute,
      ),
    );

    if (dateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            SentenceManager(
              currentLanguage: AppSettings.selectedLanguage,
            ).sentences.cantSetTimeinPast,
            style: TextStyle(
              color: tColors.primaryTextColor,
            ),
          ),
          backgroundColor: tColors.primaryBackgroundColor,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      callback(dateTime.toUtc());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AttributeCard(
      cardKey: globalKey,
      name: name,
      value: displayValue,
      isEditable: isEditable,
      onTap: () => _pickDateTime(context),
      onLongPress: () => callback(null),
    );
  }
}
