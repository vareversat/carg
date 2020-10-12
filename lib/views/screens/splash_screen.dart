import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
        child: SpinKitWave(itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
          decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
      ));
    })));
  }
}
