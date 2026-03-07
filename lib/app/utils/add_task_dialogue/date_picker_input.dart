import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/taskfunctions/add_task_dialog_utils.dart';

class AddTaskDatePickerInput extends StatefulWidget {
  final Function(List<DateTime?>)? onDateChanges;
  final bool onlyDueDate;
  final List<int> allowedIndexes;
  const AddTaskDatePickerInput(
      {super.key,
      this.onDateChanges,
      this.onlyDueDate = false,
      this.allowedIndexes = const [0, 1, 2, 3]});

  @override
  _AddTaskDatePickerInputState createState() => _AddTaskDatePickerInputState();
}

class _AddTaskDatePickerInputState extends State<AddTaskDatePickerInput> {
  final _selectedDates = <DateTime?>[null, null, null, null].obs;
  final List<String> dateLabels = ['Due', 'Wait', 'Sched', 'Until'];
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final int length = 4;
  final _currentIndex = 0.obs;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for date type selection
            if (!widget.onlyDueDate)
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _currentIndex.value,
                    items: [
                      for (int index = 0; index < length; index++)
                        if (widget.allowedIndexes
                            .contains(index)) // Only add if allowed
                          DropdownMenuItem<int>(
                            value: index,
                            child: Row(
                              children: [
                                Text(dateLabels[index]),
                                if (_selectedDates[index] != null)
                                  const Icon(Icons.check_circle, size: 14),
                              ],
                            ),
                          ),
                    ],
                    onChanged: (value) {
                      if (value != null) _currentIndex.value = value;
                    },
                  ),
                ),
              ),
            // Date picker field
            Expanded(
              child: buildDatePicker(context, _currentIndex.value),
            ),
          ],
        ));
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

        // FIX: Check if date was selected before showing time picker
        if (picked == null) {
          return; // User canceled date picker, exit early
        }

        // Only show time picker if date was selected
        final TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        // If user cancels time picker, still set the date with default time
        if (time == null) {
          // Set date with end-of-day time (23:59)
          _selectedDates[forIndex] = picked.add(
            const Duration(hours: 23, minutes: 59),
          );
          if (widget.onDateChanges != null) {
            widget.onDateChanges!(List<DateTime?>.from(_selectedDates));
          }
          return;
        }

        // Both date and time selected
        _selectedDates[forIndex] =
            picked.add(Duration(hours: time.hour, minutes: time.minute));
        if (widget.onDateChanges != null) {
          widget.onDateChanges!(List<DateTime?>.from(_selectedDates));
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
