import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/coinche_game.dart';
import 'package:carg/models/game/team_game.dart';
import 'package:carg/models/score/misc/team_game_enum.dart';
import 'package:carg/models/score/round/team_game_round.dart';
import 'package:carg/models/score/team_game_score.dart';
import 'package:carg/models/team.dart';
import 'package:carg/services/game/belote_game_service.dart';
import 'package:carg/services/game/coinche_game_service.dart';
import 'package:carg/services/game/team_game_service.dart';
import 'package:carg/services/score/belote_score_service.dart';
import 'package:carg/services/score/coinche_score_service.dart';
import 'package:carg/services/score/team_game_score_service.dart';
import 'package:carg/services/team_service.dart';
import 'package:carg/views/screens/add_team_game_round_screen.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/widgets/api_mini_player_widget.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayTeamGameScreen extends StatefulWidget {
  final TeamGame teamGame;

  const PlayTeamGameScreen({@required this.teamGame});

  @override
  State<StatefulWidget> createState() {
    return _PlayTeamGameScreenState(teamGame);
  }
}

class _PlayTeamGameScreenState extends State<PlayTeamGameScreen> {
  final TeamService _teamService = TeamService();
  final TeamGame _teamGame;
  final String _errorMessage = 'Error';
  String _title;
  TeamGameScoreService _teamGameScoreService;
  TeamGameService _teamGameService;

  void _showAddRoundDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTeamGameRoundScreen(
          teamGame: _teamGame,
        ),
      ),
    );
  }

  _PlayTeamGameScreenState(this._teamGame) {
    if (_teamGame is CoincheGame) {
      _title = 'Coinche';
      _teamGameScoreService = CoincheScoreService();
      _teamGameService = CoincheGameService();
    } else if (_teamGame is BeloteGame) {
      _title = 'Belote';
      _teamGameScoreService = BeloteScoreService();
      _teamGameService = BeloteGameService();
    } else {
      _title = 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () => {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (_) => false)
                  },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Nous',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<Team>(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.connectionState ==
                                      ConnectionState.none &&
                                  snapshot.hasData == null ||
                              snapshot.data == null) {
                            return ErrorMessageWidget(message: _errorMessage);
                          }
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.players.length,
                              itemBuilder: (BuildContext context, int index) {
                                return APIMiniPlayerWidget(
                                  playerId: snapshot.data.players[index],
                                  displayImage: true,
                                );
                              });
                        },
                        future: _teamService.getTeam(_teamGame.us),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Eux',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<Team>(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.connectionState ==
                                      ConnectionState.none &&
                                  snapshot.hasData == null ||
                              snapshot.data == null) {
                            return ErrorMessageWidget(message: _errorMessage);
                          }
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.players.length,
                              itemBuilder: (BuildContext context, int index) {
                                return APIMiniPlayerWidget(
                                    playerId: snapshot.data.players[index],
                                    displayImage: true);
                              });
                        },
                        future: _teamService.getTeam(_teamGame.them),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Flexible(
              flex: 6,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  )),
                  child: StreamBuilder<TeamGameScore>(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.connectionState == ConnectionState.none &&
                              snapshot.hasData == null ||
                          snapshot.data == null) {
                        return ErrorMessageWidget(message: _errorMessage);
                      }
                      return Column(
                        children: <Widget>[
                          Flexible(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    snapshot.data.usTotalPoints.toString(),
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    snapshot.data.themTotalPoints.toString(),
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                          ),
                          Flexible(
                            child: ListView.builder(
                                itemCount: snapshot.data.rounds.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Center(
                                            child: _RoundDisplay(
                                          round: snapshot.data.rounds[index],
                                          team: TeamGameEnum.US,
                                        )),
                                      ),
                                      Flexible(
                                        child: Center(
                                            child: _RoundDisplay(
                                          round: snapshot.data.rounds[index],
                                          team: TeamGameEnum.THEM,
                                        )),
                                      )
                                    ],
                                  );
                                }),
                          )
                        ],
                      );
                    },
                    stream: _teamGameScoreService
                        .getScoreByGameStream(_teamGame.id),
                  ))),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton.icon(
                    color: Theme.of(context).errorColor,
                    textColor: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                    onPressed: () async => {
                          await showDialog(
                              context: context,
                              child: WarningDialog(
                                onConfirm: () async => {
                                  await _teamGameService.endAGame(_teamGame),
                                  Navigator.of(context).pop()
                                },
                                message:
                                    'Tu es sur le point de terminer cette partie. Les gagnants ainsi que les perdants (honteux) vont être désignés',
                                title: 'Attention',
                                color: Theme.of(context).errorColor,
                              )),
                        },
                    icon: Icon(Icons.stop),
                    label: Text('Terminer la partie',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                RaisedButton.icon(
                    onPressed: () => {_showAddRoundDialog()},
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                    icon: Icon(Icons.plus_one),
                    label: Text('Nouvelle manche',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          )
        ]));
  }
}

class _RoundDisplay extends StatelessWidget {
  final TeamGameRound round;
  final TeamGameEnum team;

  const _RoundDisplay({this.round, this.team});

  int _getScore(TeamGameRound teamGameRound, TeamGameEnum teamGameEnum) {
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
      children: [
        Text(_getScore(round, team).toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        round.taker == team
            ? round.contractFulfilled
                ? Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: FaIcon(
                      FontAwesomeIcons.solidCheckCircle,
                      size: 10,
                      color: Colors.green,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: FaIcon(
                      FontAwesomeIcons.solidTimesCircle,
                      size: 10,
                      color: Colors.red,
                    ))
            : Container(),
        round.dixDeDer == team
            ? Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text('+10'),
              )
            : Container(),
        round.beloteRebelote == team
            ? Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: FaIcon(FontAwesomeIcons.crown, size: 10),
                  ),
                  Text('|'),
                  FaIcon(FontAwesomeIcons.chessQueen, size: 10),
                ],
              )
            : Container(),
      ],
    );
  }
}
