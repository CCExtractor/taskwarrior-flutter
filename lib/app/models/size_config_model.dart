import 'package:flutter/material.dart';

class SizeConfig {
   MediaQueryData? _mediaQueryData;
   double? screenW;
   double? screenH;
   double? blockH;
   double? blockV;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenW = _mediaQueryData!.size.width;
    screenH = _mediaQueryData!.size.height;
    blockH = screenW! / 100;
    blockV = screenH! / 100;
  }
}
