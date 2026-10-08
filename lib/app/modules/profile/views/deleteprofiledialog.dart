import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

/// Confirmation dialog for deleting a profile.
///
/// The profile is removed from the list only *after*
/// [SplashController.deleteProfile] succeeds — this widget never mutates the
/// profile map itself, so cancelling or dismissing the dialog leaves the
/// profile (and its row) intact. While the deletion is in flight it shows a
/// spinner and hides the buttons, so the UI can never get ahead of the disk.
///
/// Pops `true` when the profile was deleted, `false` when cancelled.
class DeleteProfileDialog extends StatefulWidget {
  const DeleteProfileDialog({required this.profile, super.key});

  final String profile;

  @override
  State<DeleteProfileDialog> createState() => _DeleteProfileDialogState();
}

class _DeleteProfileDialogState extends State<DeleteProfileDialog> {
  bool _deleting = false;

  Future<void> _confirm() async {
    setState(() => _deleting = true);
    // Capture these before popping the dialog so the snackbar survives it.
    final messenger = ScaffoldMessenger.of(context);
    final tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final sentences = SentenceManager(
            currentLanguage: AppSettings.selectedLanguage)
        .sentences;

    try {
      // deleteProfile() also activates the next profile and reloads the home
      // list (SplashController.switching), so the deleted row disappears as a
      // *consequence* of the deletion succeeding — not before it.
      await Get.find<SplashController>().deleteProfile(widget.profile);
      if (!mounted) return;
      Navigator.of(context).pop(true);
      messenger.showSnackBar(SnackBar(
          content: Text(
            '${sentences.profilePageProfile}: ${widget.profile} '
            '${sentences.profileDeletedSuccessfully}',
            style: TextStyle(color: tColors.primaryTextColor),
          ),
          backgroundColor: tColors.secondaryBackgroundColor,
          duration: const Duration(seconds: 2)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _deleting = false);
      messenger.showSnackBar(SnackBar(
          content: Text(
            '${sentences.profilePageProfile}: ${widget.profile} '
            '${sentences.profileDeletionFailed}',
            style: TextStyle(color: tColors.primaryTextColor),
          ),
          backgroundColor: tColors.secondaryBackgroundColor,
          duration: const Duration(seconds: 2)));
    }
  }

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final sentences = SentenceManager(
            currentLanguage: AppSettings.selectedLanguage)
        .sentences;

    return Center(
      child: SingleChildScrollView(
        child: Center(
          child: Utils.showAlertDialog(
            scrollable: true,
            title: Text(
              sentences.profilePageDeleteProfile,
              style: TextStyle(
                color: tColors.primaryTextColor,
              ),
            ),
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: tColors.primaryTextColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    sentences.profileDeleteWarning,
                    style: TextStyle(
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
            actions: _deleting
                ? const [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ]
                : [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        sentences.cancel,
                        style: TextStyle(
                          color: tColors.primaryTextColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _confirm,
                      child: Text(
                        sentences.profileDeleteConfirmation,
                        style: TextStyle(
                          color: tColors.primaryTextColor,
                        ),
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
