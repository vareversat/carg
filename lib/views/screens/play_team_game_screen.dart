import 'package:carg/models/game/team_game.dart';
import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/misc/team_game_enum.dart';
import 'package:carg/models/score/round/team_game_round.dart';
import 'package:carg/models/score/team_game_score.dart';
import 'package:carg/models/team.dart';
import 'package:carg/services/team_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/screens/add_team_game_round_screen.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:carg/views/widgets/api_mini_player_widget.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:enum_to_string/enum_to_string.dart';
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
  final String _errorMessage = 'No data';

  void _addNewRound() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTeamGameRoundScreen(
          teamGame: _teamGame,
        ),
      ),
    );
  }

  void _deleteLastRound() async {
    await showDialog(
        context: context,
        child: WarningDialog(
          onConfirm: () async => {
            await _teamGame.scoreService.deleteLastRoundOfGame(_teamGame.id),
          },
          message:
              'Tu es sur le point de supprimer la dernière manche de la partie. Cette action est irréversible',
          title: 'Attention',
          color: Theme.of(context).errorColor,
        ));
  }

  void _endGame() async {
    await showDialog(
        context: context,
        child: WarningDialog(
          onConfirm: () async => {
            await _teamGame.gameService.endAGame(_teamGame),
            Navigator.of(context).pop()
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
      lastRound = (await _teamGame.scoreService.getScoreByGame(_teamGame.id))
          .getLastRound();
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddTeamGameRoundScreen(
            teamGame: _teamGame,
            teamGameRound: lastRound,
          ),
        ),
      );
    } on StateError {
      await showDialog(
          context: context,
          child: WarningDialog(
            onConfirm: () => {},
            showCancelButton: false,
            message: 'Aucune manche n\'est enregistrée pour cette partie',
            title: 'Erreur',
            color: Theme.of(context).errorColor,
          ));
    }
  }

  _PlayTeamGameScreenState(this._teamGame);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(EnumToString.convertToString(_teamGame.gameType),
              style: CustomTextStyle.screenHeadLine2(context)),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed(HomeScreen.routeName, arguments: 1),
              icon: Icon(Icons.cancel)),
        ),
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Nous',
                        style: CustomTextStyle.boldAndItalic(context),
                      ),
                      FutureBuilder<Team>(
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
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Eux',
                        style: CustomTextStyle.boldAndItalic(context),
                      ),
                      FutureBuilder<Team>(
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
                    ],
                  ),
                ),
              ],
            ),
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
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                          ),
                          Flexible(
                            child: ListView.builder(
                                itemCount: snapshot.data.rounds.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        flex: 3,
                                        child: _RoundDisplay(
                                          round: snapshot.data.rounds[index],
                                          team: TeamGameEnum.US,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          CardColor
                                              .values[snapshot
                                                  .data
                                                  .rounds[index]
                                                  .cardColor
                                                  .index]
                                              .symbol,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        child: _RoundDisplay(
                                          round: snapshot.data.rounds[index],
                                          team: TeamGameEnum.THEM,
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          )
                        ],
                      );
                    },
                    stream: _teamGame.scoreService
                        .getScoreByGameStream(_teamGame.id),
                  ))),
          Wrap(
            spacing: 10,
            alignment: WrapAlignment.spaceAround,
            children: <Widget>[
              RaisedButton.icon(
                  onPressed: () async => {_deleteLastRound()},
                  color: Theme.of(context).errorColor,
                  textColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  icon: Icon(Icons.delete_forever),
                  label: Text('Supprimer la dernière manche',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              RaisedButton.icon(
                  onPressed: () async => {_editLastRound()},
                  color: Colors.black,
                  textColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  icon: Icon(Icons.edit),
                  label: Text('Éditer la dernière manche',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              RaisedButton.icon(
                  onPressed: () async => {_endGame()},
                  color: Theme.of(context).errorColor,
                  textColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  icon: Icon(Icons.stop),
                  label: Text('Terminer la partie',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              RaisedButton.icon(
                  onPressed: () => {_addNewRound()},
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  icon: Icon(Icons.plus_one),
                  label: Text('Nouvelle manche',
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          SizedBox(
            height: 10,
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
      textDirection:
          team == TeamGameEnum.US ? TextDirection.ltr : TextDirection.rtl,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(_getScore(round, team).toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        round.taker == team
            ? round.contractFulfilled
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: FaIcon(
                      FontAwesomeIcons.solidCheckCircle,
                      size: 10,
                      color: Colors.green,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: FaIcon(
                      FontAwesomeIcons.solidTimesCircle,
                      size: 10,
                      color: Colors.red,
                    ))
            : Container(),
        round.dixDeDer == team
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  '+10',
                  style: TextStyle(fontSize: 15),
                ),
              )
            : Container(),
        round.beloteRebelote == team
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.crown, size: 10),
                    Text('|'),
                    FaIcon(FontAwesomeIcons.chessQueen, size: 10),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}
