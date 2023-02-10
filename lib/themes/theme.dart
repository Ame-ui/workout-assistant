import 'package:flutter/material.dart';

class MyTheme {
  static const Color primaryColor = Color(0xff314b55);
  static ThemeData normalTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: primaryColor,
    ),
    // iconTheme: const IconThemeData(color: Colors.white),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primaryColor),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(foregroundColor: MaterialStateProperty.all(primaryColor))),
  );
}
