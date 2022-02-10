import 'package:carg/styles/text_style.dart';
import 'package:flutter/material.dart';

class InfoSnackBar {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        content:
            Text(message, style: CustomTextStyle.snackBarTextStyle(context)),
      ),
    );
  }
}
