import 'package:flutter/material.dart';

class CustomTextStyle {
  static TextStyle roundHeadLine(BuildContext context) {
    return TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle dialogHeaderStyle(BuildContext context) {
    return TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onPrimary,
    );
  }

  static TextStyle screenHeadLine1(BuildContext context) {
    return TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onPrimary,
    );
  }

  static TextStyle screenHeadLine2(BuildContext context) {
    return TextStyle(
      fontSize: 28,
      color: Theme.of(context).colorScheme.onPrimary,
    );
  }

  static TextStyle boldAndItalic(BuildContext context) {
    return TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold);
  }
}
