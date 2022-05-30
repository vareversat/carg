import 'package:carg/styles/text_style.dart';
import 'package:flutter/material.dart';

class InfoSnackBar {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const ValueKey('infoSnackBar'),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        content:
            Text(message, style: CustomTextStyle.snackBarTextStyle(context)),
      ),
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      showErrorSnackBar(BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const ValueKey('errorSnackBar'),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).cardColor,
        content: Text(message,
            style: CustomTextStyle.snackBarTextStyle(context)
                .copyWith(color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
