import 'package:flutter/material.dart';
import 'package:residencias/themes/my_themes.dart';

class MyElevatedButtonTheme {
  MyElevatedButtonTheme._();

  static ElevatedButtonThemeData light = ElevatedButtonThemeData(
    style: ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.white24),
      backgroundColor: WidgetStateProperty.all(MyTheme.light3),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      ))
    )
  );
  static ElevatedButtonThemeData dark = ElevatedButtonThemeData(
    style: ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.black38),
      backgroundColor: WidgetStateProperty.all(MyTheme.dark3),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      ))
    )
  );
}