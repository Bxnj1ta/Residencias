import 'package:flutter/material.dart';
import 'package:residencias/themes/my_themes.dart';

class MyAppBarTheme {
  MyAppBarTheme._();

  static AppBarTheme light = AppBarTheme(
    backgroundColor: MyTheme.light2,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  );
  static AppBarTheme dark = AppBarTheme(
    backgroundColor: MyTheme.dark1,
    iconTheme: IconThemeData(
      color: Colors.white
    ),
  );
}