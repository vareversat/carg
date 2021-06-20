import 'package:carg/services/auth_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SigningOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Wrap(spacing: 20, runSpacing: 20, children: [
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                          foregroundColor:
                              MaterialStateProperty.all<Color?>(Colors.white),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      CustomProperties.borderRadius))),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 6))),
                      icon: Icon(FontAwesomeIcons.google),
                      label: Text(
                        'Compte Google',
                        style: TextStyle(fontSize: 25),
                      ),
                      onPressed: () async =>
                          await Provider.of<AuthService>(context, listen: false)
                              .googleLogIn(),
                    )),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                          foregroundColor:
                              MaterialStateProperty.all<Color?>(Colors.white),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      CustomProperties.borderRadius))),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 6))),
                      icon: FaIcon(FontAwesomeIcons.apple),
                      label: Text(
                        'Apple ID',
                        style: TextStyle(fontSize: 25),
                      ),
                      onPressed: () => {},
                    )),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                          foregroundColor:
                              MaterialStateProperty.all<Color?>(Colors.white),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      CustomProperties.borderRadius))),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 6))),
                      icon: Icon(Icons.mail),
                      label: Text(
                        'Adresse mail',
                        style: TextStyle(fontSize: 25),
                      ),
                      onPressed: () => {},
                    ))
              ]),
            )));
  }
}
