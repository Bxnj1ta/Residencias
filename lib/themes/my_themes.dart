import 'package:flutter/material.dart';
import 'package:residencias/themes/outlinedbutton_theme.dart';
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

    static final Color blue_marker = Color.fromARGB(255, 63, 167, 214);    //Pendiente
    static final Color yellow_marker = Color.fromARGB(255, 250, 192, 94);  //Proceso
    static final Color green_marker = Color.fromARGB(255, 89, 205, 144);   //Finalizado
    static final Color red_marker = Color.fromARGB(255, 238, 99, 82);     //Cancelado (No definido)

  static ThemeData light = ThemeData(
    progressIndicatorTheme: ProgressIndicatorThemeData(color: dark1),
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: light1,
    scaffoldBackgroundColor: Colors.white,
    textTheme: MyTextTheme.light,
    appBarTheme: MyAppBarTheme.light,
    bottomNavigationBarTheme: MyBottomNavBarTheme.light,
    cardTheme: CardTheme(color: light2,),
    inputDecorationTheme: MyInputTheme.light,
    textSelectionTheme: TextSelectionThemeData(cursorColor: dark1),
    iconTheme: IconThemeData(color: Colors.black),
    buttonTheme: MyButtonTheme.light,
    elevatedButtonTheme: MyElevatedButtonTheme.light,
    splashColor: light1,
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: light1, foregroundColor: dark1),
    outlinedButtonTheme: MyOutlinedButtonTheme.light,
  );
  static ThemeData dark = ThemeData(
    progressIndicatorTheme: ProgressIndicatorThemeData(color: light1),
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: dark1,
    scaffoldBackgroundColor: Colors.black,
    textTheme: MyTextTheme.dark,
    appBarTheme: MyAppBarTheme.dark,
    bottomNavigationBarTheme: MyBottomNavBarTheme.dark,
    cardTheme: CardTheme(color: dark2,),
    inputDecorationTheme: MyInputTheme.dark,
    textSelectionTheme: TextSelectionThemeData(cursorColor: light1),
    iconTheme: IconThemeData(color: Colors.white),
    buttonTheme: MyButtonTheme.dark,
    elevatedButtonTheme: MyElevatedButtonTheme.dark,
    splashColor: dark1,
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: dark2, foregroundColor: light1),
    outlinedButtonTheme: MyOutlinedButtonTheme.dark,
  );
}