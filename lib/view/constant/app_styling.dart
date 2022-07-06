import 'package:flutter/material.dart';
import 'package:parkbenching/view/constant/color.dart';

class AppStyling {
  static final styling = ThemeData(
    scaffoldBackgroundColor: kPrimaryColor,
    fontFamily: 'Montserrat',
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: kPrimaryColor,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: kTertiaryColor.withOpacity(0.1),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: kTertiaryColor,
    ),
  );
}
