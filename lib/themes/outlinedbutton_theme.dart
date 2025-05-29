import 'package:flutter/material.dart';
import 'package:residencias/themes/my_themes.dart';

class MyOutlinedButtonTheme {
  MyOutlinedButtonTheme._();

  static OutlinedButtonThemeData light = OutlinedButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(MyTheme.dark1),
        backgroundColor: WidgetStatePropertyAll(MyTheme.light1),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (states) => states.contains(WidgetState.disabled)
            ? MyTheme.dark3 // Color texto deshabilitado
            : MyTheme.dark1,
      ),
        side: WidgetStateProperty.resolveWith<BorderSide>(
        (states) => states.contains(WidgetState.disabled)
            ? BorderSide(color: MyTheme.dark3) // Borde deshabilitado
            : BorderSide(color: MyTheme.dark1),
      ),
        overlayColor: WidgetStatePropertyAll(MyTheme.light3),
      ),
    );

  static OutlinedButtonThemeData dark = OutlinedButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStatePropertyAll(MyTheme.light1),
      backgroundColor: WidgetStatePropertyAll(MyTheme.dark1),
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (states) => states.contains(WidgetState.disabled)
            ? MyTheme.light3
            : MyTheme.light1,
      ),
      side: WidgetStateProperty.resolveWith<BorderSide>(
        (states) => states.contains(WidgetState.disabled)
            ? BorderSide(color: MyTheme.light3)
            : BorderSide(color: MyTheme.light1),
      ),
      overlayColor: WidgetStatePropertyAll(MyTheme.light3),
    ),
  );
}