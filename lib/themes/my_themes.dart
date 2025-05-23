import 'package:flutter/material.dart';
import 'package:residencias/themes/themes.dart';

class MyTheme {
  MyTheme._();
    static const MaterialColor primary = Colors.grey;
    static final Color light1 = primary.shade50;
    static final Color light2 = primary.shade200;
    static final Color light3 = primary.shade400;
    static final Color dark1 = primary.shade900;
    static final Color dark2 = primary.shade800;
    static final Color dark3 = primary.shade600;

  static ThemeData light = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: light1,
    primaryColorLight: light1,
    primaryColorDark: dark1,
    scaffoldBackgroundColor: Colors.white,
    textTheme: MyTextTheme.light,
    appBarTheme: MyAppBarTheme.light,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.white),
    cardTheme: CardTheme(color: light2,),
    inputDecorationTheme: MyInputTheme.light,
    textSelectionTheme: TextSelectionThemeData(cursorColor: dark1),
    iconTheme: IconThemeData(color: Colors.black),
    buttonTheme: MyButtonTheme.light,
    elevatedButtonTheme: MyElevatedButtonTheme.light,
    splashColor: light1,
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: light2, foregroundColor: dark3),
  );
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: dark1,
    primaryColorLight: light1,
    primaryColorDark: dark1,
    scaffoldBackgroundColor: Colors.black,
    textTheme: MyTextTheme.dark,
    appBarTheme: MyAppBarTheme.dark,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.black),
    cardTheme: CardTheme(color: dark2,),
    inputDecorationTheme: MyInputTheme.dark,
    textSelectionTheme: TextSelectionThemeData(cursorColor: light1),
    iconTheme: IconThemeData(color: Colors.white),
    buttonTheme: MyButtonTheme.dark,
    elevatedButtonTheme: MyElevatedButtonTheme.dark,
    splashColor: dark1,
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: dark2, foregroundColor: light3),  
  );
}