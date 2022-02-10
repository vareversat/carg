import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: SvgPicture.asset('assets/images/card_game.svg'),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Démarrage...',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                ))
          ],
            ),
          )),
    );
  }
}
