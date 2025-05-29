import 'package:flutter/material.dart';
import 'package:residencias/themes/my_themes.dart';

class MyBottomNavBarTheme {
  MyBottomNavBarTheme._();

  static BottomNavigationBarThemeData light = BottomNavigationBarThemeData(
    backgroundColor: MyTheme.light2,
    selectedItemColor: MyTheme.dark1,
    unselectedItemColor: MyTheme.dark3,
    selectedIconTheme: IconThemeData(color: MyTheme.dark1),
    unselectedIconTheme: IconThemeData(color: MyTheme.dark3),
    type: BottomNavigationBarType.fixed,
  );

  static BottomNavigationBarThemeData dark = BottomNavigationBarThemeData(
    backgroundColor: MyTheme.dark1,
    selectedItemColor: MyTheme.light1,
    unselectedItemColor: MyTheme.light3,
    selectedIconTheme: IconThemeData(color: MyTheme.light1),
    unselectedIconTheme: IconThemeData(color: MyTheme.light3),
    type: BottomNavigationBarType.fixed,
  );
}
