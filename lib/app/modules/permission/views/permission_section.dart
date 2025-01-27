import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';

class PermissionSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isDarkMode;

  const PermissionSection({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkMode
              ? TaskWarriorColors.ksecondaryBackgroundColor
              : TaskWarriorColors.borderColor,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode
            ? TaskWarriorColors.kdialogBackGroundColor
            : TaskWarriorColors.kLightDialogBackGroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: TaskWarriorColors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? TaskWarriorColors.kprimaryTextColor
                            : TaskWarriorColors.kLightPrimaryTextColor,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode
                      ? TaskWarriorColors.ksecondaryTextColor
                      : TaskWarriorColors.kLightSecondaryTextColor,
                ),
          ),
        ],
      ),
    );
  }
}
