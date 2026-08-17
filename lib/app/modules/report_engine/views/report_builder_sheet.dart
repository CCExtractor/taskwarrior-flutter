import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/models/report.dart';
import 'package:taskwarrior/app/modules/report_engine/controllers/report_engine_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/taskchampion/virtual_filter_engine.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

/// Build or edit a custom report.
///
/// The filter expression is the hard part of this screen. Its syntax is not
/// guessable, and the engine ignores a token it does not understand rather than
/// rejecting it — so a typo produces a report that quietly matches everything.
/// Two things address that: tappable chips insert correct tokens, and a live
/// count of matching tasks shows the actual effect of whatever is typed.
class ReportBuilderSheet extends StatefulWidget {
  const ReportBuilderSheet({
    super.key,
    required this.controller,
    this.existing,
  });

  final ReportEngineController controller;

  /// The report being edited, or null when creating a new one.
  final ReportDefinition? existing;

  @override
  State<ReportBuilderSheet> createState() => _ReportBuilderSheetState();
}

class _ReportBuilderSheetState extends State<ReportBuilderSheet> {
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _filter;
  late final TextEditingController _columns;

  String _sortField = 'urgency';
  bool _sortAscending = false;
  String? _error;

  int? _matchCount;
  bool _counting = false;
  Timer? _debounce;

  static const List<String> _sortFields = <String>[
    'urgency',
    'due',
    'entry',
    'modified',
    'priority',
    'project',
    'description',
    'status',
  ];

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final ReportDefinition? e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _description = TextEditingController(text: e?.description ?? '');
    _filter = TextEditingController(text: e?.filterExpression ?? '');
    _columns = TextEditingController(
      text: (e?.columns.isNotEmpty ?? false)
          ? e!.columns.map((c) => c.field).join(',')
          : 'id,description',
    );
    if (e != null && e.sortCriteria.isNotEmpty) {
      _sortField = e.sortCriteria.first.field;
      _sortAscending = e.sortCriteria.first.ascending;
    }
    _refreshCount();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _name.dispose();
    _description.dispose();
    _filter.dispose();
    _columns.dispose();
    super.dispose();
  }

  /// Recount after a short pause so every keystroke does not read the replica.
  void _scheduleCount() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _refreshCount);
  }

  Future<void> _refreshCount() async {
    setState(() => _counting = true);
    try {
      final int n = await widget.controller.previewMatchCount(_filter.text);
      if (mounted) setState(() => _matchCount = n);
    } catch (_) {
      if (mounted) setState(() => _matchCount = null);
    } finally {
      if (mounted) setState(() => _counting = false);
    }
  }

  void _insertToken(String token) {
    final String current = _filter.text.trimRight();
    final String next = current.isEmpty ? token : '$current $token';
    _filter.text = next;
    _filter.selection = TextSelection.collapsed(offset: next.length);
    setState(() {});
    _scheduleCount();
  }

  Future<void> _save() async {
    final ReportDefinition draft = ReportDefinition(
      name: _name.text.trim(),
      description: _description.text.trim().isEmpty
          ? _name.text.trim()
          : _description.text.trim(),
      columns: ColumnSpec.parseList(_columns.text),
      sortCriteria: <SortCriterion>[
        SortCriterion(_sortField, ascending: _sortAscending)
      ],
      filterExpression:
          _filter.text.trim().isEmpty ? null : _filter.text.trim(),
      isCustom: true,
    );

    final String? error = await widget.controller.saveReport(draft);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final TaskwarriorColorTheme c =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final List<String> issues = VirtualFilterEngine.validate(_filter.text);
    final bool shadows = !_isEditing &&
        _name.text.trim().isNotEmpty &&
        widget.controller.shadowsDefault(_name.text);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditing ? 'Edit report' : 'New report',
              style: GoogleFonts.poppins(
                fontSize: TaskWarriorFonts.fontSizeLarge,
                fontWeight: TaskWarriorFonts.bold,
                color: c.primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),

            _field(c, _name, 'Name', 'e.g. work-today',
                enabled: !_isEditing, onChanged: (_) => setState(() {})),
            if (shadows)
              _hint(c,
                  'A built-in report is also called this. Yours will replace it.',
                  warn: true),

            _field(c, _description, 'Description',
                'What this report shows', onChanged: (_) => setState(() {})),

            const SizedBox(height: 8),
            Text('Filter',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: c.primaryTextColor)),
            const SizedBox(height: 4),
            _field(c, _filter, null, 'e.g. status:pending +READY',
                onChanged: (_) {
              setState(() {});
              _scheduleCount();
            }),

            // Tokens are offered rather than typed: the vocabulary is small and
            // fixed, and tapping cannot misspell it.
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final String t in VirtualFilterEngine.virtualTags)
                  _chip(c, '+$t', () => _insertToken('+$t')),
                for (final String a in VirtualFilterEngine.attributes)
                  _chip(c, '$a:', () => _insertToken('$a:')),
              ],
            ),

            const SizedBox(height: 10),
            _matchLine(c),
            for (final String issue in issues) _hint(c, issue, warn: true),

            const SizedBox(height: 16),
            Text('Sort by',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: c.primaryTextColor)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    // `value:` not `initialValue:` — the latter only exists in
                    // Flutter newer than the 3.29.2 this project pins in CI, so
                    // it compiles on a current local SDK and fails the build.
                    value: _sortField,
                    isDense: true,
                    dropdownColor: c.secondaryBackgroundColor,
                    decoration: const InputDecoration(
                        isDense: true, border: OutlineInputBorder()),
                    style: GoogleFonts.poppins(color: c.primaryTextColor),
                    items: [
                      for (final String f in _sortFields)
                        DropdownMenuItem<String>(value: f, child: Text(f)),
                    ],
                    onChanged: (v) =>
                        setState(() => _sortField = v ?? _sortField),
                  ),
                ),
                const SizedBox(width: 10),
                ToggleButtons(
                  isSelected: <bool>[!_sortAscending, _sortAscending],
                  onPressed: (i) => setState(() => _sortAscending = i == 1),
                  borderRadius: BorderRadius.circular(6),
                  constraints:
                      const BoxConstraints(minHeight: 38, minWidth: 58),
                  children: const <Widget>[Text('High→low'), Text('Low→high')],
                ),
              ],
            ),

            const SizedBox(height: 16),
            _field(c, _columns, 'Columns', 'id,description,due'),

            if (_error != null) _hint(c, _error!, warn: true),

            const SizedBox(height: 18),
            Row(
              children: [
                if (_isEditing)
                  TextButton.icon(
                    onPressed: () async {
                      final String? err = await widget.controller
                          .deleteReport(widget.existing!.name);
                      if (err == null && context.mounted) {
                        Navigator.of(context).pop(true);
                      } else if (context.mounted) {
                        setState(() => _error = err);
                      }
                    },
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(
                        foregroundColor: c.primaryTextColor),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel',
                      style: GoogleFonts.poppins(color: c.primaryTextColor)),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _name.text.trim().isEmpty ? null : _save,
                  child: Text(_isEditing ? 'Save' : 'Create'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TaskwarriorColorTheme c,
    TextEditingController controller,
    String? label,
    String hint, {
    bool enabled = true,
    ValueChanged<String>? onChanged,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(
          controller: controller,
          enabled: enabled,
          onChanged: onChanged,
          style: GoogleFonts.poppins(color: c.primaryTextColor),
          decoration: InputDecoration(
            isDense: true,
            labelText: label,
            hintText: hint,
            border: const OutlineInputBorder(),
            labelStyle: GoogleFonts.poppins(color: c.secondaryTextColor),
            hintStyle: GoogleFonts.poppins(color: c.primaryDisabledTextColor),
          ),
        ),
      );

  Widget _chip(TaskwarriorColorTheme c, String label, VoidCallback onTap) =>
      ActionChip(
        label: Text(label,
            style: GoogleFonts.poppins(
                fontSize: 11, color: c.primaryTextColor)),
        backgroundColor: c.secondaryBackgroundColor,
        onPressed: onTap,
        visualDensity: VisualDensity.compact,
      );

  Widget _matchLine(TaskwarriorColorTheme c) {
    if (_counting) {
      return Text('Checking…',
          style: GoogleFonts.poppins(
              fontSize: 12, color: c.secondaryTextColor));
    }
    if (_matchCount == null) {
      return const SizedBox.shrink();
    }
    return Text(
      _matchCount == 1 ? 'Matches 1 task' : 'Matches $_matchCount tasks',
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: c.primaryTextColor,
      ),
    );
  }

  Widget _hint(TaskwarriorColorTheme c, String text, {bool warn = false}) =>
      Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: warn ? Colors.orange.shade700 : c.secondaryTextColor,
          ),
        ),
      );
}
