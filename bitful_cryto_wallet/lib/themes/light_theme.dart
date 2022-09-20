import 'package:bitful_cryto_wallet/themes/colors.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  textTheme: TextTheme(
    headline1: TextStyle(color: MyColors.DarkGunmetal),
    headline2: TextStyle(color: MyColors.DarkGunmetal),
    bodyText2: TextStyle(color: MyColors.DarkGunmetal),
    subtitle1: TextStyle(color: MyColors.DarkGunmetal),
    bodyText1: TextStyle(color: MyColors.DarkGunmetal),
  ),
  colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: MyColors.DarkGunmetal,
      onPrimary: MyColors.DarkGunmetal,
      secondary: MyColors.DarkGunmetal,
      onSecondary: MyColors.DarkGunmetal,
      error: Colors.red,
      onError: Colors.red,
      background: MyColors.Platinum,
      onBackground: MyColors.Platinum,
      surface: MyColors.Platinum,
      onSurface: MyColors.Platinum),
  brightness: Brightness.light,
  bottomAppBarColor: MyColors.Platinum,
  scaffoldBackgroundColor: MyColors.Platinum,
  backgroundColor: MyColors.Platinum,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: MyColors.Platinum,
    unselectedItemColor: MyColors.DarkGunmetal,
    selectedItemColor: Colors.redAccent,
    elevation: 0,
  ),
  highlightColor: MyColors.DarkGunmetal,
  appBarTheme: AppBarTheme(
      color: MyColors.Platinum,
      elevation: 0,
      toolbarTextStyle: TextTheme(
        headline6: TextStyle(
          color: MyColors.DarkGunmetal,
          fontSize: 20,
        ),
      ).bodyText2,
      titleTextStyle: TextTheme(
        headline6: TextStyle(
          color: MyColors.DarkGunmetal,
          fontSize: 20,
        ),
      ).headline6),
);
