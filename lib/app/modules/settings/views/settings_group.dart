import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

import 'settings_page_list_tile.dart';

// --- Item config types ---

sealed class SettingsItemConfig {
  const SettingsItemConfig();
}

class SettingsToggleItem extends SettingsItemConfig {
  final String title;
  final String subtitle;
  final RxBool value;
  final String? prefsKey;
  final ValueChanged<bool>? onChanged;

  const SettingsToggleItem({
    required this.title,
    required this.subtitle,
    required this.value,
    this.prefsKey,
    this.onChanged,
  });

  Future<void> toggle(bool v) async {
    value.value = v;
    if (prefsKey != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(prefsKey!, v);
    }
    onChanged?.call(v);
  }
}

class SettingsDropdownItem<T> extends SettingsItemConfig {
  final String title;
  final String subtitle;
  final Rx<T> value;
  final List<T> options;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onChanged;

  const SettingsDropdownItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.options,
    required this.labelBuilder,
    required this.onChanged,
  });

  Widget buildTrailing(TaskwarriorColorTheme tColors) {
    return DropdownButton<T>(
      value: value.value,
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      items: options.map((option) {
        return DropdownMenuItem<T>(
          value: option,
          child: Text(
            labelBuilder(option),
            style: TextStyle(
              fontFamily: FontFamily.poppins,
              color: tColors.primaryTextColor,
            ),
          ),
        );
      }).toList(),
      dropdownColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.kLightPrimaryBackgroundColor,
    );
  }
}

class SettingsCustomItem extends SettingsItemConfig {
  final Widget child;

  const SettingsCustomItem({required this.child});
}

// --- SettingsGroup widget ---

class SettingsGroup extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<SettingsItemConfig> items;

  const SettingsGroup({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: tColors.primaryTextColor?.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: tColors.primaryTextColor?.withOpacity(0.7),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        // Settings card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: tColors.primaryBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: tColors.primaryDisabledTextColor?.withOpacity(0.1) ??
                  Colors.grey.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: _buildItems(tColors),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  List<Widget> _buildItems(TaskwarriorColorTheme tColors) {
    final widgets = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        widgets.add(Divider(
          height: 1,
          color: tColors.primaryDisabledTextColor?.withOpacity(0.1),
        ));
      }
      widgets.add(_buildItem(items[i], tColors));
    }
    return widgets;
  }

  Widget _buildItem(SettingsItemConfig item, TaskwarriorColorTheme tColors) {
    return switch (item) {
      SettingsToggleItem() => Obx(
          () => SettingsPageListTile(
            title: item.title,
            subTitle: item.subtitle,
            trailing: Switch(
              value: item.value.value,
              onChanged: item.toggle,
            ),
          ),
        ),
      SettingsDropdownItem() => Obx(
          () => SettingsPageListTile(
            title: item.title,
            subTitle: item.subtitle,
            trailing: item.buildTrailing(tColors),
          ),
        ),
      SettingsCustomItem() => item.child,
    };
  }
}
