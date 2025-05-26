import 'package:carg/helpers/correct_instance.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/players/tarot_round_players.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/services/impl/game/tarot_game_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/impl/round/tarot_round_service.dart';
import 'package:carg/services/impl/score/tarot_score_service.dart';
import 'package:carg/views/dialogs/notes_dialog.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/screens/add_round/add_tarot_round_screen.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:carg/views/screens/play/play_screen_app_bar.dart';
import 'package:carg/views/screens/play/play_screen_button_block.dart';
import 'package:carg/views/widgets/api_mini_player_widget.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:carg/views/widgets/players/next_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayTarotGameScreen extends StatefulWidget {
  final Tarot tarotGame;
  final tarotGameService = TarotGameService();
  final tarotRoundService = TarotRoundService();
  final tarotScoreService = TarotScoreService();

  PlayTarotGameScreen({super.key, required this.tarotGame});

  @override
  State<StatefulWidget> createState() {
    return _PlayTarotGameScreenState();
  }
}

class _PlayTarotGameScreenState extends State<PlayTarotGameScreen> {
  String? _errorMessage;
  final TarotScoreService _tarotScoreService = TarotScoreService();

  _PlayTarotGameScreenState();

  void _addNewRound() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTarotRoundScreen(
          tarotRound: TarotRound(
            settings: widget.tarotGame.settings,
            players: TarotRoundPlayers(
              playerList: widget.tarotGame.players!.playerList,
            ),
          ),
          isEditing: false,
          tarotGame: widget.tarotGame,
        ),
      ),
    );
  }

  void _deleteLastRound() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => WarningDialog(
        onConfirm: () async => {
          await widget.tarotRoundService.deleteLastRoundOfScoreByGameId(
            widget.tarotGame.id,
          ),
        },
        message: AppLocalizations.of(context)!.messageDeleteGame,
        title: AppLocalizations.of(context)!.warning,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _endGame() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => WarningDialog(
        onConfirm: () async => {
          await widget.tarotGameService.endAGame(
            widget.tarotGame,
            DateTime.now(),
          ),
          await Navigator.of(
            context,
          ).pushReplacementNamed(HomeScreen.routeName, arguments: 1),
        },
        message: AppLocalizations.of(context)!.messageStopGame,
        title: AppLocalizations.of(context)!.warning,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _editLastRound() async {
    TarotRound? lastRound;
    try {
      lastRound = (await widget.tarotScoreService.getScoreByGame(
        widget.tarotGame.id,
      ))!.getLastRound();
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddTarotRoundScreen(
            tarotGame: widget.tarotGame,
            tarotRound: lastRound,
            isEditing: true,
          ),
        ),
      );
    } on StateError {
      await showDialog(
        context: context,
        builder: (BuildContext context) => WarningDialog(
          onConfirm: () => {},
          showCancelButton: false,
          message: AppLocalizations.of(context)!.messageNoRound,
          title: AppLocalizations.of(context)!.error,
          color: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _addNotes() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => NotesDialog(
        game: widget.tarotGame,
        gameService: CorrectInstance.ofGameService(widget.tarotGame),
      ),
    );
  }

  bool _showLastRoundLayout(TarotScore score) {
    if (widget.tarotGame.settings.isInfinite) {
      return false;
    } else {
      var totalPoints = score.totalPoints;
      totalPoints.sort((b, a) => a.score.compareTo(b.score));
      return widget.tarotGame.settings.maxPoint <= totalPoints[0].score;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PlayScreenAppBar(game: widget.tarotGame),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.tarotGame.players!.playerList!.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width:
                      MediaQuery.of(context).size.width /
                      widget.tarotGame.players!.playerList!.length,
                  child: APIMiniPlayerWidget(
                    playerService: PlayerService(),
                    playerId: widget.tarotGame.players!.playerList![index],
                    displayImage: true,
                  ),
                );
              },
            ),
          ),
          Flexible(
            flex: 10,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black, width: 1)),
              ),
              child: StreamBuilder<TarotScore?>(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.connectionState == ConnectionState.none &&
                      snapshot.data == null) {
                    return ErrorMessageWidget(message: _errorMessage);
                  }
                  return Column(
                    children: <Widget>[
                      Flexible(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              widget.tarotGame.players!.playerList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width:
                                  MediaQuery.of(context).size.width /
                                  widget.tarotGame.players!.playerList!.length,
                              child: _TotalPointsWidget(
                                totalPoints: snapshot.data!
                                    .getScoreOf(
                                      widget
                                          .tarotGame
                                          .players!
                                          .playerList![index],
                                    )
                                    .score,
                              ),
                            );
                          },
                        ),
                      ),
                      Flexible(
                        flex: 10,
                        child: ListView.builder(
                          itemCount: snapshot.data!.rounds.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 20,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot
                                    .data!
                                    .rounds[index]
                                    .playerPoints!
                                    .length,
                                itemBuilder:
                                    (BuildContext context, int playerIndex) {
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                            widget
                                                .tarotGame
                                                .players!
                                                .playerList!
                                                .length,
                                        child: _RoundDisplay(
                                          round: snapshot.data!.rounds[index],
                                          player: widget
                                              .tarotGame
                                              .players!
                                              .playerList![playerIndex],
                                        ),
                                      );
                                    },
                              ),
                            );
                          },
                        ),
                      ),
                      if (!widget.tarotGame.isEnded)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: NextPlayerWidget(
                            playerId:
                                widget.tarotGame.players!.playerList![snapshot
                                        .data!
                                        .rounds
                                        .length %
                                    widget
                                        .tarotGame
                                        .players!
                                        .playerList!
                                        .length]!,
                          ),
                        ),
                      if (!widget.tarotGame.isEnded)
                        PlayScreenButtonBlock(
                          deleteLastRound: _deleteLastRound,
                          editLastRound: _editLastRound,
                          endGame: _endGame,
                          addNewRound: _addNewRound,
                          addNotes: _addNotes,
                          addNewSpecialRound: null,
                          lastRoundLayout: _showLastRoundLayout(snapshot.data!),
                        )
                      else if (widget.tarotGame.notes != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            elevation: 2,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context)!.gameNotes} : ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Divider(color: Colors.transparent),
                                  Text(widget.tarotGame.notes!),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
                stream: _tarotScoreService.getScoreByGameStream(
                  widget.tarotGame.id,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundDisplay extends StatelessWidget {
  final TarotRound? round;
  final String? player;

  const _RoundDisplay({this.round, this.player});

  @override
  Widget build(BuildContext context) {
    var score = round!.getScoreOf(player).score.round();
    return Wrap(
      children: [
        Text(
          score.toString(),
          style: TextStyle(
            fontSize: 20,
            color: score > 0 ? Colors.green : Colors.red,
          ),
        ),
        if (round!.players!.attackPlayer == player)
          const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Icon(FontAwesomeIcons.handFist, size: 15),
          )
        else
          Container(),
      ],
    );
  }
}

class _TotalPointsWidget extends StatelessWidget {
  final double? totalPoints;

  const _TotalPointsWidget({this.totalPoints});

  @override
  Widget build(BuildContext context) {
    return Text(
      totalPoints!.round().toString(),
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: totalPoints! >= 0 ? Colors.green : Colors.red,
      ),
    );
  }
}
