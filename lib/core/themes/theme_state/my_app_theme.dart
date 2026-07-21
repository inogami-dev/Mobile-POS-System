import 'package:flutter/material.dart';

class MyAppTheme {
  MyAppTheme._();
  // static const Color _appBrandColor = Color.fromARGB(255, 1, 60, 138);

  static const Color _appBrandColor = Colors.blue;
  static const Color _lightBackground = Color(0xFFF6F6F6);
  static const Color _darkBackground = Color(0xFF121212);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: _appBrandColor,
            brightness: Brightness.light,
            primary: _appBrandColor,
            surface: _lightBackground,
          ).copyWith(
            onPrimary: const Color.fromARGB(255, 231, 231, 231),
            primaryFixed: Colors.blue.shade300,
          ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: _appBrandColor,
            brightness: Brightness.dark,
            primary: _appBrandColor,
            surface: _darkBackground,
          ).copyWith(
            onPrimary: const Color.fromARGB(255, 231, 231, 231),
            primaryFixed: Colors.blue.shade300,
          ),
    );
  }
}
