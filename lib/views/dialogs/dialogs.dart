import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key, String message) async {
    return showDialog(
        context: context,
        child: SimpleDialog(
            key: key,
            contentPadding: const EdgeInsets.all(24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            children: <Widget>[
              Center(
                child: Column(children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    message,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ]),
              )
            ]));
  }
}
