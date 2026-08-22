import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/add_task_dialogue/tags_input.dart';

class TagEditor extends StatelessWidget {
  final List<String> suggestions;
  final List<String> initialTags;
  final void Function(List<String>) onSave;

  const TagEditor({
    super.key,
    required this.suggestions,
    required this.initialTags,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final RxList<String> tags = RxList<String>(initialTags);
    // The raw field text, mirrored on every keystroke. A tag typed but not
    // submitted is invisible in `tags`, and Save used to drop it silently.
    String pendingText = '';
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .cancel,
                  ),
                ),
                Text(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.edit}:${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.tags}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Saving is as clear a submission as pressing enter, so a
                    // tag still sitting in the field is adopted, not dropped.
                    final List<String> result = List<String>.from(tags);
                    final String pending = pendingText.trim();
                    if (pending.isNotEmpty && !result.contains(pending)) {
                      result.add(pending);
                    }
                    onSave(result);
                    Get.back();
                  },
                  child: Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .save,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: AddTaskTagsInput(
              initialTags: initialTags,
              suggestions: suggestions,
              onTagsChanges: (newTags) => tags.value = newTags,
              onTextChanged: (text) => pendingText = text,
            ),
          ),
          const Padding(padding: EdgeInsets.all(20)),
        ],
      ),
    );
  }
}
