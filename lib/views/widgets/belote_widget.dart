import 'package:carg/helpers/correct_instance.dart';
import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/score/belote_score.dart';
import 'package:carg/services/game/abstract_belote_game_service.dart';
import 'package:carg/services/game/abstract_game_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/impl/team_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/round/abstract_belote_round_service.dart';
import 'package:carg/services/round/abstract_round_service.dart';
import 'package:carg/services/score/abstract_belote_score_service.dart';
import 'package:carg/services/score/abstract_score_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/screens/play/play_belote_screen.dart';
import 'package:carg/views/widgets/register/game_title_widget.dart';
import 'package:carg/views/widgets/team_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BeloteWidget extends StatelessWidget {
  final Belote beloteGame;
  late final AbstractBeloteGameService gameService;
  late final AbstractBeloteScoreService scoreService;
  late final AbstractTeamService teamService;
  late final AbstractBeloteRoundService roundService;
  late final AbstractPlayerService playerService;

  BeloteWidget(
      {super.key,
      required this.beloteGame,
      gameService,
      scoreService,
      teamService,
      roundService,
      playerService}) {
    this.gameService = gameService ?? CorrectInstance.ofGameService(beloteGame);
    this.scoreService =
        scoreService ?? CorrectInstance.ofScoreService(beloteGame);
    this.teamService = teamService ?? TeamService();
    this.roundService =
        roundService ?? CorrectInstance.ofRoundService(beloteGame);
    this.playerService = playerService ?? PlayerService();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      elevation: 2,
      color: Colors.white,
      child: ExpansionTile(
        title: GameTitleWidget(
            key: const ValueKey('expansionTileTitle'), game: beloteGame),
        children: <Widget>[
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: TeamWidget(
                        key: const ValueKey('teamWidget-US'),
                        teamId: beloteGame.players!.us,
                        title: AppLocalizations.of(context)!.us,
                        teamService: teamService,
                        playerService: playerService),
                  ),
                  Flexible(
                    child: TeamWidget(
                        key: const ValueKey('teamWidget-THEM'),
                        teamId: beloteGame.players!.them,
                        title: AppLocalizations.of(context)!.them,
                        teamService: teamService,
                        playerService: playerService),
                  ),
                ],
              ),
              _ShowScoreWidget(
                  beloteGame: beloteGame,
                  gameService: gameService,
                  scoreService: scoreService),
              const Divider(height: 10, thickness: 2),
              _ButtonRowWidget(
                  beloteGame: beloteGame,
                  gameService: gameService,
                  scoreService: scoreService,
                  roundService: roundService),
            ],
          )
        ],
      ),
    );
  }
}

class _ShowScoreWidget extends StatefulWidget {
  final Belote beloteGame;
  final AbstractGameService gameService;
  final AbstractScoreService scoreService;

  const _ShowScoreWidget(
      {required this.beloteGame,
      required this.gameService,
      required this.scoreService});

  @override
  State<StatefulWidget> createState() {
    return _ShowScoreWidgetState();
  }
}

class _ShowScoreWidgetState extends State<_ShowScoreWidget> {
  late String _errorMessage = '';

  _ShowScoreWidgetState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<BeloteScore?>(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitThreeBounce(
                      size: 30,
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        );
                      },
                    ),
                  );
                }
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          snapshot.data!.usTotalPoints.toString(),
                          key: const ValueKey('usTotalPointsText'),
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          snapshot.data!.themTotalPoints.toString(),
                          key: const ValueKey('themTotalPointsText'),
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ]);
                }
                return Center(child: Text(_errorMessage));
              },
              future: widget.scoreService
                      .getScoreByGame(widget.beloteGame.id)
                      // ignore: return_of_invalid_type_from_catch_error
                      .catchError((error) => {_errorMessage = error.toString()})
                  as Future<BeloteScore?>),
        ),
      ],
    );
  }
}

class _ButtonRowWidget extends StatelessWidget {
  final Belote beloteGame;
  final AbstractGameService gameService;
  final AbstractScoreService scoreService;
  final AbstractRoundService roundService;

  const _ButtonRowWidget(
      {required this.beloteGame,
      required this.gameService,
      required this.scoreService,
      required this.roundService});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      spacing: 20,
      children: <Widget>[
        if (!beloteGame.isEnded)
          ElevatedButton.icon(
            key: const ValueKey('stopButton'),
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                foregroundColor:
                    WidgetStateProperty.all<Color>(Theme.of(context).cardColor),
                shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            CustomProperties.borderRadius)))),
            onPressed: () async => {
              await showDialog(
                context: context,
                builder: (BuildContext context) => WarningDialog(
                    onConfirm: () async => {
                          await gameService.endAGame(
                              beloteGame, DateTime.now()),
                        },
                    message: AppLocalizations.of(context)!.messageStopGame,
                    title: AppLocalizations.of(context)!.warning,
                    color: Colors.black),
              ),
            },
            label: Text(
              AppLocalizations.of(context)!.stop,
            ),
            icon: const Icon(Icons.stop),
          )
        else
          Container(),
        ElevatedButton.icon(
          key: const ValueKey('deleteButton'),
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).colorScheme.error),
              foregroundColor:
                  WidgetStateProperty.all<Color>(Theme.of(context).cardColor),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          CustomProperties.borderRadius)))),
          onPressed: () async => {
            await showDialog(
              context: context,
              builder: (BuildContext context) => WarningDialog(
                  onConfirm: () => {gameService.deleteGame(beloteGame.id)},
                  message: AppLocalizations.of(context)!.messageDeleteGame,
                  title: AppLocalizations.of(context)!.delete),
            ),
          },
          label: Text(MaterialLocalizations.of(context).deleteButtonTooltip),
          icon: const Icon(Icons.delete_forever),
        ),
        if (!beloteGame.isEnded)
          ElevatedButton.icon(
            key: const ValueKey('continueButton'),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
              foregroundColor:
                  WidgetStateProperty.all<Color>(Theme.of(context).cardColor),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(CustomProperties.borderRadius),
                ),
              ),
            ),
            onPressed: () async => {
              Navigator.push(
                context,
                CustomRouteFade(
                  builder: (context) => PlayBeloteScreen(
                    beloteGame: beloteGame,
                    gameService: gameService,
                    scoreService: scoreService,
                    roundService: roundService,
                  ),
                ),
              ),
            },
            label: Text(
              MaterialLocalizations.of(context).continueButtonLabel,
            ),
            icon: const Icon(Icons.play_arrow),
          )
        else
          ElevatedButton(
            key: const ValueKey('showScoreButton'),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
              foregroundColor:
                  WidgetStateProperty.all<Color>(Theme.of(context).cardColor),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(CustomProperties.borderRadius),
                ),
              ),
            ),
            onPressed: () async => {
              Navigator.push(
                context,
                CustomRouteFade(
                  builder: (context) => PlayBeloteScreen(
                    beloteGame: beloteGame,
                    gameService: gameService,
                    scoreService: scoreService,
                    roundService: roundService,
                  ),
                ),
              )
            },
            child: Text(AppLocalizations.of(context)!.checkScores),
          ),
      ],
    );
  }
}
