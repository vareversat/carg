import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/team_game.dart';
import 'package:carg/models/score/team_game_score.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/screens/play_team_game_screen.dart';
import 'package:carg/views/widgets/team_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class TeamGameWidget extends StatelessWidget {
  final TeamGame teamGame;

  const TeamGameWidget({this.teamGame});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: ExpansionTile(
            title: _CardTitle(startingDate: teamGame.startingDate),
            children: <Widget>[
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TeamWidget(teamId: teamGame.us, title: 'Nous'),
                      TeamWidget(teamId: teamGame.them, title: 'Eux'),
                    ],
                  ),
                  _ShowScoreWidget(teamGame: teamGame),
                  _ButtonRowWidget(teamGame: teamGame),
                ],
              )
            ]),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        elevation: 2,
        color: Colors.white);
  }
}

class _CardTitle extends StatelessWidget {
  final DateTime startingDate;

  const _CardTitle({this.startingDate});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
            'Partie du ' +
                DateFormat('dd/MM/yyyy à HH:mm').format(startingDate),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)));
  }
}

class _ShowScoreWidget extends StatefulWidget {
  final TeamGame teamGame;

  const _ShowScoreWidget({this.teamGame});

  @override
  State<StatefulWidget> createState() {
    return _ShowScoreWidgetState(teamGame);
  }
}

class _ShowScoreWidgetState extends State<_ShowScoreWidget> {
  final TeamGame _teamGame;
  String _errorMessage;

  _ShowScoreWidgetState(this._teamGame);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black, width: 1))),
          child: FutureBuilder<TeamGameScore>(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: SpinKitThreeBounce(
                          size: 30,
                          itemBuilder: (BuildContext context, int index) {
                            return DecoratedBox(
                                decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                            ));
                          }));
                }
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(snapshot.data.usTotalPoints.toString(),
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        Text(snapshot.data.themTotalPoints.toString(),
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold))
                      ]);
                }
                return Center(child: Text(_errorMessage));
              },
              future: _teamGame.scoreService
                  .getScoreByGame(_teamGame.id)
                  .catchError((error) => {
                        setState(() {
                          _errorMessage = error.toString();
                        })
                      }))),
      if (_teamGame.isEnded)
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Partie terminée',
                style: TextStyle(fontStyle: FontStyle.italic)))
      else
        Container()
    ]);
  }
}

class _ButtonRowWidget extends StatelessWidget {
  final TeamGame teamGame;

  const _ButtonRowWidget({this.teamGame});

  @override
  Widget build(BuildContext context) {
    return Wrap(alignment: WrapAlignment.spaceAround, spacing: 20, children: <
        Widget>[
      if (!teamGame.isEnded)
        RaisedButton.icon(
            color: Colors.black,
            textColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            onPressed: () async => {
                  await showDialog(
                      context: context,
                      child: WarningDialog(
                          onConfirm: () async => {
                                await teamGame.gameService.endAGame(teamGame),
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
      RaisedButton.icon(
          color: Theme.of(context).errorColor,
          textColor: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          onPressed: () async => {
                await showDialog(
                    context: context,
                    child: WarningDialog(
                        onConfirm: () =>
                            {teamGame.gameService.deleteGame(teamGame.id)},
                        message: 'Tu es sur le point de supprimer une partie.',
                        title: 'Suppression'))
              },
          label: Text(MaterialLocalizations.of(context).deleteButtonTooltip),
          icon: Icon(Icons.delete_forever)),
      if (!teamGame.isEnded)
        RaisedButton.icon(
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            onPressed: () async => {
                  Navigator.push(
                    context,
                    CustomRouteScale(
                      builder: (context) => PlayTeamGameScreen(
                        teamGame: teamGame,
                      ),
                    ),
                  )
                },
            label: Text(
              MaterialLocalizations.of(context).continueButtonLabel,
            ),
            icon: Icon(Icons.play_arrow))
      else
        RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            onPressed: () async => {
                  Navigator.push(
                    context,
                    CustomRouteScale(
                      builder: (context) => PlayTeamGameScreen(
                        teamGame: teamGame,
                      ),
                    ),
                  )
                },
            child: Text('Consulter les scores')),
    ]);
  }
}
