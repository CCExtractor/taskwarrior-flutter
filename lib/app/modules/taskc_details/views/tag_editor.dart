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
                  SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .addTaskAddTags,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onSave(tags);
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
            ),
          ),
          const Padding(padding: EdgeInsets.all(20)),
        ],
      ),
    );
  }
}
