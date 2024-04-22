import 'package:flutter/material.dart';
import 'color_const.dart';

class TextLightStyles {
  TextLightStyles(this.context);

  BuildContext? context;

  static const TextStyle defaultStyle = TextStyle(
    fontSize: 15.0,
    color: ColorLightMode.text,
    fontWeight: FontWeight.w400,
    fontFamily: 'Sanfrancisco',
  );
}

class TextDarkStyles {
  TextDarkStyles(this.context);

  BuildContext? context;

  static const TextStyle defaultStyle = TextStyle(
    fontSize: 15.0,
    color: ColorDarkMode.text,
    fontWeight: FontWeight.w400,
    fontFamily: 'Sanfrancisco',
  );
}
