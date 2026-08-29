import 'package:carg/services/storage_service.dart';
import 'package:carg/styles/app_color_scheme.dart';
import 'package:carg/styles/theme/enums.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeService with ChangeNotifier {
  final StorageService storageService;

  late CargMaterialTheme _cargMaterialTheme;
  ThemeData? _currentThemeData;
  late ThemeValue _currentThemeValue;
  late ContrastValue _currentContrastValue;
  late bool _useDynamicColors;

  ThemeService(BuildContext context, this.storageService) {
    TextTheme textTheme = createTextTheme(context);

    _currentThemeValue = storageService.readTheme() ?? ThemeValue.system;
    _currentContrastValue = storageService.readContrast() ?? ContrastValue.none;
    _useDynamicColors = storageService.readDynamicColors() ?? false;
    _cargMaterialTheme = CargMaterialTheme(textTheme);

    // If dynamic colors are enabled, load them immediately
    if (_useDynamicColors) {
      _loadDynamicColors();
    }

    getCurrentThemeData();
  }

  CargMaterialTheme get cargMaterialTheme => _cargMaterialTheme;

  ThemeData get currentThemeData =>
      _currentThemeData ?? (_currentThemeData = _getFallbackTheme());

  ThemeValue get currentThemeValue => _currentThemeValue;

  ContrastValue get currentContrastValue => _currentContrastValue;

  set currentContrastValue(ContrastValue value) {
    _currentContrastValue = value;
    storageService.saveContrast(value);
    notifyListeners();
  }

  set currentThemeValue(ThemeValue value) {
    _currentThemeValue = value;
    storageService.saveTheme(value);

    // If dynamic colors are enabled, reload them with the new theme brightness
    if (_useDynamicColors) {
      _loadDynamicColors();
    } else {
      // Update to use the new static theme
      _currentThemeData = null;
      notifyListeners();
    }
  }

  set currentThemeData(ThemeData value) {
    _currentThemeData = value;
    notifyListeners();
  }

  bool get useDynamicColors => _useDynamicColors;

  set useDynamicColors(bool value) {
    _useDynamicColors = value;
    storageService.saveDynamicColors(value);

    // If enabling dynamic colors, load them asynchronously
    if (value) {
      _loadDynamicColors();
    } else {
      // If disabling, reset to static theme
      _currentThemeData = null;
      notifyListeners();
    }
  }

  Future<void> _loadDynamicColors() async {
    try {
      final dynamicColors = await DynamicColorPlugin.getCorePalette();
      if (dynamicColors != null) {
        _currentThemeData = _buildThemeFromCorePalette(dynamicColors);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Dynamic color generation failed: $e');
      _currentThemeData = null;
      notifyListeners();
    }
  }

  bool showContrastPicker() {
    return _currentThemeValue != ThemeValue.system;
  }

  ThemeData _getFallbackTheme() {
    if (_currentThemeValue == ThemeValue.light) {
      if (_currentContrastValue == ContrastValue.none) {
        return _cargMaterialTheme.light();
      } else {
        return _cargMaterialTheme.lightHighContrast();
      }
    } else if (_currentThemeValue == ThemeValue.dark) {
      if (_currentContrastValue == ContrastValue.none) {
        return _cargMaterialTheme.dark();
      } else {
        return _cargMaterialTheme.darkHighContrast();
      }
    } else if (_currentThemeValue == ThemeValue.system) {
      return _getCorrectThemeForSystem();
    } else {
      return _cargMaterialTheme.light();
    }
  }

  ThemeData getCurrentThemeData() {
    // If dynamic colors are enabled and we have a cached dynamic theme, use it
    if (_useDynamicColors && _currentThemeData != null) {
      return _currentThemeData!;
    }

    // Fall back to static theme
    return _getFallbackTheme();
  }

  /// Build theme from real device core palette
  ThemeData _buildThemeFromCorePalette(dynamic corePalette) {
    // Determine the brightness based on user preference
    final brightness = _getBrightnessForDynamicTheme();
    final isDark = brightness == Brightness.dark;

    // Create base color scheme from seed
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Color(corePalette.primary.get(50)),
      brightness: brightness,
      primary: Color(corePalette.primary.get(50)),
      secondary: Color(corePalette.secondary.get(50)),
      tertiary: Color(corePalette.tertiary.get(50)),
      error: Color(corePalette.error.get(50)),
      outline: Color(corePalette.neutral.get(50)),
      surface: isDark
          ? Color(corePalette.neutral.get(10))
          : Color(corePalette.neutral.get(98)),
      onSurface: isDark
          ? Color(corePalette.neutral.get(90))
          : Color(corePalette.neutral.get(10)),
    );

    debugPrint(
      'Generated ColorScheme from real device: ${colorScheme.toString()}',
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      textTheme: _cargMaterialTheme.textTheme.copyWith(
        bodyLarge: _cargMaterialTheme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        bodyMedium: _cargMaterialTheme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        bodySmall: _cargMaterialTheme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface,
        ),
        titleLarge: _cargMaterialTheme.textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        titleMedium: _cargMaterialTheme.textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        titleSmall: _cargMaterialTheme.textTheme.titleSmall?.copyWith(
          color: colorScheme.onSurface,
        ),
        headlineLarge: _cargMaterialTheme.textTheme.headlineLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        headlineMedium: _cargMaterialTheme.textTheme.headlineMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        headlineSmall: _cargMaterialTheme.textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
        ),
        labelLarge: _cargMaterialTheme.textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        labelMedium: _cargMaterialTheme.textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        labelSmall: _cargMaterialTheme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(color: colorScheme.onSurface),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerHighest,
        margin: EdgeInsets.zero,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        titleTextStyle: TextStyle(color: colorScheme.onSurface),
        contentTextStyle: TextStyle(color: colorScheme.onSurface),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withValues(alpha: .6),
      ),
    );
  }

  /// Determine the appropriate brightness for dynamic themes
  Brightness _getBrightnessForDynamicTheme() {
    // If contrast is enabled, use high contrast version of the selected theme
    if (_currentContrastValue != ContrastValue.none) {
      return _currentThemeValue == ThemeValue.dark
          ? Brightness.dark
          : Brightness.light;
    }

    // Respect user's theme preference
    switch (_currentThemeValue) {
      case ThemeValue.light:
        return Brightness.light;
      case ThemeValue.dark:
        return Brightness.dark;
      case ThemeValue.system:
        return SchedulerBinding.instance.platformDispatcher.platformBrightness;
    }
  }

  ThemeData _getCorrectThemeForSystem() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return isDarkMode ? _cargMaterialTheme.dark() : _cargMaterialTheme.light();
  }
}
