import 'package:flutter/material.dart';

class MyTheme {
  static const Color primary = Color.fromARGB(255, 151, 121, 191);
  static const String fontFamily = 'Roboto';

  // Tema claro
  static final ThemeData light = ThemeData(
    primaryColor: primary,
    brightness: Brightness.light,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: Colors.white,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      elevation: 20,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: Colors.grey,
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),

    floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: primary),
  );

  // Tema oscuro
  static final ThemeData dark = ThemeData(
    primaryColor: primary,
    brightness: Brightness.dark,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: const Color.fromARGB(255, 38, 38, 38),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 38, 38, 38),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      elevation: 20,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 38, 38, 38),
      selectedItemColor: primary,
      unselectedItemColor: Colors.grey,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),
    floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: primary),
  );
}