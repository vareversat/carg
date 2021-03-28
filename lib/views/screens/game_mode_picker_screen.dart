import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/screens/player_picker_screen.dart';
import 'package:flutter/material.dart';

class GameModePickerScreen extends StatelessWidget {
  final String _appBarTitle = 'Nouvelle partie';
  final String _title = 'Sélection du jeu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Hero(
            tag: 'game_screen_title',
            child: Text(_appBarTitle,
                style: CustomTextStyle.screenHeadLine1(context)),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
    return InkWell(
      onTap: () => {
        Navigator.push(
            context,
            CustomRouteLeftAndRight(
                builder: (context) =>
                    PlayerPickerScreen(game: game, title: game!.gameType.name)))
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text(game!.gameType.name, style: TextStyle(fontSize: 20))),
          ],
        ),
      ),
    );
  }
}
