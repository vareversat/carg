import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData.light(useMaterial3: true).copyWith(
    primaryColor: const Color(0xFF38761D),
    cardTheme: const CardTheme(
      surfaceTintColor: Colors.white,
    ),
    dialogTheme: const DialogTheme(surfaceTintColor: Colors.white),
    colorScheme: const ColorScheme.light().copyWith(
      primary: const Color(0xFF38761D),
      secondary: const Color(0xFFFFA785),
    ),
    textTheme: GoogleFonts.josefinSansTextTheme(
      ThemeData.light().textTheme,
    ),
  );
}
