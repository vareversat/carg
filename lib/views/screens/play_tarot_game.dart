import 'package:carg/models/game/tarot_game.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/services/score/tarot_score_service.dart';
import 'package:carg/views/dialogs/add_tarot_game_round_dialog.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/widgets/api_mini_player_widget.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayTarotGame extends StatefulWidget {
  final TarotGame tarotGame;

  const PlayTarotGame({@required this.tarotGame});

  @override
  State<StatefulWidget> createState() {
    return _PlayTarotGameState(tarotGame);
  }
}

class _PlayTarotGameState extends State<PlayTarotGame> {
  final TarotGame _tarotGame;
  final String _errorMessage = 'Error';
  final String _title = 'Tarot';
  final List<String> _playerIds = [];
  final TarotScoreService _tarotScoreService = TarotScoreService();

  _PlayTarotGameState(this._tarotGame);

  void _showAddRoundDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTarotGameRoundDialog(
          tarotGame: _tarotGame,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
          centerTitle: true,
        ),
        body: Column(children: <Widget>[
          Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _tarotGame.playerIds.length,
                  itemBuilder: (BuildContext context, int index) {
                    _playerIds.add(_tarotGame.playerIds[index]);
                    return Container(
                      width: MediaQuery.of(context).size.width /
                          _tarotGame.playerIds.length,
                      child: APIMiniPlayerWidget(
                        playerId: _tarotGame.playerIds[index],
                        displayImage: true,
                      ),
                    );
                  })),
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
                  child: StreamBuilder<TarotScore>(
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
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _tarotGame.playerIds.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width /
                                        _tarotGame.playerIds.length,
                                    child: Text(
                                      snapshot.data
                                          .getScoreOf(
                                              _tarotGame.playerIds[index])
                                          .score
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }),
                          ),
                          Flexible(
                            child: ListView.builder(
                                itemCount: snapshot.data.rounds.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Center(
                                          child: Text('df'),
                                        ),
                                      ),
                                      Flexible(
                                        child: Center(
                                          child: Text('sd'),
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          )
                        ],
                      );
                    },
                    stream:
                        _tarotScoreService.getScoreByGameStream(_tarotGame.id),
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
                                onConfirm: () async => {},
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
