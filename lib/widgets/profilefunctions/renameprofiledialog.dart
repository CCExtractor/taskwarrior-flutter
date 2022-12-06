import 'package:flutter/material.dart';
import 'package:taskwarrior/widgets/taskdetails.dart';

class RenameProfileDialog extends StatelessWidget {
  const RenameProfileDialog({
    required this.profile,
    required this.alias,
    required this.context,
    Key? key,
  }) : super(key: key);

  final String profile;
  final String? alias;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController(text: alias);

    return AlertDialog(
      scrollable: true,
      title: const Text('Rename Profile'),
      content: TextField(controller: controller),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            ProfilesWidget.of(context).renameProfile(
              profile: profile,
              alias: controller.text,
            );
            Navigator.of(context).pop();
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
