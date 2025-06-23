import 'package:flutter/material.dart';

enum ThemeValue { light, dark, system }

enum ContrastValue { none, high }

extension ContrastStatusExtension on ContrastValue? {
  IconData get icon {
    switch (this) {
      case ContrastValue.none:
        return Icons.do_not_disturb_alt_outlined;
      case ContrastValue.high:
        return Icons.contrast;
      default:
        return Icons.error;
    }
  }
}

extension ThemeStatusExtension on ThemeValue? {
  IconData get icon {
    switch (this) {
      case ThemeValue.light:
        return Icons.light_mode;
      case ThemeValue.dark:
        return Icons.dark_mode;
      case ThemeValue.system:
        return Icons.brightness_auto_rounded;
      default:
        return Icons.error;
    }
  }

  String text(BuildContext context) {
    switch (this) {
      case ThemeValue.light:
        return "AppLocalizations.of(context)!.lightTheme";
      case ThemeValue.dark:
        return "AppLocalizations.of(context)!.darkTheme";
      case ThemeValue.system:
        return "AppLocalizations.of(context)!.systemTheme";
      default:
        return 'no_value';
    }
  }
}
