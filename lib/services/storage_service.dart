import 'dart:developer' as developer;

import 'package:carg/const.dart';
import 'package:carg/styles/theme/enums.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences sharedPreferences;

  StorageService({required this.sharedPreferences});

  Future<bool> saveTheme(ThemeValue value) async {
    developer.log(
      '{${Const.storageThemeKey}: $value}',
      name: 'storage-service.on.saveTheme',
    );

    return await sharedPreferences.setString(Const.storageThemeKey, value.name);
  }

  Future<bool> saveContrast(ContrastValue value) async {
    developer.log(
      '{${Const.storageContrastKey}: $value}',
      name: 'storage-service.on.saveContrast',
    );

    return await sharedPreferences.setString(
      Const.storageContrastKey,
      value.name,
    );
  }

  ThemeValue? readTheme() {
    final stringValue = sharedPreferences.getString(Const.storageThemeKey);
    if (stringValue == null) {
      return null;
    } else {
      final value = EnumToString.fromString(ThemeValue.values, stringValue);
      developer.log(
        '{${Const.storageThemeKey}: $value}',
        name: 'storage-service.on.readTheme',
      );

      return value;
    }
  }

  ContrastValue? readContrast() {
    final stringValue = sharedPreferences.getString(Const.storageContrastKey);
    if (stringValue == null) {
      return null;
    } else {
      final value = EnumToString.fromString(ContrastValue.values, stringValue);
      developer.log(
        '{${Const.storageContrastKey}: $value}',
        name: 'storage-service.on.readContrast',
      );

      return value;
    }
  }
}
