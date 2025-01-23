import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  hoverColor: Colors.transparent,
  brightness: Brightness.light,
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: const Color.fromRGBO(244, 244, 248, 1.0),
  ),
  colorScheme: ColorScheme.light(
    background: const Color.fromRGBO(244, 244, 248, 1.0),
    primary: const Color.fromARGB(255, 204, 204, 204),
    outline: Colors.black,
    onPrimaryContainer: Colors.black,
    onBackground: Colors.grey[100],
    secondary: const Color.fromRGBO(244, 244, 248, 1.0),
    shadow: Colors.grey.shade300,
    secondaryFixed: Colors.grey[600],
  ),
);
