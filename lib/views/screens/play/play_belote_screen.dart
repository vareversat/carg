import 'package:carg/helpers/correct_instance.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/score/belote_score.dart';
import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/services/game/abstract_game_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/impl/team_service.dart';
import 'package:carg/services/round/abstract_round_service.dart';
import 'package:carg/services/score/abstract_score_service.dart';
import 'package:carg/views/dialogs/notes_dialog.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/screens/add_round/add_belote_round_screen.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:carg/views/screens/play/play_screen_app_bar.dart';
import 'package:carg/views/screens/play/play_screen_button_block.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:carg/views/widgets/players/next_player_widget.dart';
import 'package:carg/views/widgets/team_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayBeloteScreen extends StatefulWidget {
  final Belote beloteGame;
  final AbstractGameService gameService;
  final AbstractScoreService scoreService;
  final AbstractRoundService roundService;

  const PlayBeloteScreen(
      {Key? key,
      required this.beloteGame,
      required this.gameService,
      required this.scoreService,
      required this.roundService})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayBeloteScreenState();
  }
}

class _PlayBeloteScreenState extends State<PlayBeloteScreen> {
  String? _errorMessage;

  void _addNewRound() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddBeloteRoundScreen(
                beloteGame: widget.beloteGame,
                beloteRound: widget.roundService.getNewRound() as BeloteRound?,
                roundService: CorrectInstance.ofRoundService(widget.beloteGame),
              )),
    );
  }

  void _deleteLastRound() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => WarningDialog(
          onConfirm: () async => {
                await widget.roundService
                    .deleteLastRoundOfScoreByGameId(widget.beloteGame.id),
              },
          message:
              'Tu es sur le point de supprimer la dernière manche de la partie. Cette action est irréversible',
          title: 'Attention',
          color: Theme.of(context).errorColor),
    );
  }

  void _endGame() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => WarningDialog(
              onConfirm: () async => {
                await widget.gameService
                    .endAGame(widget.beloteGame, DateTime.now()),
                await Navigator.of(context)
                    .pushReplacementNamed(HomeScreen.routeName, arguments: 1)
              },
              message:
                  'Tu es sur le point de terminer cette partie. Les gagnants ainsi que les perdants (honteux) vont être désignés',
              title: 'Attention',
              color: Theme.of(context).errorColor,
            ));
  }

  void _editLastRound() async {
    BeloteRound? lastRound;
    try {
      lastRound =
          (await widget.scoreService.getScoreByGame(widget.beloteGame.id))!
              .getLastRound() as BeloteRound?;
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddBeloteRoundScreen(
                  beloteGame: widget.beloteGame,
                  beloteRound: lastRound as BeloteRound,
                  roundService:
                      CorrectInstance.ofRoundService(widget.beloteGame),
                  isEditing: true)));
    } on StateError {
      await showDialog(
          context: context,
          builder: (BuildContext context) => WarningDialog(
                onConfirm: () => {},
                showCancelButton: false,
                message: 'Aucune manche n\'est enregistrée pour cette partie',
                title: 'Erreur',
                color: Theme.of(context).errorColor,
              ));
    }
  }

  void _addNotes() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => NotesDialog(
            game: widget.beloteGame, gameService: widget.gameService));
  }

  _PlayBeloteScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PlayScreenAppBar(game: widget.beloteGame),
        body: Column(children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                Flexible(
                  child: TeamWidget(
                      teamId: widget.beloteGame.players!.us,
                      title: 'Nous',
                      teamService: TeamService(),
                      playerService: PlayerService()),
                ),
                Flexible(
                  child: TeamWidget(
                      teamId: widget.beloteGame.players!.them,
                      title: 'Eux',
                      teamService: TeamService(),
                      playerService: PlayerService()),
                )
              ])),
          Flexible(
              child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black, width: 1))),
            child: StreamBuilder<BeloteScore?>(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  _TotalPointsWidget(
                                      totalPoints:
                                          snapshot.data!.usTotalPoints),
                                  _TotalPointsWidget(
                                      totalPoints:
                                          snapshot.data!.themTotalPoints)
                                ]),
                          ),
                          Flexible(
                              flex: 10,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ListView.builder(
                                    itemCount: snapshot.data!.rounds.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Flexible(
                                                flex: 3,
                                                child: _RoundDisplay(
                                                    round: snapshot
                                                        .data!.rounds[index],
                                                    team: BeloteTeamEnum.US)),
                                            Flexible(
                                                child: Text(
                                                    snapshot.data!.rounds[index]
                                                        .cardColor.symbol,
                                                    style: const TextStyle(
                                                        fontSize: 15))),
                                            Flexible(
                                                flex: 3,
                                                child: _RoundDisplay(
                                                    round: snapshot
                                                        .data!.rounds[index],
                                                    team: BeloteTeamEnum.THEM))
                                          ]);
                                    }),
                              )),
                          if (!widget.beloteGame.isEnded)
                            NextPlayerWidget(
                                playerId:
                                    widget.beloteGame.players!.playerList![
                                        snapshot.data!.rounds.length % 4]!),
                        ]);
                  } else {
                    return ErrorMessageWidget(message: _errorMessage);
                  }
                },
                stream: widget.scoreService
                        .getScoreByGameStream(widget.beloteGame.id)
                        .handleError(
                            (error) => {_errorMessage = error.toString()})
                    as Stream<BeloteScore<BeloteRound>?>?),
          )),
          if (!widget.beloteGame.isEnded)
            PlayScreenButtonBlock(
                deleteLastRound: _deleteLastRound,
                editLastRound: _editLastRound,
                endGame: _endGame,
                addNewRound: _addNewRound,
                addNotes: _addNotes)
          else if (widget.beloteGame.notes != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  elevation: 2,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text('Notes de partie : ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const Divider(color: Colors.transparent),
                        Text(widget.beloteGame.notes!),
                      ],
                    ),
                  )),
            )
        ]));
  }
}

class _RoundDisplay extends StatelessWidget {
  final BeloteRound? round;
  final BeloteTeamEnum? team;

  const _RoundDisplay({this.round, this.team});

  int? _getScore(BeloteRound teamGameRound, BeloteTeamEnum? teamGameEnum) {
    if (teamGameEnum == teamGameRound.taker) {
      return teamGameRound.takerScore;
    } else {
      return teamGameRound.defenderScore;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection:
            team == BeloteTeamEnum.US ? TextDirection.ltr : TextDirection.rtl,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(_getScore(round!, team).toString(),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold))),
          if (round!.taker == team)
            if (round!.contractFulfilled)
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: FaIcon(FontAwesomeIcons.solidCircleCheck,
                      size: 10, color: Colors.green))
            else
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: FaIcon(FontAwesomeIcons.solidCircleXmark,
                      size: 10, color: Colors.red))
          else
            Container(),
          if (round!.dixDeDer == team)
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text('+10', style: TextStyle(fontSize: 15)))
          else
            Container(),
          if (round!.beloteRebelote == team)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(children: const [
                  FaIcon(FontAwesomeIcons.crown, size: 10),
                  Text('|'),
                  FaIcon(FontAwesomeIcons.chessQueen, size: 10)
                ]))
          else
            Container()
        ]);
  }
}

class _TotalPointsWidget extends StatelessWidget {
  final int? totalPoints;

  const _TotalPointsWidget({this.totalPoints});

  @override
  Widget build(BuildContext context) {
    return Text(totalPoints.toString(),
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
  }
}
