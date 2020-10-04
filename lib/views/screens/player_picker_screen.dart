import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/player/player.dart';
import 'package:carg/models/player/players.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/dialogs.dart';
import 'package:carg/views/screens/play_tarot_game_screen.dart';
import 'package:carg/views/screens/play_team_game_screen.dart';
import 'package:carg/views/widgets/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerPickerScreen extends StatefulWidget {
  final Game newGame;
  final String title;

  PlayerPickerScreen({@required this.newGame, @required this.title});

  @override
  State<StatefulWidget> createState() {
    return _PlayerPickerScreenState(game: newGame, title: title);
  }
}

class _PlayerPickerScreenState extends State<PlayerPickerScreen> {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final PlayerService _playerService = PlayerService();
  final Game game;
  final String title;
  Game newGame;

  _PlayerPickerScreenState({@required this.game, @required this.title});

  Future _createGame() async {
    // ignore: unawaited_futures
    Dialogs.showLoadingDialog(context, _keyLoader, 'Démarrage de la partie');
    var gameTmp = (await game.gameService.createGameWithPlayers(game.players));
    setState(() {
      newGame = gameTmp;
    });
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: game.players,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              title: Text(title,
                  style: CustomTextStyle.screenHeadLine1(context)),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Sélection des joueurs',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Consumer<Players>(
                  builder: (context, playersData, child) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(playersData.getSelectedPlayersStatus()),
                  ),
                ),
                Flexible(
                  child: FutureBuilder<List<Player>>(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.connectionState == ConnectionState.none &&
                          snapshot.hasData == null) {
                        return Container(
                            alignment: Alignment.center,
                            child: Icon(Icons.error));
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChangeNotifierProvider(
                              create: (BuildContext context) =>
                                  snapshot.data[index],
                              child: PlayerWidget(
                                  player: snapshot.data[index],
                                  onTap: () => game.players
                                      .onSelectedPlayer(snapshot.data[index])),
                            );
                          });
                    },
                    future: _playerService.getAllPlayers(),
                  ),
                ),
                Consumer<Players>(
                    builder: (context, playersData, child) => playersData
                            .isFull()
                        ? RaisedButton.icon(
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            onPressed: () async => {
                                  await _createGame(),
                                  Navigator.pop(context),
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => newGame.gameType !=
                                              GameType.TAROT
                                          ? PlayTeamGameScreen(
                                              teamGame: newGame)
                                          : PlayTarotGame(tarotGame: newGame),
                                    ),
                                  )
                                },
                            label: Text('Démarrer'),
                            icon: Icon(Icons.check))
                        : Container())
              ],
            ),
          )),
    );
  }
}
