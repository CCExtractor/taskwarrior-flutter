import 'package:flutter/material.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/widgets/taskdetails/profiles_widget.dart';

class DeleteProfileDialog extends StatelessWidget {
  const DeleteProfileDialog({
    required this.profile,
    required this.context,
    super.key,
  });

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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Profile: ${profile.characters} Deleted Successfully'),
                  backgroundColor: AppSettings.isDarkMode
                      ? const Color.fromARGB(255, 61, 61, 61)
                      : const Color.fromARGB(255, 39, 39, 39),
                  duration: const Duration(seconds: 2)));
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text('Profile: ${profile.characters} Deletion Failed'),
                  backgroundColor: AppSettings.isDarkMode
                      ? const Color.fromARGB(255, 61, 61, 61)
                      : const Color.fromARGB(255, 39, 39, 39),
                  duration: const Duration(seconds: 2)));
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
