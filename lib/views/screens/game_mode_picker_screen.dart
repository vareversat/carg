import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/models/game/contree_belote.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/screens/player_picker_screen.dart';
import 'package:flutter/material.dart';

class GameModePickerScreen extends StatelessWidget {
  final _appBarTitle = 'Nouvelle partie';
  final _title = 'Sélection du jeu';

  const GameModePickerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: Hero(
            tag: 'game_screen_title',
            child: Text(_appBarTitle,
                style: CustomTextStyle.screenHeadLine1(context)),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    _GameModeButton(
                      game: CoincheBelote(),
                    ),
                    _GameModeButton(game: FrenchBelote()),
                    _GameModeButton(game: ContreeBelote()),
                    _GameModeButton(
                      game: Tarot(),
                    )
                    //_GameModeButton(game: TarotGame())
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameModeButton extends StatelessWidget {
  final Game? game;

  const _GameModeButton({this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).cardColor),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            CustomProperties.borderRadius)))),
            onPressed: () => {
              Navigator.of(context).push(CustomRouteLeftToRight(
                  builder: (context) => PlayerPickerScreen(
                      game: game, title: game!.gameType.name)))
            },
            child:
                Text(game!.gameType.name, style: const TextStyle(fontSize: 25)),
          ),
        ));
  }
}
