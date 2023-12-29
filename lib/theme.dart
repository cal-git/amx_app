import 'package:flutter/material.dart';

MaterialColor primarySwatch = const MaterialColor(
  0xFF00224B,
  <int, Color>{
    50: Color(0xFFE6EFF4),
    100: Color(0xFFB3CCE1),
    200: Color(0xFF80A9CE),
    300: Color(0xFF4D86BB),
    400: Color(0xFF266DAE),
    500: Color(0xFF00224B), // Sua cor primária
    600: Color(0xFF001F44),
    700: Color(0xFF001A3B),
    800: Color(0xFF001633),
    900: Color(0xFF000E24),
  },
);

final theme = ThemeData(
  primarySwatch: primarySwatch,
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  primaryColor: const Color(0xFFFFFFFF),
  primaryColorLight: Colors.black,
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      color: Colors.black,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
      fontSize: 30,
    ),
    headlineMedium: TextStyle(
      color: Color(0xFF344054),
      fontFamily: 'Inter',
      fontWeight: FontWeight.bold,
      fontSize: 32,
    ),
    bodyMedium: TextStyle(
      color: Colors.black,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    bodySmall: TextStyle(
      color: Colors.black54,
      fontFamily: 'Inter',
      fontWeight: FontWeight.normal,
      fontSize: 14,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF00224b),
    centerTitle: true,
  ),
);
