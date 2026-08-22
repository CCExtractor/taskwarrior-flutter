import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddTaskTagsInput extends StatefulWidget {
  final Iterable<String> suggestions;
  final Iterable<String> initialTags;
  final Function(List<String>)? onTagsChanges;

  /// Fires with the raw field text on every keystroke. A tag only enters the
  /// committed list on enter, a separator, or a suggestion tap — so text still
  /// sitting in the field when the parent saves is invisible through
  /// [onTagsChanges] alone, and every caller was silently dropping it. The
  /// parent mirrors this and flushes it as a final tag at save time.
  final Function(String)? onTextChanged;

  const AddTaskTagsInput(
      {super.key,
      this.suggestions = const Iterable.empty(),
      this.initialTags = const Iterable.empty(),
      this.onTagsChanges,
      this.onTextChanged});

  @override
  _AddTaskTagsInputState createState() => _AddTaskTagsInputState();
}

class _AddTaskTagsInputState extends State<AddTaskTagsInput> {
  late final StringTagController stringTagController;

  @override
  void initState() {
    super.initState();
    stringTagController = StringTagController();
    // Registered once here — this used to happen in build(), which stacked a
    // fresh listener on every rebuild.
    stringTagController.addListener(() {
      if (widget.onTagsChanges != null) {
        widget.onTagsChanges!(stringTagController.getTags!);
      }
    });
  }

  @override
  void dispose() {
    stringTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const paddingX = 12;
    return Autocomplete<String>(
      onSelected: (String value) {
        stringTagController.onTagSubmitted(value);
        widget.onTextChanged?.call('');
      },
      optionsViewBuilder: (context, onAutoCompleteSelect, options) {
        return Align(
            alignment: Alignment.topLeft,
            child: Material(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width - paddingX * 2,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...options.map((String tag) {
                              return Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  child: InputChip(
                                      label: Text(tag),
                                      onPressed: () =>
                                          onAutoCompleteSelect(tag)));
                            })
                          ],
                        )))));
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return widget.suggestions;
        }
        return widget.suggestions.where((option) =>
            option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFieldTags<String>(
          initialTags: [...widget.initialTags],
          textEditingController: textEditingController,
          focusNode: focusNode,
          textfieldTagsController: stringTagController,
          textSeparators: const [' ', ','],
          validator: (tag) {
            Iterable<String> tags = stringTagController.getTags ?? const [];
            if (tags.contains(tag)) {
              stringTagController.onTagRemoved(tag);
              stringTagController.onTagSubmitted(tag);
              return SentenceManager(
                      currentLanguage: SentenceManager(
                              currentLanguage: AppSettings.selectedLanguage)
                          .currentLanguage)
                  .sentences
                  .tagAlreadyExists;
            }
            for (String tag in tags) {
              if (tag.contains(" ")) {
                return SentenceManager(
                        currentLanguage: SentenceManager(
                                currentLanguage: AppSettings.selectedLanguage)
                            .currentLanguage)
                    .sentences
                    .tagShouldNotContainSpaces;
              }
            }
            return null;
          },
          inputFieldBuilder: (context, inputFieldValues) {
            return TextFormField(
              controller: inputFieldValues.textEditingController,
              focusNode: inputFieldValues.focusNode,
              decoration: InputDecoration(
                labelText: SentenceManager(
                        currentLanguage: SentenceManager(
                                currentLanguage: AppSettings.selectedLanguage)
                            .currentLanguage)
                    .sentences
                    .addTaskAddTags,
                border: const OutlineInputBorder(),
                prefixIconConstraints: BoxConstraints(
                    maxWidth:
                        (MediaQuery.of(context).size.width - paddingX) * 0.7),
                prefixIcon: inputFieldValues.tags.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: SingleChildScrollView(
                          controller: inputFieldValues.tagScrollController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: inputFieldValues.tags.map((String tag) {
                            return Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: InputChip(
                                  label: Text(tag),
                                  onDeleted: () {
                                    inputFieldValues.onTagRemoved(tag);
                                  },
                                ));
                          }).toList()),
                        ))
                    : null,
              ),
              onChanged: (value) {
                inputFieldValues.onTagChanged(value);
                widget.onTextChanged?.call(value);
              },
              onFieldSubmitted: (value) {
                inputFieldValues.onTagSubmitted(value);
                widget.onTextChanged?.call('');
              },
            );
          },
        );
      },
    );
  }
}
