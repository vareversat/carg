import 'package:carg/helpers/correct_instance.dart';
import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/services/game/abstract_tarot_game_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/score/abstract_tarot_score_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/screens/play/play_tarot_game_screen.dart';
import 'package:carg/views/widgets/api_mini_player_widget.dart';
import 'package:carg/views/widgets/register/game_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TarotWidget extends StatelessWidget {
  final Tarot tarotGame;
  late final AbstractTarotGameService gameService;
  late final AbstractTarotScoreService scoreService;
  late final AbstractPlayerService playerService;

  TarotWidget(
      {Key? key,
      required this.tarotGame,
      gameService,
      scoreService,
      playerService})
      : super(key: key) {
    this.gameService = gameService ?? CorrectInstance.ofGameService(tarotGame);
    this.scoreService =
        scoreService ?? CorrectInstance.ofScoreService(tarotGame);
    this.playerService = playerService ?? PlayerService();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        elevation: 2,
        color: Colors.white,
        child: ExpansionTile(
            title: GameTitleWidget(
                key: const ValueKey('expansionTileTitle'), game: tarotGame),
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
                        key: const ValueKey('apiminiplayerwidget'),
                        alignment: WrapAlignment.center,
                        spacing: 2,
                        children: tarotGame.players!.playerList!
                            .map((playerId) => APIMiniPlayerWidget(
                                  key:
                                      ValueKey('apiminiplayerwidget-$playerId'),
                                  playerId: playerId,
                                  displayImage: true,
                                  size: 20,
                                  playerService: playerService,
                                  additionalText:
                                      ' | ${snapshot.data!.getScoreOf(playerId).score.round().toString()}',
                                ))
                            .toList()
                            .cast<Widget>(),
                      );
                    }
                    return const Center(child: Text('error'));
                  },
                  future: scoreService.getScoreByGame(tarotGame.id)),
              const Divider(height: 10, thickness: 2),
              _ButtonRowWidget(tarotGame: tarotGame, gameService: gameService),
            ]));
  }
}

class _ButtonRowWidget extends StatelessWidget {
  final Tarot tarotGame;
  final AbstractTarotGameService gameService;

  const _ButtonRowWidget({required this.tarotGame, required this.gameService});

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
            onPressed: () async =>
            {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) => WarningDialog(
                          onConfirm: () async => {
                                await gameService.endAGame(
                                    tarotGame, DateTime.now()),
                              },
                          message:
                              'Tu es sur le point de terminer cette partie. Les gagnants ainsi que les perdants (honteux) vont être désignés',
                          title: 'Attention',
                          color: Colors.black))
                },
            label: const Text(
              'Arrêter',
            ),
            icon: const Icon(Icons.stop))
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
                        onConfirm: () => {gameService.deleteGame(tarotGame.id)},
                        message: 'Tu es sur le point de supprimer une partie.',
                        title: 'Suppression'))
              },
          label: Text(MaterialLocalizations.of(context).deleteButtonTooltip),
          icon: const Icon(Icons.delete_forever)),
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
                      builder: (context) => PlayTarotGameScreen(
                        tarotGame: tarotGame,
                      ),
                    ),
                  )
                },
            label: Text(
              MaterialLocalizations.of(context).continueButtonLabel,
            ),
            icon: const Icon(Icons.play_arrow))
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
                      builder: (context) => PlayTarotGameScreen(
                        tarotGame: tarotGame,
                      ),
                    ),
                  )
                },
            child: const Text('Consulter les scores')),
    ]);
  }
}
