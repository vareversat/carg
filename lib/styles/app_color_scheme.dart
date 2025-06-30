import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class CargMaterialTheme {
  final TextTheme textTheme;

  const CargMaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff236a4c),
      surfaceTint: Color(0xff236a4c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffaaf2cb),
      onPrimaryContainer: Color(0xff005236),
      secondary: Color(0xff4d6356),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd0e8d8),
      onSecondaryContainer: Color(0xff364b3f),
      tertiary: Color(0xff3d6472),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffc0e9fa),
      onTertiaryContainer: Color(0xff234c5a),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff5fbf4),
      onSurface: Color(0xff171d19),
      onSurfaceVariant: Color(0xff404943),
      outline: Color(0xff707973),
      outlineVariant: Color(0xffc0c9c1),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322e),
      inversePrimary: Color(0xff8fd5b0),
      primaryFixed: Color(0xffaaf2cb),
      onPrimaryFixed: Color(0xff002113),
      primaryFixedDim: Color(0xff8fd5b0),
      onPrimaryFixedVariant: Color(0xff005236),
      secondaryFixed: Color(0xffd0e8d8),
      onSecondaryFixed: Color(0xff0a1f15),
      secondaryFixedDim: Color(0xffb4ccbc),
      onSecondaryFixedVariant: Color(0xff364b3f),
      tertiaryFixed: Color(0xffc0e9fa),
      onTertiaryFixed: Color(0xff001f28),
      tertiaryFixedDim: Color(0xffa4cdde),
      onTertiaryFixedVariant: Color(0xff234c5a),
      surfaceDim: Color(0xffd6dbd5),
      surfaceBright: Color(0xfff5fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5ef),
      surfaceContainer: Color(0xffeaefe9),
      surfaceContainerHigh: Color(0xffe4eae3),
      surfaceContainerHighest: Color(0xffdee4de),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003f28),
      surfaceTint: Color(0xff236a4c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff347a5a),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff263b2f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5c7265),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff0f3b49),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4c7282),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fbf4),
      onSurface: Color(0xff0d120f),
      onSurfaceVariant: Color(0xff303833),
      outline: Color(0xff4c554e),
      outlineVariant: Color(0xff666f69),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322e),
      inversePrimary: Color(0xff8fd5b0),
      primaryFixed: Color(0xff347a5a),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff166043),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff5c7265),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff445a4d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4c7282),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff335a68),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc2c8c2),
      surfaceBright: Color(0xfff5fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5ef),
      surfaceContainer: Color(0xffe4eae3),
      surfaceContainerHigh: Color(0xffd9ded8),
      surfaceContainerHighest: Color(0xffcdd3cd),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003420),
      surfaceTint: Color(0xff236a4c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff005438),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff1b3025),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff384e42),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00313e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff264e5c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fbf4),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff262e29),
      outlineVariant: Color(0xff424b45),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322e),
      inversePrimary: Color(0xff8fd5b0),
      primaryFixed: Color(0xff005438),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003b26),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff384e42),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff22372c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff264e5c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff093745),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb4bab4),
      surfaceBright: Color(0xfff5fbf4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffedf2ec),
      surfaceContainer: Color(0xffdee4de),
      surfaceContainerHigh: Color(0xffd0d6d0),
      surfaceContainerHighest: Color(0xffc2c8c2),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff8fd5b0),
      surfaceTint: Color(0xff8fd5b0),
      onPrimary: Color(0xff003824),
      primaryContainer: Color(0xff005236),
      onPrimaryContainer: Color(0xffaaf2cb),
      secondary: Color(0xffb4ccbc),
      onSecondary: Color(0xff20352a),
      secondaryContainer: Color(0xff364b3f),
      onSecondaryContainer: Color(0xffd0e8d8),
      tertiary: Color(0xffa4cdde),
      onTertiary: Color(0xff063543),
      tertiaryContainer: Color(0xff234c5a),
      onTertiaryContainer: Color(0xffc0e9fa),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0f1511),
      onSurface: Color(0xffdee4de),
      onSurfaceVariant: Color(0xffc0c9c1),
      outline: Color(0xff8a938c),
      outlineVariant: Color(0xff404943),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee4de),
      inversePrimary: Color(0xff236a4c),
      primaryFixed: Color(0xffaaf2cb),
      onPrimaryFixed: Color(0xff002113),
      primaryFixedDim: Color(0xff8fd5b0),
      onPrimaryFixedVariant: Color(0xff005236),
      secondaryFixed: Color(0xffd0e8d8),
      onSecondaryFixed: Color(0xff0a1f15),
      secondaryFixedDim: Color(0xffb4ccbc),
      onSecondaryFixedVariant: Color(0xff364b3f),
      tertiaryFixed: Color(0xffc0e9fa),
      onTertiaryFixed: Color(0xff001f28),
      tertiaryFixedDim: Color(0xffa4cdde),
      onTertiaryFixedVariant: Color(0xff234c5a),
      surfaceDim: Color(0xff0f1511),
      surfaceBright: Color(0xff353b36),
      surfaceContainerLowest: Color(0xff0a0f0c),
      surfaceContainerLow: Color(0xff171d19),
      surfaceContainer: Color(0xff1b211d),
      surfaceContainerHigh: Color(0xff262b27),
      surfaceContainerHighest: Color(0xff303632),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa4ecc5),
      surfaceTint: Color(0xff8fd5b0),
      onPrimary: Color(0xff002c1b),
      primaryContainer: Color(0xff599e7c),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffcae2d2),
      onSecondary: Color(0xff152a1f),
      secondaryContainer: Color(0xff7f9688),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffbae3f4),
      onTertiary: Color(0xff002a36),
      tertiaryContainer: Color(0xff6f96a6),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0f1511),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd5dfd7),
      outline: Color(0xffabb4ad),
      outlineVariant: Color(0xff89938b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee4de),
      inversePrimary: Color(0xff005337),
      primaryFixed: Color(0xffaaf2cb),
      onPrimaryFixed: Color(0xff00150b),
      primaryFixedDim: Color(0xff8fd5b0),
      onPrimaryFixedVariant: Color(0xff003f28),
      secondaryFixed: Color(0xffd0e8d8),
      onSecondaryFixed: Color(0xff02150b),
      secondaryFixedDim: Color(0xffb4ccbc),
      onSecondaryFixedVariant: Color(0xff263b2f),
      tertiaryFixed: Color(0xffc0e9fa),
      onTertiaryFixed: Color(0xff00141b),
      tertiaryFixedDim: Color(0xffa4cdde),
      onTertiaryFixedVariant: Color(0xff0f3b49),
      surfaceDim: Color(0xff0f1511),
      surfaceBright: Color(0xff404642),
      surfaceContainerLowest: Color(0xff040806),
      surfaceContainerLow: Color(0xff191f1b),
      surfaceContainer: Color(0xff232925),
      surfaceContainerHigh: Color(0xff2e3430),
      surfaceContainerHighest: Color(0xff393f3b),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbaffd9),
      surfaceTint: Color(0xff8fd5b0),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff8bd1ac),
      onPrimaryContainer: Color(0xff000e07),
      secondary: Color(0xffddf6e5),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb0c8b9),
      onSecondaryContainer: Color(0xff000e07),
      tertiary: Color(0xffdcf4ff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffa1c9da),
      onTertiaryContainer: Color(0xff000d13),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0f1511),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe9f2ea),
      outlineVariant: Color(0xffbcc5bd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee4de),
      inversePrimary: Color(0xff005337),
      primaryFixed: Color(0xffaaf2cb),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff8fd5b0),
      onPrimaryFixedVariant: Color(0xff00150b),
      secondaryFixed: Color(0xffd0e8d8),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb4ccbc),
      onSecondaryFixedVariant: Color(0xff02150b),
      tertiaryFixed: Color(0xffc0e9fa),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa4cdde),
      onTertiaryFixedVariant: Color(0xff00141b),
      surfaceDim: Color(0xff0f1511),
      surfaceBright: Color(0xff4c514d),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1b211d),
      surfaceContainer: Color(0xff2c322e),
      surfaceContainerHigh: Color(0xff373d39),
      surfaceContainerHighest: Color(0xff424844),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

TextTheme createTextTheme(BuildContext context) {
  TextTheme bodyTextTheme = GoogleFonts.josefinSansTextTheme();
  TextTheme displayTextTheme = GoogleFonts.josefinSansTextTheme();
  TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
  return textTheme;
}
