import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddTaskTagsInput extends StatefulWidget {
  final Iterable<String> suggestions;
  final Function(List<String>)? onTagsChanges;
  const AddTaskTagsInput(
      {super.key,
      this.suggestions = const Iterable.empty(),
      this.onTagsChanges});

  @override
  _AddTaskTagsInputState createState() => _AddTaskTagsInputState();
}

class _AddTaskTagsInputState extends State<AddTaskTagsInput> {
  late final StringTagController stringTagController;

  @override
  void initState() {
    super.initState();
    stringTagController = StringTagController();
  }

  @override
  void dispose() {
    stringTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const paddingX = 12;
    stringTagController.addListener(() {
      if (widget.onTagsChanges != null) {
        widget.onTagsChanges!(stringTagController.getTags!);
      }
    });
    return Autocomplete<String>(
      onSelected: (String value) {
        stringTagController.onTagSubmitted(value);
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
          textEditingController: textEditingController,
          focusNode: focusNode,
          textfieldTagsController: stringTagController,
          textSeparators: const [' ', ','],
          validator: (tag) {
            Iterable<String> tags = stringTagController.getTags ?? const [];
            if (tags.contains(tag)) {
              stringTagController.onTagRemoved(tag);
              stringTagController.onTagSubmitted(tag);
              return "Tag already exists";
            }
            for (String tag in tags) {
              if (tag.contains(" ")) return "Tag should not contain spaces";
            }
            return null;
          },
          inputFieldBuilder: (context, inputFieldValues) {
            return TextFormField(
              controller: inputFieldValues.textEditingController,
              focusNode: inputFieldValues.focusNode,
              decoration: InputDecoration(
                labelText: "Enter tags",
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
              onChanged: inputFieldValues.onTagChanged,
              onFieldSubmitted: inputFieldValues.onTagSubmitted,
            );
          },
        );
      },
    );
  }
}
