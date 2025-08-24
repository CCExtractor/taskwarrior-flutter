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

  int getNextIndex() => (currentIndex + 1) % length;

  int getPreviousIndex() => (currentIndex - 1) % length;

  void _showNextItem() {
    setState(() {
      currentIndex = getNextIndex();
    });
  }

  void _showPreviousItem() {
    setState(() {
      currentIndex = getPreviousIndex();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    bool isNextDateSelected = _selectedDates[getNextIndex()] != null;
    bool isPreviousDateSelected = _selectedDates[getPreviousIndex()] != null;
    String nextDateText = isNextDateSelected
        ? "${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.change} ${dateLabels[getNextIndex()]} ${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.date}"
        : "${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.add} ${dateLabels[getNextIndex()]} ${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.date}";

    String prevDateText = isPreviousDateSelected
        ? "${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.change} ${dateLabels[getPreviousIndex()]} ${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.date}"
        : "${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.add} ${dateLabels[getPreviousIndex()]} ${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.date}";
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display the current input field
        Flexible(
          child: buildDatePicker(context, currentIndex),
        ),
        // Navigation buttons
        Visibility(
          visible: !widget.onlyDueDate,
          child: Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: _showPreviousItem,
                  label: Text(
                    prevDateText,
                    style: TextStyle(
                      fontSize: 12,
                      decoration: isPreviousDateSelected
                          ? TextDecoration.none
                          : TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.wavy,
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 12,
                    color: tColors.primaryTextColor,
                  ),
                  iconAlignment: IconAlignment.start,
                ),
              ),
              const SizedBox(width: 8), // Space between buttons
              Expanded(
                child: TextButton.icon(
                  onPressed: _showNextItem,
                  label: Text(
                    nextDateText,
                    style: TextStyle(
                      fontSize: 12,
                      decoration: isNextDateSelected
                          ? TextDecoration.none
                          : TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.wavy,
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: tColors.primaryTextColor,
                  ),
                  iconAlignment: IconAlignment.end,
                ),
              ),
            ],
          ),
        )
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
            '${dateLabels[forIndex]} ${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.date}',
        hintText:
            '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.select} ${dateLabels[forIndex]}',
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
