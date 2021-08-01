import 'package:carg/styles/properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
      child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(35),
            child: Container(
          height: 150,
          child: SvgPicture.asset(
            'assets/images/card_game.svg',
          ),
            ),
          ),
          Text(
            'Bienvenue sur Carg !',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'L\'application qui vous permet d\'enregister vos parties de Belote, Coinche, Contrée et Tarot !',
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 40),
          Container(
            child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                    foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).cardColor),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            side: BorderSide(
                                width: 2,
                                color: Theme.of(context).primaryColor ),
                            borderRadius: BorderRadius.circular(CustomProperties.borderRadius)))),
                onPressed: () async { },
                label: Text(
                  'Créer un nouveau joueur',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
          Container(
            width: 300,
            height: 40,
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Créer un niveau joueur avec aucune parties associées',
              style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30),
          Text('ou', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 30),
          Container(
            width: 250,
            height: 40,
            child: ElevatedButton.icon(
                icon: Icon(Icons.link),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                    foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).cardColor),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            side: BorderSide(
                                width: 2,
                                color: Theme.of(context).primaryColor ),
                            borderRadius: BorderRadius.circular(CustomProperties.borderRadius)))),
                onPressed: () async { },
                label: Flexible(
                  child: Text(
                    'Lier un joueur éxistant à son compte',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8.0),
            width: 300,
            child: Text(
              'Si vous avez un joueur sur le Carg de l\'un de vos amis, vous pouvez le lier à votre nouveau compte !',
              style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
      ]),
    ),
        ));
  }
}
