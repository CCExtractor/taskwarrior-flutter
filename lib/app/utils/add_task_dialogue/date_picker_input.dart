import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/taskfunctions/add_task_dialog_utils.dart';

class AddTaskDatePickerInput extends StatefulWidget {
  final Function(List<DateTime?>)? onDateChanges;
  final bool onlyDueDate;
  final List<int> allowedIndexes;
  final bool disableDueDate;
  final List<DateTime?> initialDates;
  const AddTaskDatePickerInput(
      {super.key,
      this.onDateChanges,
      this.onlyDueDate = false,
      this.allowedIndexes = const [0, 1, 2, 3],
      this.disableDueDate = false,
      this.initialDates = const [null, null, null, null]});

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

  List<int> get _effectiveAllowedIndexes => widget.allowedIndexes
      .where((index) => !(widget.disableDueDate && index == 0))
      .toList();

  void _normalizeCurrentIndex() {
    if (widget.onlyDueDate) {
      currentIndex = 0;
      return;
    }
    final allowed = _effectiveAllowedIndexes;
    if (allowed.isEmpty) {
      currentIndex = 0;
      return;
    }
    if (!allowed.contains(currentIndex)) {
      currentIndex = allowed.first;
    }
  }

  void _applyInitialDates(List<DateTime?> values) {
    for (var i = 0; i < length; i++) {
      _selectedDates[i] = i < values.length ? values[i] : null;
    }
  }

  bool _sameDates(List<DateTime?> a, List<DateTime?> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _applyInitialDates(widget.initialDates);
  }

  @override
  void didUpdateWidget(covariant AddTaskDatePickerInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_sameDates(widget.initialDates, oldWidget.initialDates)) {
      _applyInitialDates(widget.initialDates);
    }
    if (widget.disableDueDate != oldWidget.disableDueDate &&
        widget.disableDueDate) {
      _selectedDates[0] = null;
      _controllers[0].text = '';
      if (widget.onDateChanges != null) {
        widget.onDateChanges!(List<DateTime?>.from(_selectedDates));
      }
    }
    _normalizeCurrentIndex();
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
    _normalizeCurrentIndex();
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
                items: [
                  for (int index in _effectiveAllowedIndexes)
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
                  if (value != null) setState(() => currentIndex = value);
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

    final bool isDueField = forIndex == 0;
    final bool isDisabled = isDueField && widget.disableDueDate;

    return TextFormField(
      enabled: !isDisabled,
      controller: _controllers[forIndex],
      decoration: InputDecoration(
        labelText:
            SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                .sentences
                .date,
        hintText: isDisabled
            ? 'Due date disabled for recurring tasks'
            : '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.select} ${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.date}',
        suffixIcon: const Icon(Icons.calendar_today),
        border: const OutlineInputBorder(),
      ),
      validator: _validator,
      readOnly: true,
      onTap: () async {
        if (isDisabled) {
          return;
        }
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
          setState(() {
            // Set date with end-of-day time (23:59)
            _selectedDates[forIndex] = picked.add(
              const Duration(hours: 23, minutes: 59),
            );
            // Update the controller text
            _controllers[forIndex].text =
                dateToStringForAddTask(_selectedDates[forIndex]!);
          });
          if (widget.onDateChanges != null) {
            widget.onDateChanges!(List<DateTime?>.from(_selectedDates));
          }
          return;
        }

        // Both date and time selected
        setState(() {
          _selectedDates[forIndex] =
              picked.add(Duration(hours: time.hour, minutes: time.minute));
          // Update the controller text
          _controllers[forIndex].text =
              dateToStringForAddTask(_selectedDates[forIndex]!);
        });
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
