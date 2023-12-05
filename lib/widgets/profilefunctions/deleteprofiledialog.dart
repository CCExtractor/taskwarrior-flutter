import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/utility/utilities.dart';
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
            try {
              ProfilesWidget.of(context).deleteProfile(profile);
              Navigator.of(context).pop();
              Utils.showSnakbar(
                  'Profile: ${profile.characters} Deleted Successfully',
                  context);
            } catch (e) {
              Utils.showSnakbar(
                  'Profile: ${profile.characters} Deletion Failed', context);
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
