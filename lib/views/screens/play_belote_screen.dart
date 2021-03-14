import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/score/belote_score.dart';
import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/screens/add_round/add_belote_round_screen.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:carg/views/screens/rules_screen.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:carg/views/widgets/players/next_player_widget.dart';
import 'package:carg/views/widgets/team_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayBeloteScreen extends StatefulWidget {
  final Belote teamGame;

  const PlayBeloteScreen({required this.teamGame});

  @override
  State<StatefulWidget> createState() {
    return _PlayBeloteScreenState(teamGame);
  }
}

class _PlayBeloteScreenState extends State<PlayBeloteScreen> {
  final Belote _beloteGame;
  String? _errorMessage;

  void _addNewRound() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddBeloteRoundScreen(
              teamGame: _beloteGame,
              beloteRound:
                  _beloteGame.scoreService.getNewRound() as BeloteRound?)),
    );
  }

  void _deleteLastRound() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => WarningDialog(
          onConfirm: () async => {
                await _beloteGame.scoreService
                    .deleteLastRoundOfGame(_beloteGame.id),
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
                await _beloteGame.gameService.endAGame(_beloteGame),
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
    var lastRound;
    try {
      lastRound =
          (await _beloteGame.scoreService.getScoreByGame(_beloteGame.id))!
              .getLastRound();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddBeloteRoundScreen(
                  teamGame: _beloteGame,
                  beloteRound: lastRound,
                  isEditing: true)));
    } on StateError {
      await showDialog(
          context: context,
          builder: (BuildContext context) => WarningDialog(
                onConfirm: () => {},
                showCancelButton: false,
                message: 'Aucune manche n\'est enregistrée pour cette partie',
                title: 'Erreur',
                color: Colors.black,
              ));
    }
  }

  _PlayBeloteScreenState(this._beloteGame);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.help),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RulesScreen(gameType: _beloteGame.gameType),
                  ),
                ),
              ),
            ],
            title: Text(_beloteGame.gameType.name,
                style: CustomTextStyle.screenHeadLine2(context)),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () => Navigator.pop(context, 1),
                icon: Icon(Icons.cancel))),
        body: Column(children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                TeamWidget(teamId: _beloteGame.players!.us, title: 'Nous'),
                TeamWidget(teamId: _beloteGame.players!.them, title: 'Eux')
              ])),
          Flexible(
              child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black, width: 1))),
            child: StreamBuilder<BeloteScore?>(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
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
                                    itemCount: snapshot.data!.rounds!.length,
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
                                                        .data!.rounds![index],
                                                    team: BeloteTeamEnum.US)),
                                            Flexible(
                                                child: Text(
                                                    snapshot
                                                        .data!
                                                        .rounds![index]
                                                        .cardColor
                                                        .symbol,
                                                    style: TextStyle(
                                                        fontSize: 15))),
                                            Flexible(
                                                flex: 3,
                                                child: _RoundDisplay(
                                                    round: snapshot
                                                        .data!.rounds![index],
                                                    team: BeloteTeamEnum.THEM))
                                          ]);
                                    }),
                              )),
                          if (!_beloteGame.isEnded!)
                            NextPlayerWidget(
                                playerId: _beloteGame.players!.playerList![
                                    snapshot.data!.rounds!.length % 4]),
                        ]);
                  } else {
                    return ErrorMessageWidget(message: _errorMessage);
                  }
                },
                stream: _beloteGame.scoreService
                        .getScoreByGameStream(_beloteGame.id)
                        .handleError(
                            (error) => {_errorMessage = error.toString()})
                    as Stream<BeloteScore<BeloteRound>?>?),
          )),
          if (!_beloteGame.isEnded!)
            Wrap(
                runSpacing: 10,
                spacing: 10,
                alignment: WrapAlignment.spaceEvenly,
                children: <Widget>[
                  RawMaterialButton(
                      onPressed: () async => {_deleteLastRound()},
                      elevation: 2.0,
                      fillColor: Theme.of(context).errorColor,
                      textStyle: TextStyle(color: Theme.of(context).cardColor),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.delete_rounded,
                        size: 22,
                      )),
                  RawMaterialButton(
                      onPressed: () async => {_editLastRound()},
                      elevation: 2.0,
                      fillColor: Colors.black,
                      textStyle: TextStyle(color: Theme.of(context).cardColor),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.edit,
                        size: 22,
                      )),
                  RawMaterialButton(
                    onPressed: () async => {_endGame()},
                    elevation: 2.0,
                    fillColor: Theme.of(context).errorColor,
                    textStyle: TextStyle(color: Theme.of(context).cardColor),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                    child: Icon(
                      Icons.stop,
                      size: 22,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Theme.of(context).primaryColor),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).cardColor),
                                shape: MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            CustomProperties.borderRadius)))),
                            onPressed: () => {_addNewRound()},
                            icon: Icon(Icons.plus_one, size: 30),
                            label: Text('Nouvelle manche',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23))),
                      ),
                    ),
                  )
                ])
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
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
          if (round!.taker == team)
            if (round!.contractFulfilled)
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: FaIcon(FontAwesomeIcons.solidCheckCircle,
                      size: 10, color: Colors.green))
            else
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: FaIcon(FontAwesomeIcons.solidTimesCircle,
                      size: 10, color: Colors.red))
          else
            Container(),
          if (round!.dixDeDer == team)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text('+10', style: TextStyle(fontSize: 15)))
          else
            Container(),
          if (round!.beloteRebelote == team)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(children: [
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
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
  }
}
