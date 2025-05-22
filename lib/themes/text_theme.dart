import 'package:flutter/material.dart';

class MyTextTheme {
  MyTextTheme._();

  static TextTheme light = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
    headlineMedium: const TextStyle().copyWith(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
    labelMedium: const TextStyle().copyWith(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black),
    labelSmall: const TextStyle().copyWith(fontSize: 14, color: Colors.black),

  );
  static TextTheme dark = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: const TextStyle().copyWith(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
    labelMedium: const TextStyle().copyWith(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.white),
    labelSmall: const TextStyle().copyWith(fontSize: 14, color: Colors.white),
  );
}