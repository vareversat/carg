import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const int _mcgpalette0PrimaryValue = 0xFF38761D;
MaterialColor mcgpalette0 =
    const MaterialColor(_mcgpalette0PrimaryValue, <int, Color>{
  50: Color(0xFFE7EFE4),
  100: Color(0xFFC3D6BB),
  200: Color(0xFF9CBB8E),
  300: Color(0xFF749F61),
  400: Color(0xFF568B3F),
  500: Color(_mcgpalette0PrimaryValue),
  600: Color(0xFF326E1A),
  700: Color(0xFF2B6315),
  800: Color(0xFF245911),
  900: Color(0xFF17460A),
});

const int _mcgpalette0AccentValue = 0xFFFFA785;
const MaterialColor mcgpalette0Accent =
    MaterialColor(_mcgpalette0AccentValue, <int, Color>{
  100: Color(0xFFFFCCB8),
  200: Color(_mcgpalette0AccentValue),
  400: Color(0xFFFF8252),
  700: Color(0xFFFF7039),
});

class AppTheme {
  static final ThemeData theme = ThemeData.light(useMaterial3: true).copyWith(
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Colors.white,
    ),
    colorScheme: const ColorScheme.light().copyWith(
      primary: const Color(0xFF326E1A),
      secondary: const Color(0xFFFF7039),
    ),
    textTheme: GoogleFonts.josefinSansTextTheme(
      ThemeData.light().textTheme.copyWith(),
    ),
  );
}
