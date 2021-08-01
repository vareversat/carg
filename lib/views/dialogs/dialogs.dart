import 'package:flutter/material.dart';

class Dialogs {
  static void showLoadingDialog(
      BuildContext context, GlobalKey key, String message) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SimpleDialog(
                key: key,
                contentPadding: const EdgeInsets.all(24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                children: <Widget>[
                  Center(
                      child: Column(children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(message,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))
                  ]))
                ]));
  }

  static void showMessageDialog(
      BuildContext context, GlobalKey key, String message) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SimpleDialog(
                key: key,
                contentPadding: const EdgeInsets.all(24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                children: <Widget>[
                  Center(
                      child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ))
                ]));
  }
}
