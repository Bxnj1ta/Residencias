import 'package:flutter/material.dart';
import 'package:residencias/themes/my_themes.dart';

class MyDrawerTheme {
  MyDrawerTheme._();

  static DrawerThemeData light = DrawerThemeData(
    backgroundColor: MyTheme.light2,
    elevation: 8,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
    ),
  );

  static DrawerThemeData dark = DrawerThemeData(
    backgroundColor: MyTheme.dark2,
    elevation: 8,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
    ),
  );
}
