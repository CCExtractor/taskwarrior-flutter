import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/taskfunctions/add_task_dialog_utils.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class AddTaskDatePickerInput extends StatefulWidget {
  final Function(List<DateTime?>)? onDateChanges;
  final bool onlyDueDate;
  const AddTaskDatePickerInput(
      {super.key, this.onDateChanges, this.onlyDueDate = false});

  @override
  _AddTaskDatePickerInputState createState() => _AddTaskDatePickerInputState();
}

class _AddTaskDatePickerInputState extends State<AddTaskDatePickerInput> {
  final List<DateTime?> _selectedDates = List<DateTime?>.filled(4, null);
  final List<String> dateLabels = ['Due', 'Wait', 'Sched', 'Until'];
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final int length = 4;
  int currentIndex = 0;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown for date type selection
        if (!widget.onlyDueDate)
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: currentIndex,
                items: List.generate(length, (index) {
                  bool hasDate = _selectedDates[index] != null;
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                              hasDate
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              size: 14,
                              color: Colors.white),
                        ),
                        Text(dateLabels[index]),
                      ],
                    ),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      currentIndex = value;
                    });
                  }
                },
              ),
            ),
          ),
        // Date picker field
        Expanded(
          child: buildDatePicker(context, currentIndex),
        ),
      ],
    );
  }

  Widget buildDatePicker(BuildContext context, int forIndex) {
    _controllers[forIndex].text = _selectedDates[forIndex] == null
        ? ''
        : dateToStringForAddTask(_selectedDates[forIndex]!);

    return TextFormField(
      controller: _controllers[forIndex],
      decoration: InputDecoration(
        labelText:
            SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                .sentences
                .date,
        hintText:
            '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.select} ${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.date}',
        suffixIcon: const Icon(Icons.calendar_today),
        border: const OutlineInputBorder(),
      ),
      validator: _validator,
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDates[forIndex] ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        final TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked == null || time == null) return;
        setState(() {
          _selectedDates[forIndex] =
              picked.add(Duration(hours: time.hour, minutes: time.minute));
          // Update the controller text
          _controllers[forIndex].text =
              dateToStringForAddTask(_selectedDates[forIndex]!);
        });
        if (widget.onDateChanges != null) {
          widget.onDateChanges!(_selectedDates);
        }
      },
    );
  }

  String? _validator(value) {
    for (var i = 0; i < length; i++) {
      DateTime? dt = _selectedDates[i];
      String? label = dateLabels[i];
      if (dt != null && dt.isBefore(DateTime.now())) {
        return "$label ${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.dateCanNotBeInPast}";
      }
    }
    return null;
  }
}
