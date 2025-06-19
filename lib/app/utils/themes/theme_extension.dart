import 'package:flutter/material.dart';


class TaskwarriorColorTheme extends ThemeExtension<TaskwarriorColorTheme>{
	final Color? dialogBackgroundColor;
	final Color? primaryBackgroundColor;
	final Color? secondaryBackgroundColor;
	final Color? primaryTextColor;
	final Color? secondaryTextColor;
	final Color? primaryDisabledTextColor;
	final Color? dividerColor;
	final Color? purpleShade;
	final Color? greyShade;
	final Color? dimCol;
	final IconData? icons;
	
	const TaskwarriorColorTheme({
		required this.dialogBackgroundColor,
		required this.primaryBackgroundColor,
		required this.primaryDisabledTextColor,
		required this.primaryTextColor,
		required this.secondaryBackgroundColor,
		required this.secondaryTextColor,
		required this.dividerColor,
		required this.purpleShade,
		required this.greyShade,
		required this.icons,
		required this.dimCol
	});

	@override
	ThemeExtension<TaskwarriorColorTheme> copyWith({
		Color? dialogBackgroundColor,
		Color? primaryBackgroundColor,
		Color? secondaryBackgroundColor,
		Color? primaryTextColor,
		Color? secondaryTextColor,
		Color? primaryDisabledTextColor,
		Color? dividerColor,
		Color? greyShade,
		Color? dimCol,
		IconData? icons,
	}) {
		return TaskwarriorColorTheme(
			dialogBackgroundColor: dialogBackgroundColor ?? dialogBackgroundColor, 
			primaryBackgroundColor: primaryBackgroundColor ?? primaryBackgroundColor, 
			primaryDisabledTextColor: primaryDisabledTextColor ?? primaryDisabledTextColor, 
			primaryTextColor: primaryTextColor ?? primaryTextColor, 
			secondaryBackgroundColor: secondaryBackgroundColor ?? secondaryBackgroundColor, 
			secondaryTextColor: secondaryTextColor ?? secondaryTextColor,
			dividerColor: dividerColor ?? dividerColor,
			purpleShade: purpleShade ?? purpleShade,
			greyShade: greyShade ?? greyShade,
			icons: icons ?? icons,
			dimCol: dimCol ?? dimCol
		);
	}

 	@override
  	ThemeExtension<TaskwarriorColorTheme> lerp(
      covariant ThemeExtension<TaskwarriorColorTheme>? other, double t) {
		if (other is! TaskwarriorColorTheme) {
		return this;
		}
		return TaskwarriorColorTheme(
			dialogBackgroundColor: Color.lerp(
				dialogBackgroundColor, other.dialogBackgroundColor, t),
			primaryBackgroundColor: Color.lerp(
				primaryBackgroundColor, other.primaryBackgroundColor, t),
			primaryDisabledTextColor: Color.lerp(
				primaryDisabledTextColor, other.primaryDisabledTextColor, t),
			primaryTextColor:
				Color.lerp(primaryTextColor, other.primaryTextColor, t),
			secondaryBackgroundColor: Color.lerp(
				secondaryBackgroundColor, other.secondaryBackgroundColor, t),
			secondaryTextColor:
				Color.lerp(secondaryTextColor, other.secondaryTextColor, t),
			dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
			purpleShade: Color.lerp(purpleShade, other.purpleShade, t),
			greyShade: Color.lerp(greyShade, other.greyShade, t),
			dimCol: Color.lerp(dimCol, other.dimCol, t),
			icons: icons
		);
  }
}