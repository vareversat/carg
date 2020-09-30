import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/coinche_game.dart';
import 'package:carg/models/game/team_game.dart';
import 'package:carg/models/score/team_game_score.dart';
import 'package:carg/models/team.dart';
import 'package:carg/services/game/belote_game_service.dart';
import 'package:carg/services/game/coinche_game_service.dart';
import 'package:carg/services/game/team_game_service.dart';
import 'package:carg/services/score/belote_score_service.dart';
import 'package:carg/services/score/coinche_score_service.dart';
import 'package:carg/services/score/team_game_score_service.dart';
import 'package:carg/services/team_service.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/screens/play_team_game_screen.dart';
import 'package:carg/views/widgets/api_mini_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'error_message_widget.dart';

class TeamGameWidget extends StatefulWidget {
  final TeamGame teamGame;

  const TeamGameWidget({this.teamGame});

  @override
  State<StatefulWidget> createState() {
    return _TeamGameWidgetState(teamGame);
  }
}

class _TeamGameWidgetState extends State<TeamGameWidget> {
  final TeamService _teamService = TeamService();
  final TeamGame _teamGame;
  final String _errorMessage = 'Error';
  TeamGameScoreService _teamGameScoreService;
  TeamGameService _teamGameService;

  _TeamGameWidgetState(this._teamGame) {
    if (_teamGame is BeloteGame) {
      _teamGameService = BeloteGameService();
      _teamGameScoreService = BeloteScoreService();
    } else if (_teamGame is CoincheGame) {
      _teamGameService = CoincheGameService();
      _teamGameScoreService = CoincheScoreService();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ExpansionTile(
        title: Center(
          child: Text(
              'Partie du ' +
                  DateFormat('dd/MM/yyyy à HH:mm')
                      .format(_teamGame.startingDate),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 2,
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Nous',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              FutureBuilder<Team>(
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (snapshot.connectionState ==
                                              ConnectionState.none &&
                                          snapshot.hasData == null ||
                                      snapshot.data == null) {
                                    return ErrorMessageWidget(
                                        message: _errorMessage);
                                  }
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.players.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                            padding: EdgeInsets.all(5),
                                            child: APIMiniPlayerWidget(
                                              playerId:
                                                  snapshot.data.players[index],
                                              displayImage: true,
                                            ));
                                      });
                                },
                                future: _teamService.getTeam(_teamGame.us),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Eux',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              FutureBuilder<Team>(
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (snapshot.connectionState ==
                                              ConnectionState.none &&
                                          snapshot.hasData == null ||
                                      snapshot.data == null) {
                                    return ErrorMessageWidget(
                                        message: _errorMessage);
                                  }
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.players.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                            padding: EdgeInsets.all(5),
                                            child: APIMiniPlayerWidget(
                                              playerId:
                                                  snapshot.data.players[index],
                                              displayImage: true,
                                            ));
                                      });
                                },
                                future: _teamService.getTeam(_teamGame.them),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                        top: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      )),
                      child: FutureBuilder<TeamGameScore>(
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
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                snapshot.data.usTotalPoints.toString(),
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                snapshot.data.themTotalPoints.toString(),
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        },
                        future:
                            _teamGameScoreService.getScoreByGame(_teamGame.id),
                      ),
                    ),
                    _teamGame.isEnded
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Partie terminée',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            child: WarningDialog(
                              onConfirm: () =>
                                  {_teamGameService.deleteGame(_teamGame.id)},
                              message:
                                  'Tu es sur le point de supprimer une partie.',
                              title: 'Suppression',
                            ));
                      },
                      color: Theme.of(context).errorColor,
                      textColor: Colors.white,
                      child: Icon(Icons.delete_forever),
                      padding: EdgeInsets.all(8),
                      shape: CircleBorder(),
                    ),
                    !_teamGame.isEnded
                        ? MaterialButton(
                            onPressed: () async => {
                              await showDialog(
                                  context: context,
                                  child: WarningDialog(
                                    onConfirm: () async => {
                                      await _teamGameService
                                          .endAGame(_teamGame),
                                    },
                                    message:
                                        'Tu es sur le point de terminer cette partie. Les gagnants ainsi que les perdants (honteux) vont être désignés',
                                    title: 'Attention',
                                    color: Theme.of(context).primaryColor,
                                  )),
                            },
                            color: Colors.black,
                            textColor: Colors.white,
                            child: Icon(Icons.stop),
                            padding: EdgeInsets.all(8),
                            shape: CircleBorder(),
                          )
                        : Container(),
                    !_teamGame.isEnded
                        ? MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlayTeamGameScreen(
                                    teamGame: _teamGame,
                                  ),
                                ),
                              );
                            },
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            child: Icon(Icons.play_arrow),
                            padding: EdgeInsets.all(8),
                            shape: CircleBorder(),
                          )
                        : Container(),
                  ],
                ),
              )
            ],
          )
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      elevation: 2,
      color: Colors.white,
    );
  }
}
