import 'package:carg/styles/properties.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static void showLoadingDialog(
    BuildContext context,
    GlobalKey key,
    String message,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext context) => SimpleDialog(
            key: key,
            contentPadding: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                CustomProperties.borderRadius,
              ),
            ),
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  static void showMessageDialog(
    BuildContext context,
    GlobalKey key,
    String message,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext context) => SimpleDialog(
            key: key,
            contentPadding: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                CustomProperties.borderRadius,
              ),
            ),
            children: <Widget>[
              Center(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
