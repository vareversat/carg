import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/player.dart';
import 'package:carg/models/players/players.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/dialogs.dart';
import 'package:carg/views/screens/player_order_screen.dart';
import 'package:carg/views/widgets/players/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerPickerScreen extends StatefulWidget {
  final Game game;
  final String title;

  PlayerPickerScreen({@required this.game, @required this.title});

  @override
  State<StatefulWidget> createState() {
    return _PlayerPickerScreenState(game: game, title: title);
  }
}

class _PlayerPickerScreenState extends State<PlayerPickerScreen> {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final PlayerService _playerService = PlayerService();
  final Game game;
  final String title;
  List<Player> newPlayers;

  _PlayerPickerScreenState({@required this.game, @required this.title});

  Future _getPlayers() async {
    Dialogs.showLoadingDialog(context, _keyLoader, 'Chargement...');
    var playerListTmp = <Player>[];
    for (var playerId in game.players.playerList) {
      await playerListTmp.add(await _playerService.getPlayer(playerId));
    }
    setState(() {
      newPlayers = playerListTmp;
    });
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    game.players.reset();
    return ChangeNotifierProvider.value(
      value: game.players,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              title:
                  Text(title, style: CustomTextStyle.screenHeadLine1(context)),
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
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Consumer<Players>(
                      builder: (context, playersData, child) => playersData
                          .isFull()
                          ? SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: RaisedButton.icon(
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).cardColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18.0)),
                              onPressed: () async => {
                                await _getPlayers(),
                                game.players.reset(),
                                Navigator.push(
                                    context,
                                    CustomRouteLeftAndRight(
                                      builder: (context) =>
                                          PlayerOrderScreen(
                                              playerList: newPlayers,
                                              title: title,
                                              game: game),
                                    ))
                              },
                              label: Text('Ordre des joueurs',
                                  style: TextStyle(fontSize: 23)),
                              icon: Icon(
                                Icons.arrow_right_alt,
                                size: 30,
                              )),
                        ),
                      )
                          : Container()),
                )
              ],
            ),
          )),
    );
  }
}
