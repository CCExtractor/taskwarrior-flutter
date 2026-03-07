// ignore_for_file: depend_on_referenced_packages

import 'package:built_collection/built_collection.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/models/tag_meta_data.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';

class TagsController extends GetxController {
  final draftTags = Rxn<ListBuilder<String>>();
  late void Function(ListBuilder<String>?) callback;

  void init({
    ListBuilder<String>? value,
    required void Function(ListBuilder<String>?) callbackFn,
  }) {
    draftTags.value = value;
    callback = callbackFn;
  }

  Map<String, TagMetadata> get pendingTags =>
      Get.find<HomeController>().pendingTags;

  List<String> parseTags(String input) {
    return input
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  void addTags(List<String> tags) {
    if (tags.isEmpty) return;

    draftTags.value ??= ListBuilder<String>();

    for (final tag in tags) {
      if (!(draftTags.value!.build().contains(tag))) {
        draftTags.value!.add(tag);
      }
    }
    draftTags.refresh();
    callback(draftTags.value);
  }

  void removeTag(String tag) {
    if (draftTags.value!.length == 1) {
      draftTags.value!.remove(tag);
      draftTags.value = null;
    } else {
      draftTags.value!.remove(tag);
      draftTags.refresh();
    }
    callback(draftTags.value ?? ListBuilder([]));
  }
}
