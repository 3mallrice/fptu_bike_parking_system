import 'package:flutter/material.dart';
import '../const/frondend/color_const.dart';

ThemeData lightMode = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: ColorLightMode.background,
    primary: ColorLightMode.primaryOrange,
    secondary: ColorLightMode.secondaryOrange,
  ),
  dividerColor: ColorLightMode.primaryText,
  textTheme: const TextTheme(
    labelMedium: TextStyle(
      color: ColorLightMode.primaryText,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: 'SFProText',
    ),
  ),
);

ThemeData darkMode = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: ColorDarkMode.background,
    primary: ColorDarkMode.primaryGray,
    secondary: ColorDarkMode.secondaryGray,
  ),
  dividerColor: ColorDarkMode.text,
);
