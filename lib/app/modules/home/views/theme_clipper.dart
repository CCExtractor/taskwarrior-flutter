import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';

class ThemeSwitcherClipper extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onTap;

  const ThemeSwitcherClipper({
    super.key,
    required this.isDarkMode,
    required this.onTap,
    required Icon child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        onTap(!isDarkMode);
      },
      child: ClipOval(
        child: Hero(
          tag: 'theme_switcher',
          child: SizedBox(
            width: 60,
            height: 60,
            child: Center(
                child: AnimatedSwitcher(
              duration: const Duration(seconds: 2),
              child: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                key: UniqueKey(),
                color: isDarkMode
                    ? TaskWarriorColors.white
                    : TaskWarriorColors.black,
                size: 40,
              ),
            )),
          ),
        ),
      ),
    );
  }
}
