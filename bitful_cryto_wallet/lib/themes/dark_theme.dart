import 'package:bitful_cryto_wallet/themes/colors.dart';
import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: MyColors.DarkGunmetal,
  backgroundColor: MyColors.DarkGunmetal,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: MyColors.DarkGunmetal,
    unselectedItemColor: MyColors.Platinum,
    selectedItemColor: MyColors.CelestialBlue,
    elevation: 0,
  ),
  highlightColor: MyColors.PurpleNavy,
  appBarTheme: AppBarTheme(
    color: MyColors.DarkGunmetal,
    elevation: 0,
    toolbarTextStyle: TextTheme(
      headline6: TextStyle(
        color: MyColors.Platinum,
        fontSize: 20,
      ),
    ).bodyText2,
    titleTextStyle: TextTheme(
      headline6: TextStyle(
        color: MyColors.Platinum,
        fontSize: 20,
      ),
    ).headline6,
  ),
);
