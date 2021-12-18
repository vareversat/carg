import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/screens/play/play_tarot_game_screen.dart';
import 'package:carg/views/widgets/api_mini_player_widget.dart';
import 'package:carg/views/widgets/register/game_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TarotWidget extends StatelessWidget {
  final Tarot tarotGame;

  const TarotWidget({required this.tarotGame});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        elevation: 2,
        color: Colors.white,
        child: ExpansionTile(
            title: GameTitleWidget(
                key: ValueKey('expansionTileTitle'), game: tarotGame),
            children: <Widget>[
              FutureBuilder<TarotScore?>(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: SpinKitThreeBounce(
                              size: 30,
                              itemBuilder: (BuildContext context, int index) {
                                return DecoratedBox(
                                    decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ));
                              }));
                    }
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      return Wrap(
                        key: ValueKey('apiminiplayerwidget'),
                        alignment: WrapAlignment.center,
                        spacing: 2,
                        children: tarotGame.players!.playerList!
                            .map((playerId) => APIMiniPlayerWidget(
                                  key:
                                      ValueKey('apiminiplayerwidget-$playerId'),
                                  playerId: playerId,
                                  displayImage: true,
                                  size: 20,
                                  additionalText:
                                      ' | ${snapshot.data!.getScoreOf(playerId).score.round().toString()}',
                                ))
                            .toList()
                            .cast<Widget>(),
                      );
                    }
                    return Center(child: Text('error'));
                  },
                  future: tarotGame.scoreService.getScoreByGame(tarotGame.id)
                      as Future<TarotScore?>?),
              Divider(height: 10, thickness: 2),
              _ButtonRowWidget(tarotGame: tarotGame),
            ]));
  }
}

class _ButtonRowWidget extends StatelessWidget {
  final Tarot tarotGame;

  const _ButtonRowWidget({required this.tarotGame});

  @override
  Widget build(BuildContext context) {
    return Wrap(alignment: WrapAlignment.spaceAround, spacing: 20, children: <
        Widget>[
      if (!tarotGame.isEnded)
        ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).cardColor),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            CustomProperties.borderRadius)))),
            onPressed: () async => {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) => WarningDialog(
                          onConfirm: () async => {
                                await tarotGame.gameService.endAGame(tarotGame),
                              },
                          message:
                              'Tu es sur le point de terminer cette partie. Les gagnants ainsi que les perdants (honteux) vont être désignés',
                          title: 'Attention',
                          color: Colors.black))
                },
            label: Text(
              'Arrêter',
            ),
            icon: Icon(Icons.stop))
      else
        Container(),
      ElevatedButton.icon(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).errorColor),
              foregroundColor:
                  MaterialStateProperty.all<Color>(Theme.of(context).cardColor),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          CustomProperties.borderRadius)))),
          onPressed: () async => {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) => WarningDialog(
                        onConfirm: () =>
                            {tarotGame.gameService.deleteGame(tarotGame.id)},
                        message: 'Tu es sur le point de supprimer une partie.',
                        title: 'Suppression'))
              },
          label: Text(MaterialLocalizations.of(context).deleteButtonTooltip),
          icon: Icon(Icons.delete_forever)),
      if (!tarotGame.isEnded)
        ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).cardColor),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            CustomProperties.borderRadius)))),
            onPressed: () async => {
                  Navigator.push(
                    context,
                    CustomRouteFade(
                      builder: (context) => PlayTarotGame(
                        tarotGame: tarotGame,
                      ),
                    ),
                  )
                },
            label: Text(
              MaterialLocalizations.of(context).continueButtonLabel,
            ),
            icon: Icon(Icons.play_arrow))
      else
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).cardColor),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            CustomProperties.borderRadius)))),
            onPressed: () async => {
                  Navigator.push(
                    context,
                    CustomRouteFade(
                      builder: (context) => PlayTarotGame(
                        tarotGame: tarotGame,
                      ),
                    ),
                  )
                },
            child: Text('Consulter les scores')),
    ]);
  }
}
