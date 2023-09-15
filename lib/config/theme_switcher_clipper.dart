// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ThemeSwitcherClipper extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onTap;

  const ThemeSwitcherClipper({
    Key? key,
    required this.isDarkMode,
    required this.onTap,
    required Icon child,
  }) : super(key: key);

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
                  key: ValueKey<bool>(widget.isDarkMode),
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
