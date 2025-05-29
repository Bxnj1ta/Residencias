import 'package:flutter/material.dart';
import 'package:residencias/themes/my_themes.dart';

class MyElevatedButtonTheme {
  MyElevatedButtonTheme._();

  static ElevatedButtonThemeData light = ElevatedButtonThemeData(
    style: ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.white24),
      backgroundColor: WidgetStateProperty.all(MyTheme.light2),
      foregroundColor: WidgetStateProperty.all(MyTheme.dark1),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      ))
    )
  );
  static ElevatedButtonThemeData dark = ElevatedButtonThemeData(
    style: ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.black38),
      backgroundColor: WidgetStateProperty.all(MyTheme.dark2),
      foregroundColor: WidgetStateProperty.all(MyTheme.light1),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      ))
    )
  );
}