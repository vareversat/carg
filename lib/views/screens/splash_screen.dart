import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            child: SvgPicture.asset('assets/images/card_game.svg'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Démarrage...',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                strokeWidth: 8,
              ))
        ],
      ),
    ));
  }
}
