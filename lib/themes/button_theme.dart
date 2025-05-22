import 'package:flutter/material.dart';
import 'package:residencias/themes/my_themes.dart';

class MyButtonTheme {
  MyButtonTheme._();

  static ButtonThemeData light = ButtonThemeData(
    splashColor: MyTheme.light1
  );
  static ButtonThemeData dark = ButtonThemeData(
    splashColor: MyTheme.dark1
  );
}