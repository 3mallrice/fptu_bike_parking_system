import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const/frondend/color_const.dart';

ThemeData lightMode = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,

  appBarTheme: AppBarTheme(
    // color: Colors.white,
    titleTextStyle: TextStyle(
      color: ColorLightMode.primaryText,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    ),
    centerTitle: true,
    backgroundColor: ColorLightMode.background,
    elevation: 4,
    surfaceTintColor: ColorLightMode.background,
  ),

  bottomAppBarTheme: const BottomAppBarTheme(
    color: ColorLightMode.background,
    elevation: 4,
    surfaceTintColor: ColorLightMode.background,
    //auto fit with child
    height: 70,
  ),

  colorScheme: ColorScheme.light(
    background: ColorLightMode.background,
    primary: ColorLightMode.primaryOrange,
    secondary: ColorLightMode.secondaryOrange,
    inversePrimary: ColorLightMode.background,
    outlineVariant: ColorLightMode.dividerColor,
    outline: ColorLightMode.primaryText,
    onSecondary: ColorLightMode.secondaryText,
  ),
  dividerColor: ColorLightMode.primaryText,
  useMaterial3: true,
  //Display: H1
  //headline: H2
  //title: H3
  //body: normal
  //label: list

  textTheme: TextTheme(
    //display
    displayLarge: TextStyle(
      color: ColorLightMode.background,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    ),

    displayMedium: TextStyle(
      color: ColorLightMode.primaryText,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    ),

    //headline: chữ cho appbar
    headlineMedium: TextStyle(
      color: ColorLightMode.primaryOrange,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    ),

    //title
    titleMedium: TextStyle(
      color: ColorLightMode.primaryText,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      fontFamily: GoogleFonts.roboto().fontFamily,
    ),

    //body
    bodyLarge: TextStyle(
      color: ColorLightMode.secondaryText,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    ),

    bodyMedium: TextStyle(
      color: ColorLightMode.primaryText,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    ),

    bodySmall: TextStyle(
      color: ColorLightMode.primaryText,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    ),

    //label
    labelMedium: TextStyle(
      color: ColorLightMode.secondaryText,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    ),

    labelSmall: TextStyle(
      color: ColorLightMode.primaryText,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.roboto().fontFamily,
    ),
  ),
);
