import 'package:flutter/material.dart';

/// Text-only action button shared by the detail page dialogs.
class DetailRouteDialogAction extends StatelessWidget {
  final String label;
  final Color? color;
  final VoidCallback onPressed;

  const DetailRouteDialogAction({
    required this.label,
    required this.color,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: color),
      ),
    );
  }
}
