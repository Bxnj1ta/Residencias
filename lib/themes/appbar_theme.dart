import 'package:flutter/material.dart';

class MyAppBarTheme {
  MyAppBarTheme._();

  static AppBarTheme light = AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  );
  static AppBarTheme dark = AppBarTheme(
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(
      color: Colors.white
    ),
  );
}