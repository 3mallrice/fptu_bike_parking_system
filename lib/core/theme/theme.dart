import 'package:flutter/material.dart';

import '../const/frondend/color_const.dart';

ThemeData lightMode = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,

  appBarTheme: const AppBarTheme(
    // color: Colors.white,
    backgroundColor: ColorLightMode.background,
    elevation: 4,
    iconTheme: IconThemeData(
      color: ColorLightMode.primaryText,
    ),
    surfaceTintColor: ColorLightMode.background,
  ),

  bottomAppBarTheme: const BottomAppBarTheme(
    color: ColorLightMode.background,
    elevation: 4,
    surfaceTintColor: ColorLightMode.background,
    //auto fit with child
    height: 70,
  ),

  colorScheme: const ColorScheme.light(
    background: ColorLightMode.background,
    primary: ColorLightMode.primaryOrange,
    secondary: ColorLightMode.secondaryOrange,
    outline: ColorLightMode.primaryText,
  ),
  dividerColor: ColorLightMode.primaryText,
  useMaterial3: true,
  //Display: H1
  //headline: H2
  //title: H3
  //body: normal
  //label: list

  textTheme: const TextTheme(
    //display
    displayMedium: TextStyle(
      color: ColorLightMode.primaryText,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      fontFamily: 'SFProDisplay',
    ),

    //headline: chữ cho appbar
    headlineMedium: TextStyle(
      color: ColorLightMode.primaryOrange,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      fontFamily: 'SFProDisplay',
    ),

    //title
    titleMedium: TextStyle(
      color: ColorLightMode.primaryText,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      fontFamily: 'SFProDisplay',
    ),

    //body
    bodyMedium: TextStyle(
      color: ColorLightMode.primaryText,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'SFProText',
    ),

    //label
    labelMedium: TextStyle(
      color: ColorLightMode.secondaryText,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: 'SFProText',
    ),

    labelSmall: TextStyle(
      color: ColorLightMode.primaryText,
      fontSize: 12,
      fontWeight: FontWeight.w400,
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
    outline: ColorDarkMode.text,
  ),
  dividerColor: ColorDarkMode.text,
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    // surfaceTintColor: ,
    elevation: 5,
    iconTheme: IconThemeData(
      color: ColorDarkMode.text,
    ),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: ColorDarkMode.background,
    elevation: 4,
    height: 70,
  ),
  textTheme: const TextTheme(
    //display
    displayMedium: TextStyle(
      color: ColorDarkMode.text,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      fontFamily: 'SFProDisplay',
    ),

    //headline
    headlineMedium: TextStyle(
      color: ColorDarkMode.text,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      fontFamily: 'SFProDisplay',
    ),

    //title
    titleMedium: TextStyle(
      color: ColorDarkMode.text,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      fontFamily: 'SFProDisplay',
    ),

    //body
    bodyMedium: TextStyle(
      color: ColorDarkMode.text,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: 'SFProText',
    ),

    //label
    labelMedium: TextStyle(
      color: ColorDarkMode.text,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: 'SFProText',
    ),

    labelSmall: TextStyle(
      color: ColorDarkMode.text,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: 'SFProText',
    ),
  ),
);
