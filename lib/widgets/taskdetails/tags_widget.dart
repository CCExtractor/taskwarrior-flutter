// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:built_collection/built_collection.dart';
import 'package:loggy/loggy.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';

import 'package:taskwarrior/widgets/taskw.dart';

class TagsWidget extends StatelessWidget {
  const TagsWidget({
    required this.name,
    required this.value,
    required this.callback,
    Key? key,
  }) : super(key: key);

  final String name;
  final dynamic value;
  final void Function(dynamic) callback;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(
                '${'$name:'.padRight(13)}${(value as ListBuilder?)?.build()}',
              ),
            ],
          ),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TagsRoute(
              value: value,
              callback: callback,
            ),
          ),
        ),
      ),
    );
  }
}

class TagsRoute extends StatefulWidget {
  const TagsRoute({required this.value, required this.callback, Key? key})
      : super(key: key);

  final ListBuilder<String>? value;
  final void Function(ListBuilder<String>?) callback;

  @override
  TagsRouteState createState() => TagsRouteState();
}

class TagsRouteState extends State<TagsRoute> {
  Map<String, TagMetadata>? _pendingTags;
  ListBuilder<String>? draftTags;

  void _addTag(String tag) {
    if (draftTags == null) {
      draftTags = ListBuilder([tag]);
    } else {
      draftTags!.add(tag);
    }
    widget.callback(draftTags);
    setState(() {});
  }

  void _removeTag(String tag) {
    draftTags!.remove(tag);
    widget.callback((draftTags!.isEmpty) ? null : draftTags);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    draftTags = widget.value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initialize();
  }

  Future<void> _initialize() async {
    _pendingTags = StorageWidget.of(context).pendingTags;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('tags'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (draftTags != null)
                  for (var tag in draftTags!.build())
                    FilterChip(
                      onSelected: (_) => _removeTag(tag),
                      label: Text(
                        '+$tag ${_pendingTags?[tag]?.frequency ?? 0}',
                      ),
                    ),
                const Divider(),
                if (_pendingTags != null)
                  for (var tag in _pendingTags!.entries.where((tag) =>
                      !(draftTags?.build().contains(tag.key) ?? false)))
                    FilterChip(
                      onSelected: (_) => _addTag(tag.key),
                      label: Text(
                        '${tag.key} ${tag.value.frequency}',
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var controller = TextEditingController();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              scrollable: true,
              title: const Text('Add tag'),
              content: TextField(
                autofocus: true,
                controller: controller,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    try {
                      validateTaskTags(controller.text);
                      _addTag(controller.text);
                      Navigator.of(context).pop();
                    } on FormatException catch (e, trace) {
                      logError(e, trace);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
