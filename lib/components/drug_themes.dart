import 'package:drug_alarm/components/drug_colors.dart';
import 'package:flutter/material.dart';

class DrugThemes {
  static ThemeData get lightTheme => ThemeData(
        fontFamily: 'CookieRunFont_OTF',
        primarySwatch: DrugColors.primaryMeterialColor,
        scaffoldBackgroundColor: Colors.white,
        splashColor: Colors.white,
        brightness: Brightness.light,
        textTheme: _textTheme,
        appBarTheme: _appBarTheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );

  static ThemeData get darkTheme => ThemeData(
        fontFamily: 'CookieRunFont_OTF',
        primarySwatch: DrugColors.primaryMeterialColor,
        splashColor: Colors.white,
        brightness: Brightness.dark,
        textTheme: _textTheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );

  static const AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: DrugColors.primaryColor),
    elevation: 0,
  );

  static const TextTheme _textTheme = TextTheme(
    headline4: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
    ),
    subtitle1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    subtitle2: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyText1: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w300,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
    ),
    button: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w300,
    ),
  );
}
