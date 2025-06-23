import 'package:carg/services/storage_service.dart';
import 'package:carg/styles/app_color_scheme.dart';
import 'package:carg/styles/theme/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeService with ChangeNotifier {
  final StorageService storageService;

  late CargMaterialTheme _cargMaterialTheme;
  late ThemeData _currentThemeData;
  late ThemeValue _currentThemeValue;
  late ContrastValue _currentContrastValue;

  ThemeService(BuildContext context, this.storageService) {
    TextTheme textTheme = createTextTheme(context);

    _currentThemeValue = storageService.readTheme() ?? ThemeValue.system;
    _currentContrastValue = storageService.readContrast() ?? ContrastValue.none;
    _cargMaterialTheme = CargMaterialTheme(textTheme);
    getCurrentThemeData();
  }

  CargMaterialTheme get cargMaterialTheme => _cargMaterialTheme;

  ThemeData get currentThemeData => _currentThemeData;

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
    notifyListeners();
  }

  set currentThemeData(ThemeData value) {
    _currentThemeData = value;
    notifyListeners();
  }

  bool showContrastPicker() {
    return _currentThemeValue != ThemeValue.system;
  }

  ThemeData getCurrentThemeData() {
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

  ThemeData _getCorrectThemeForSystem() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return isDarkMode ? _cargMaterialTheme.dark() : _cargMaterialTheme.light();
  }
}
