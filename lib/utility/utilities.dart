import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';

class Utils {
  static String getWeekNumber(DateTime? date) {
    int weekNumber =
        ((date!.difference(DateTime(date.year, 1, 1)).inDays) / 7).ceil();
    return weekNumber.toString();
  }

  static int getWeekNumbertoInt(DateTime? date) {
    int weekNumber =
        ((date!.difference(DateTime(date.year, 1, 1)).inDays) / 7).ceil();
    return weekNumber;
  }

  static String formatDate(DateTime date, String pattern) {
    final formatter = DateFormat(pattern);
    return formatter.format(date);
  }

  static String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  static AlertDialog showAlertDialog({
    Key? key,
    Widget? icon,
    EdgeInsetsGeometry? iconPadding,
    Color? iconColor,
    Widget? title,
    EdgeInsetsGeometry? titlePadding,
    TextStyle? titleTextStyle,
    Widget? content,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? contentTextStyle,
    List<Widget>? actions,
    EdgeInsetsGeometry? actionsPadding,
    MainAxisAlignment? actionsAlignment,
    OverflowBarAlignment? actionsOverflowAlignment,
    VerticalDirection? actionsOverflowDirection,
    double? actionsOverflowButtonSpacing,
    EdgeInsetsGeometry? buttonPadding,
    Color? backgroundColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    String? semanticLabel,
    Clip clipBehavior = Clip.none,
    ShapeBorder? shape,
    AlignmentGeometry? alignment,
    bool scrollable = false,
  }) {
    return AlertDialog(
      surfaceTintColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kdialogBackGroundColor
          : TaskWarriorColors.kLightDialogBackGroundColor,
      shadowColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kdialogBackGroundColor
          : TaskWarriorColors.kLightDialogBackGroundColor,
      backgroundColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kdialogBackGroundColor
          : TaskWarriorColors.kLightDialogBackGroundColor,
      key: key,
      title: title,
      titlePadding: titlePadding,
      titleTextStyle: titleTextStyle,
      content: content,
      contentPadding: contentPadding,
      contentTextStyle: contentTextStyle,
      actions: actions,
      actionsPadding: actionsPadding,
      actionsAlignment: actionsAlignment,
      actionsOverflowAlignment: actionsOverflowAlignment,
      actionsOverflowDirection: actionsOverflowDirection,
      actionsOverflowButtonSpacing: actionsOverflowButtonSpacing,
      buttonPadding: buttonPadding,
      elevation: elevation,
      semanticLabel: semanticLabel,
      clipBehavior: clipBehavior,
      shape: shape,
      alignment: alignment,
      scrollable: scrollable,
    );
  }
}
