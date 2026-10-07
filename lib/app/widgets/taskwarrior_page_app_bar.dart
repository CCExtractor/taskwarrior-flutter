import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';

/// The single app bar used by every page in the app.
///
/// This encodes the style that was previously copy-pasted (and had drifted)
/// across `AboutPageAppBar`, `SettingsPageAppBar`, `ReportsPageAppBar`,
/// `ProfileView` and the detail/tags/credential pages: the primary background,
/// a left-aligned Poppins title with an optional subtitle, and a 35px white
/// chevron. Building it in one place means those details can no longer drift.
class TaskWarriorPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const TaskWarriorPageAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onLeadingPressed,
    this.leading,
    this.actions,
    this.titleSpacing,
  });

  /// The main title line. Build it with [titleText] (or wrap that in an `Obx`
  /// when the text is reactive) so every page uses the same typography.
  final Widget title;

  /// Optional second line shown under [title]. Build it with [subtitleText].
  final Widget? subtitle;

  /// Called when the default leading chevron is tapped. Defaults to popping the
  /// current route. Ignored when [leading] is supplied.
  final VoidCallback? onLeadingPressed;

  /// Overrides the default leading chevron entirely (rare).
  final Widget? leading;

  /// Trailing widgets, e.g. search/refresh icons.
  final List<Widget>? actions;

  /// Horizontal spacing before the title. Defaults to the platform default,
  /// matching the settings page.
  final double? titleSpacing;

  /// Canonical title typography: Poppins, white, [TaskWarriorFonts.fontSizeLarge].
  static TextStyle get titleStyle => GoogleFonts.poppins(
        color: TaskWarriorColors.white,
        fontSize: TaskWarriorFonts.fontSizeLarge,
      );

  /// Canonical subtitle typography: Poppins, white, [TaskWarriorFonts.fontSizeSmall].
  static TextStyle get subtitleStyle => GoogleFonts.poppins(
        color: TaskWarriorColors.white,
        fontSize: TaskWarriorFonts.fontSizeSmall,
      );

  /// A [Text] using [titleStyle].
  static Widget titleText(String text) => Text(text, style: titleStyle);

  /// A [Text] using [subtitleStyle].
  static Widget subtitleText(String text) =>
      Text(text, style: subtitleStyle);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
      surfaceTintColor: TaskWarriorColors.kprimaryBackgroundColor,
      titleSpacing: titleSpacing,
      title: subtitle == null
          ? title
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [title, subtitle!],
            ),
      leading: leading ??
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onLeadingPressed ?? () => Navigator.of(context).maybePop(),
            child: Icon(
              Icons.chevron_left,
              color: TaskWarriorColors.white,
              size: 35,
            ),
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
