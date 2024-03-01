// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';

class ThemeSwitcherClipper extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onTap;

  const ThemeSwitcherClipper({
    super.key,
    required this.isDarkMode,
    required this.onTap,
    required Icon child,
  });

  @override
  _ThemeSwitcherClipperState createState() => _ThemeSwitcherClipperState();
}

class _ThemeSwitcherClipperState extends State<ThemeSwitcherClipper> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        widget.onTap(!widget.isDarkMode);
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
                widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                key: UniqueKey(),
                color: widget.isDarkMode
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
