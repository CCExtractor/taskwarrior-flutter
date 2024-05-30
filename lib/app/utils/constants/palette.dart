import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xFF212121, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff1e1e1e), //10%
      100: Color(0xff1a1a1a), //20%
      200: Color(0xff171717), //30%
      300: Color(0xff141414), //40%
      400: Color(0xff111111), //50%
      500: Color(0xff0d0d0d), //60%
      600: Color(0xff0a0a0a), //70%
      700: Color(0xff070707), //80%
      800: Color(0xff030303), //90%
      900: Color(0xff000000), //100%
    },
  );
}
