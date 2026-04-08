import 'package:flutter/material.dart';

class CustomTextStyle {
  static TextStyle roundHeadLine(BuildContext context) {
    return TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle? dialogHeaderStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: 30,
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle? screenHeadLine1(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge?.copyWith(
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle? screenHeadLine2(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium?.copyWith(
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle boldAndItalic(BuildContext context) {
    return TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold);
  }
}
