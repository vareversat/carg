import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextStyle {
  static TextStyle roundHeadLine(BuildContext context) {
    return Theme.of(context).textTheme.headline2!.copyWith(
        fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold);
  }

  static TextStyle dialogHeaderStyle(BuildContext context) {
    return Theme.of(context).textTheme.headline1!.copyWith(
        fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);
  }

  static TextStyle snackBarTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white);
  }

  static TextStyle screenHeadLine1(BuildContext context) {
    return Theme.of(context).textTheme.headline1!.copyWith(
        fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold);
  }

  static TextStyle screenHeadLine2(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .headline1!
        .copyWith(fontSize: 28, color: Colors.white);
  }

  static TextStyle boldAndItalic(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold);
  }
}
