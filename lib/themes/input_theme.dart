import 'package:flutter/material.dart';
import 'package:residencias/themes/my_themes.dart';

class MyInputTheme {
  MyInputTheme._();

  static InputDecorationTheme light = InputDecorationTheme(
    hintStyle: TextStyle(color: MyTheme.dark1),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: MyTheme.light1,
        width: 1,
      )
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: MyTheme.dark2,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: Colors.red,
        width: 1.5,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: Colors.redAccent,
        width: 2,
      ),
    ),
    filled: true,
    fillColor: MyTheme.light2,
    focusColor: MyTheme.light1
  );
  static InputDecorationTheme dark = InputDecorationTheme(
    hintStyle: TextStyle(color: MyTheme.light1),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: MyTheme.dark1,
        width: 1,
      )
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: MyTheme.light2,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: Colors.red,
        width: 1.5,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: Colors.redAccent,
        width: 2,
      ),
    ),
    filled: true,
    fillColor: MyTheme.dark2,
    focusColor: MyTheme.dark1
  );
}