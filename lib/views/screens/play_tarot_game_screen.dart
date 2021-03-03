import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/players/tarot_round_players.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/services/score/tarot_score_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/screens/add_round/add_tarot_round_screen.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:carg/views/widgets/api_mini_player_widget.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:carg/views/widgets/players/next_player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayTarotGame extends StatefulWidget {
  final Tarot tarotGame;

  const PlayTarotGame({@required this.tarotGame});

  @override
  State<StatefulWidget> createState() {
    return _PlayTarotGameState(tarotGame);
  }
}

class _PlayTarotGameState extends State<PlayTarotGame> {
  final Tarot _tarotGame;
  final String _errorMessage = 'Error';
  final String _title = 'Tarot';
  final TarotScoreService _tarotScoreService = TarotScoreService();

  _PlayTarotGameState(this._tarotGame);

  void _addNewRound() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddTarotRoundScreen(
              tarotRound: TarotRound(
                  players: TarotRoundPlayers(
                      playerList: _tarotGame.players.playerList)),
              isEditing: false,
              tarotGame: _tarotGame)),
    );
  }

  void _deleteLastRound() async {
    await showDialog(
      context: context,
      child: WarningDialog(
          onConfirm: () async => {
                await _tarotGame.scoreService
                    .deleteLastRoundOfGame(_tarotGame.id),
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
        child: WarningDialog(
          onConfirm: () async => {
            await _tarotGame.gameService.endAGame(_tarotGame),
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
      lastRound = (await _tarotGame.scoreService.getScoreByGame(_tarotGame.id))
          .getLastRound();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddTarotRoundScreen(
                  tarotGame: _tarotGame,
                  tarotRound: lastRound,
                  isEditing: true)));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Text(_title, style: CustomTextStyle.screenHeadLine2(context)),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () => Navigator.pop(context, 1),
                icon: Icon(Icons.cancel))),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _tarotGame.players.playerList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: MediaQuery.of(context).size.width /
                              _tarotGame.players.playerList.length,
                          child: APIMiniPlayerWidget(
                            playerId: _tarotGame.players.playerList[index],
                            displayImage: true,
                          ),
                        );
                      })),
              Flexible(
                  flex: 10,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                        top: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      )),
                      child: StreamBuilder<TarotScore>(
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
                          return Column(
                            children: <Widget>[
                              Flexible(
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        _tarotGame.players.playerList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                _tarotGame
                                                    .players.playerList.length,
                                        child: _TotalPointsWidget(
                                            totalPoints: snapshot.data
                                                .getScoreOf(_tarotGame
                                                    .players.playerList[index])
                                                .score),
                                      );
                                    }),
                              ),
                              Flexible(
                                flex: 10,
                                child: ListView.builder(
                                    itemCount: snapshot.data.rounds.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                          height: 20,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: snapshot
                                                  .data
                                                  .rounds[index]
                                                  .playerPoints
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int playerIndex) {
                                                return Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            _tarotGame
                                                                .players
                                                                .playerList
                                                                .length,
                                                    child: _RoundDisplay(
                                                        round: snapshot
                                                            .data.rounds[index],
                                                        player: _tarotGame
                                                                .players
                                                                .playerList[
                                                            playerIndex]));
                                              }));
                                    }),
                              ),
                              if (!_tarotGame.isEnded)
                                NextPlayerWidget(
                                    playerId: _tarotGame.players.playerList[
                                        snapshot.data.rounds.length %
                                            _tarotGame
                                                .players.playerList.length]),
                            ],
                          );
                        },
                        stream: _tarotScoreService
                            .getScoreByGameStream(_tarotGame.id),
                      ))),
              if (!_tarotGame.isEnded)
                Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    alignment: WrapAlignment.spaceEvenly,
                    children: <Widget>[
                      RawMaterialButton(
                        onPressed: () async => {_deleteLastRound()},
                        elevation: 2.0,
                        fillColor: Theme.of(context).errorColor,
                        textStyle:
                            TextStyle(color: Theme.of(context).cardColor),
                        child: Icon(
                          Icons.delete_rounded,
                          size: 22,
                        ),
                        padding: EdgeInsets.all(15.0),
                        shape: CircleBorder(),
                      ),
                      RawMaterialButton(
                        onPressed: () async => {_editLastRound()},
                        elevation: 2.0,
                        fillColor: Colors.black,
                        textStyle:
                            TextStyle(color: Theme.of(context).cardColor),
                        child: Icon(
                          Icons.edit,
                          size: 22,
                        ),
                        padding: EdgeInsets.all(15.0),
                        shape: CircleBorder(),
                      ),
                      RawMaterialButton(
                        onPressed: () async => {_endGame()},
                        elevation: 2.0,
                        fillColor: Theme.of(context).errorColor,
                        textStyle:
                            TextStyle(color: Theme.of(context).cardColor),
                        child: Icon(
                          Icons.stop,
                          size: 22,
                        ),
                        padding: EdgeInsets.all(15.0),
                        shape: CircleBorder(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: RaisedButton.icon(
                                onPressed: () => {_addNewRound()},
                                color: Theme.of(context).primaryColor,
                                textColor: Theme.of(context).cardColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                                icon: Icon(Icons.plus_one, size: 30),
                                label: Text('Nouvelle manche',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23))),
                          ),
                        ),
                      )
                    ])
            ]));
  }
}

class _RoundDisplay extends StatelessWidget {
  final TarotRound round;
  final String player;

  const _RoundDisplay({this.round, this.player});

  @override
  Widget build(BuildContext context) {
    var score = round.getScoreOf(player).score.round();
    return Wrap(
      children: [
        Text(score.toString(),
            style: TextStyle(
                fontSize: 20, color: score > 0 ? Colors.green : Colors.red)),
        if (round.players.attackPlayer == player)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Icon(
              FontAwesomeIcons.fistRaised,
              size: 15,
            ),
          )
        else
          Container()
      ],
    );
  }
}

class _TotalPointsWidget extends StatelessWidget {
  final double totalPoints;

  const _TotalPointsWidget({this.totalPoints});

  @override
  Widget build(BuildContext context) {
    return Text(totalPoints.round().toString(),
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: totalPoints >= 0 ? Colors.green : Colors.red));
  }
}
