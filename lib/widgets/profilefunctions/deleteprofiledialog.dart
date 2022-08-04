import 'package:flutter/material.dart';
import 'package:taskwarrior/widgets/taskdetails/profiles_widget.dart';

class DeleteProfileDialog extends StatelessWidget {
  const DeleteProfileDialog({
    required this.profile,
    required this.context,
    Key? key,
  }) : super(key: key);

  final String profile;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: const Text('Delete profile?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            ProfilesWidget.of(context).deleteProfile(profile);
            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
