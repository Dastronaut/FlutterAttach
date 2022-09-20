import 'package:flutter/material.dart';

final appTheme = ThemeData(
  primaryColor: Colors.yellow,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(backgroundColor: Colors.yellow),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: Colors.yellow,
  ),
);
