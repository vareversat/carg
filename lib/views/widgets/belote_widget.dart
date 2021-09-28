import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/score/belote_score.dart';
import 'package:carg/services/team_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/screens/play/play_belote_screen.dart';
import 'package:carg/views/widgets/register/game_title_widget.dart';
import 'package:carg/views/widgets/team_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BeloteWidget extends StatelessWidget {
  final Belote beloteGame;

  const BeloteWidget({required this.beloteGame});

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
                key: ValueKey('expansionTileTitle'), game: beloteGame),
            children: <Widget>[
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: TeamWidget(
                            key: ValueKey('teamWidget-US'),
                            teamId: beloteGame.players!.us,
                            title: 'Nous',
                            teamService: TeamService()),
                      ),
                      Flexible(
                        child: TeamWidget(
                            key: ValueKey('teamWidget-THEM'),
                            teamId: beloteGame.players!.them,
                            title: 'Eux',
                            teamService: TeamService()),
                      ),
                    ],
                  ),
                  _ShowScoreWidget(beloteGame: beloteGame),
                  Divider(height: 10, thickness: 2),
                  _ButtonRowWidget(beloteGame: beloteGame),
                ],
              )
            ]));
  }
}

class _ShowScoreWidget extends StatefulWidget {
  final Belote beloteGame;

  const _ShowScoreWidget({required this.beloteGame});

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
    return Column(children: [
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
                            ));
                          }));
                }
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(snapshot.data!.usTotalPoints.toString(),
                            key: ValueKey('usTotalPointsText'),
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        Text(snapshot.data!.themTotalPoints.toString(),
                            key: ValueKey('themTotalPointsText'),
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold))
                      ]);
                }
                return Center(child: Text(_errorMessage));
              },
              future: widget.beloteGame.scoreService
                      .getScoreByGame(widget.beloteGame.id)
                      // ignore: return_of_invalid_type_from_catch_error
                      .catchError((error) => {_errorMessage = error.toString()})
                  as Future<BeloteScore?>?)),
      if (widget.beloteGame.isEnded)
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
  final Belote beloteGame;

  const _ButtonRowWidget({required this.beloteGame});

  @override
  Widget build(BuildContext context) {
    return Wrap(alignment: WrapAlignment.spaceAround, spacing: 20, children: <
        Widget>[
      if (!beloteGame.isEnded)
        ElevatedButton.icon(
            key: ValueKey('stopButton'),
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
                                await beloteGame.gameService
                                    .endAGame(beloteGame),
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
          key: ValueKey('deleteButton'),
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
                            {beloteGame.gameService.deleteGame(beloteGame.id)},
                        message: 'Tu es sur le point de supprimer une partie.',
                        title: 'Suppression'))
              },
          label: Text(MaterialLocalizations.of(context).deleteButtonTooltip),
          icon: Icon(Icons.delete_forever)),
      if (!beloteGame.isEnded)
        ElevatedButton.icon(
            key: ValueKey('continueButton'),
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
                      builder: (context) => PlayBeloteScreen(
                        beloteGame: beloteGame,
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
            key: ValueKey('showScoreButton'),
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
                      builder: (context) => PlayBeloteScreen(
                        beloteGame: beloteGame,
                      ),
                    ),
                  )
                },
            child: Text('Consulter les scores')),
    ]);
  }
}
