import 'package:flutter/material.dart';

class CustomTextStyle {
  static TextStyle roundHeadLine(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium!.copyWith(
      fontSize: 30,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'Josefin',
    );
  }

  static TextStyle dialogHeaderStyle(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge!.copyWith(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onPrimary,
      fontFamily: 'Josefin',
    );
  }

  static TextStyle snackBarTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: Theme.of(context).colorScheme.onPrimary,
      fontFamily: 'Josefin',
    );
  }

  static TextStyle screenHeadLine1(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge!.copyWith(
      fontSize: 35,
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
      fontFamily: 'Josefin',
    );
  }

  static TextStyle screenHeadLine2(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge!.copyWith(
      fontSize: 28,
      color: Theme.of(context).colorScheme.onPrimary,
      fontFamily: 'Josefin',
    );
  }

  static TextStyle boldAndItalic(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
      fontFamily: 'Josefin',
    );
  }
}
