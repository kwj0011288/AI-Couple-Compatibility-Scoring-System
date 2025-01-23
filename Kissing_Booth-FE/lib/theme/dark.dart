import 'package:flutter/material.dart';

ThemeData dartTheme = ThemeData(
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  hoverColor: Colors.transparent,
  brightness: Brightness.dark,
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.black,
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: const Color.fromARGB(255, 91, 91, 91),
    outline: Colors.white,
    onPrimaryContainer: Colors.white,
    onBackground: Colors.grey[900],
    secondary: Colors.grey[900] ?? Colors.black,
    shadow: Colors.transparent,
    secondaryFixed: const Color.fromARGB(255, 91, 91, 91),
  ),
);


//Color.fromARGB(255, 44, 44, 47),

