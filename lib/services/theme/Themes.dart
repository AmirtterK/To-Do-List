import 'package:to_do_list/models/classes/themeClass.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // light theme
  static ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      backgroundColor: const Color.fromARGB(255, 149, 112, 189),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
    ),
    colorScheme: ColorScheme.light(
      primary: const Color.fromARGB(255, 149, 112, 189),
      primaryContainer: const Color.fromARGB(255, 149, 112, 189),
      tertiaryContainer: const Color.fromARGB(255, 149, 112, 189),
      surface: const Color.fromARGB(255, 255, 255, 255),
      secondary: const Color.fromRGBO(238, 238, 238, 1),
      secondaryFixed: const Color.fromARGB(255, 149, 112, 189),
      onSecondary: const Color.fromARGB(255, 97, 97, 97),
      tertiary: const Color.fromARGB(255, 158, 158, 158),
    ),
  );
  // pink theme
  static ThemeData pink = ThemeData(
    brightness: Brightness.light,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      backgroundColor: const Color.fromARGB(255, 255, 108, 228),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 255, 108, 228),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
    ),
    colorScheme: ColorScheme.light(
      primary: const Color.fromARGB(255, 255, 108, 228),
      primaryContainer: const Color.fromARGB(255, 255, 108, 228),
      tertiaryContainer: const Color.fromARGB(255, 255, 108, 228),
      surface: const Color.fromARGB(255, 255, 255, 255),
      secondary: const Color.fromARGB(255, 238, 238, 238),
      secondaryFixed: const Color.fromARGB(255, 255, 108, 228),
      onSecondary: const Color.fromARGB(255, 97, 97, 97),
      tertiary: const Color.fromARGB(255, 158, 158, 158),
    ),
  );
  // rosy theme
  static ThemeData rosy = ThemeData(
    brightness: Brightness.dark,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
      backgroundColor: const Color.fromARGB(255, 255, 108, 228),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 255, 108, 228),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    ),
    colorScheme: ColorScheme.dark(
      primary: const Color.fromARGB(255, 255, 108, 228),
      primaryContainer: const Color.fromARGB(255, 255, 108, 228),
      tertiaryContainer: const Color.fromARGB(255, 255, 108, 228),
      secondary: const Color.fromRGBO(33, 33, 33, 1),
      onSecondary: const Color.fromRGBO(189, 189, 189, 1),
      tertiary: const Color.fromRGBO(158, 158, 158, 1),
      secondaryFixed: const Color.fromARGB(255, 255, 108, 228),
      surface: const Color.fromARGB(255, 0, 0, 0),
    ),
  );
  // cyan theme
  static ThemeData cyan = ThemeData(
    brightness: Brightness.light,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
      backgroundColor: const Color.fromARGB(255, 6, 229, 206),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 6, 229, 206),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: const Color.fromARGB(255, 6, 229, 206),
      primaryContainer: const Color.fromARGB(255, 6, 229, 206),
      tertiaryContainer: const Color.fromARGB(255, 6, 229, 206),
      surface: const Color.fromARGB(255, 255, 255, 255),
      secondary: const Color.fromARGB(255, 238, 238, 238),
      secondaryFixed: Color.fromARGB(255, 6, 229, 206),
      onSecondary: const Color.fromARGB(255, 97, 97, 97),
      tertiary: const Color.fromARGB(255, 158, 158, 158),
    ),
  );
  // dark theme
  static ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 149, 112, 189),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 149, 112, 189),
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: const Color.fromARGB(255, 149, 112, 189),
      primaryContainer: const Color.fromARGB(255, 149, 112, 189),
      tertiaryContainer: const Color.fromARGB(255, 149, 112, 189),
      secondary: const Color.fromARGB(255, 33, 33, 33),
      onSecondary: const Color.fromARGB(255, 189, 189, 189),
      secondaryFixed: const Color.fromARGB(255, 149, 112, 189),
      tertiary: const Color.fromARGB(255, 158, 158, 158),
      surface: const Color.fromARGB(255, 23, 23, 23),
    ),
  );
  // halloween theme
  static ThemeData halloween = ThemeData(
    brightness: Brightness.dark,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      backgroundColor: const Color.fromARGB(255, 230, 109, 44),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 230, 109, 44),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    ),
    colorScheme: ColorScheme.dark(
      primary: const Color.fromARGB(255, 230, 109, 44),
      primaryContainer: const Color.fromARGB(255, 230, 109, 44),
      tertiaryContainer: const Color.fromARGB(255, 230, 109, 44),
      secondary: const Color.fromRGBO(33, 33, 33, 1),
      onSecondary: const Color.fromARGB(255, 189, 189, 189),
      tertiary: const Color.fromARGB(255, 158, 158, 158),
      secondaryFixed: Color.fromARGB(255, 230, 109, 44),
      surface: const Color.fromARGB(255, 23, 23, 23),
    ),
  );
  // RossoCorsa theme
  static ThemeData rossoCorsa = ThemeData(
    brightness: Brightness.dark,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
      backgroundColor: const Color.fromARGB(255, 255, 40, 0),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 255, 40, 0),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    ),
    colorScheme: ColorScheme.dark(
      primary: const Color.fromARGB(255, 255, 40, 0),
      primaryContainer: const Color.fromARGB(255, 255, 40, 0),
      tertiaryContainer: const Color.fromARGB(255, 255, 40, 0),
      secondary: const Color.fromRGBO(33, 33, 33, 1),
      onSecondary: const Color.fromRGBO(189, 189, 189, 1),
      tertiary: const Color.fromRGBO(158, 158, 158, 1),
      secondaryFixed: const Color.fromARGB(255, 255, 40, 0),
      surface: const Color.fromARGB(255, 23, 23, 23),
    ),
  );
  // one theme
  static ThemeData one = ThemeData(
    brightness: Brightness.dark,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
      backgroundColor: const Color.fromARGB(255, 0, 210, 190),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 0, 210, 190),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    ),
    colorScheme: ColorScheme.dark(
      primary: const Color.fromARGB(255, 0, 210, 190),
      primaryContainer: const Color.fromARGB(255, 0, 210, 190),
      tertiaryContainer: const Color.fromARGB(255, 0, 210, 190),
      secondary: const Color.fromRGBO(33, 33, 33, 1),
      onSecondary: const Color.fromRGBO(189, 189, 189, 1),
      tertiary: const Color.fromRGBO(158, 158, 158, 1),
      secondaryFixed: const Color.fromARGB(255, 0, 210, 190),
      surface: const Color.fromARGB(255, 0, 0, 0),
    ),
  );
  // blueberry theme
  static ThemeData blueberry = ThemeData(
    brightness: Brightness.light,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
      backgroundColor: const Color.fromARGB(255, 49, 110, 237),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 49, 110, 237),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: const Color.fromARGB(255, 49, 110, 237),
      primaryContainer: const Color.fromARGB(255, 49, 110, 237),
      tertiaryContainer: const Color.fromARGB(255, 49, 110, 237),
      surface: const Color.fromARGB(255, 255, 255, 255),
      secondary: const Color.fromARGB(255, 238, 238, 238),
      secondaryFixed: Color.fromARGB(255, 49, 110, 237),
      onSecondary: const Color.fromARGB(255, 97, 97, 97),
      tertiary: const Color.fromARGB(255, 158, 158, 158),
    ),
  );
  // clover theme
  static ThemeData clover = ThemeData(
    brightness: Brightness.light,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
      backgroundColor: const Color.fromARGB(255, 61, 155, 17),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 61, 155, 17),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: const Color.fromARGB(255, 61, 155, 17),
      primaryContainer: const Color.fromARGB(255, 61, 155, 17),
      tertiaryContainer: const Color.fromARGB(255, 461, 155, 17),
      surface: const Color.fromARGB(255, 255, 255, 255),
      secondary: const Color.fromARGB(255, 238, 238, 238),
      secondaryFixed: Color.fromARGB(255, 61, 155, 17),
      onSecondary: const Color.fromARGB(255, 97, 97, 97),
      tertiary: const Color.fromARGB(255, 158, 158, 158),
    ),
  );
}

List<themeDetails> availableThemes = [
  themeDetails(
    themeData: AppTheme.lightMode,
    themename: "Light",
    background: const Color.fromARGB(255, 255, 255, 255),
    ButtonBack: const Color.fromARGB(255, 149, 112, 189),
    ButtonFor: const Color.fromARGB(255, 255, 255, 255),
    selected: false,
  ),
  themeDetails(
    themeData: AppTheme.darkMode,
    themename: "Dark",
    background: const Color.fromARGB(255, 23, 23, 23),
    ButtonBack: const Color.fromARGB(255, 149, 112, 189),
    ButtonFor: const Color.fromRGBO(255, 255, 255, 1),
    selected: false,
  ),
  themeDetails(
    themeData: AppTheme.pink,
    themename: "Pink",
    background: const Color.fromARGB(255, 255, 255, 255),
    ButtonBack: const Color.fromARGB(255, 255, 108, 228),
    ButtonFor: const Color.fromARGB(255, 255, 255, 255),
    selected: false,
  ),
 themeDetails(
    themeData: AppTheme.rosy,
    themename: "Rosy",
    background: const Color.fromARGB(255, 0, 0, 0),
    ButtonBack: const Color.fromARGB(255, 255, 108, 228),
    ButtonFor: const Color.fromARGB(255, 255, 255, 255),
    selected: false,
  ),
  themeDetails(
    themeData: AppTheme.cyan,
    themename: "Cyan",
    background: const Color.fromARGB(255, 255, 255, 255),
    ButtonBack: const Color.fromARGB(255, 6, 229, 206),
    ButtonFor: const Color.fromARGB(255, 255, 255, 255),
    selected: false,
  ),
  themeDetails(
    themeData: AppTheme.blueberry,
    themename: "Blueberry",
    background: const Color.fromARGB(255, 255, 255, 255),
    ButtonBack: const Color.fromARGB(255, 49, 110, 237),
    ButtonFor: const Color.fromARGB(255, 255, 255, 255),
    selected: false,
  ),
  themeDetails(
    themeData: AppTheme.clover,
    themename: "Clover",
    background: const Color.fromARGB(255, 255, 255, 255),
    ButtonBack: const Color.fromARGB(255, 61, 155, 17),
    ButtonFor: const Color.fromARGB(255, 255, 255, 255),
    selected: false,
  ),
  themeDetails(
    themeData: AppTheme.halloween,
    themename: "Halloween",
    background: const Color.fromARGB(255, 23, 23, 23),
    ButtonBack: const Color.fromARGB(255, 230, 109, 44),
    ButtonFor: const Color.fromRGBO(255, 255, 255, 1),
    selected: false,
  ),
  themeDetails(
    themeData: AppTheme.rossoCorsa,
    themename: "Rosso Corsa",
    background: const Color.fromARGB(255, 23, 23, 23),
    ButtonBack: const Color.fromARGB(255, 255, 40, 0),
    ButtonFor: const Color.fromRGBO(255, 255, 255, 1),
    selected: false,
  ),
  themeDetails(
    themeData: AppTheme.one,
    themename: "One",
    background: const Color.fromARGB(255, 0, 0, 0),
    ButtonBack: const Color.fromARGB(255, 0, 210, 190),
    ButtonFor: const Color.fromARGB(255, 255, 255, 255),
    selected: false,
  ),
];
