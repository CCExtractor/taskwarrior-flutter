import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class TutorialModal extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;

  const TutorialModal({
    super.key,
    required this.onYes,
    required this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final sentences =
        SentenceManager(currentLanguage: AppSettings.selectedLanguage)
            .sentences;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      backgroundColor: tColors.dialogBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: tColors.primaryBackgroundColor?.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school_outlined,
                size: 48,
                color: tColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              sentences.tutorialModalWelcome,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: tColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              sentences.tutorialModalMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: tColors.primaryTextColor?.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),

            // Buttons - Vertical Layout
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Primary Action: Keep Tutorials (with outline and filled background)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onYes,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: tColors.primaryBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: tColors.primaryBackgroundColor ?? Colors.blue,
                          width: 2,
                        ),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      sentences.tutorialModalKeepTutorials,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: tColors.primaryTextColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Secondary Action: Skip all Tutorials (text button, no outline, smaller font)
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: onNo,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      sentences.tutorialModalSkipAllTutorials,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: tColors.primaryTextColor?.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
