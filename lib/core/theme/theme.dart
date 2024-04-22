import 'package:flutter/material.dart';
import '../const/frondend/color_const.dart';

ThemeData lightMode = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
      background: ColorLightMode.background,
      primary: ColorLightMode.primaryOrange,
      secondary: ColorLightMode.secondaryOrange),
  dividerColor: ColorLightMode.primaryText,
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
