import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/player.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/dialogs.dart';
import 'package:carg/views/screens/play/play_belote_screen.dart';
import 'package:carg/views/screens/play/play_tarot_game_screen.dart';
import 'package:carg/views/widgets/players/draggable_player_widget.dart';
import 'package:flutter/material.dart';

class PlayerOrderScreen extends StatefulWidget {
  final Game game;
  final List<Player> playerList;
  final String title;

  PlayerOrderScreen(
      {required this.playerList, required this.game, required this.title});

  @override
  State<StatefulWidget> createState() {
    return _PlayerOrderScreenState(
        playerList: playerList, game: game, title: title);
  }
}

class _PlayerOrderScreenState extends State<PlayerOrderScreen> {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final String? title;
  final List<Player>? playerList;
  final Game? game;
  Game? _newGame;

  _PlayerOrderScreenState({this.playerList, this.game, this.title});

  Future _createGame() async {
    Dialogs.showLoadingDialog(context, _keyLoader, 'Démarrage de la partie');
    var gameTmp = (await game!.gameService
        .createGameWithPlayerList(playerList!.map((e) => e.id).toList()));
    setState(() {
      _newGame = gameTmp;
    });
    Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      var player = playerList![oldIndex];
      playerList!.removeAt(oldIndex);
      playerList!.insert(newIndex, player);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            title:
                Text(title!, style: CustomTextStyle.screenHeadLine1(context)),
          ),
        ),
        body: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Ordre de jeu',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Flexible(
                    child: ReorderableListView(
                        onReorder: _onReorder,
                        children: playerList!
                            .asMap()
                            .map((i, player) => MapEntry(
                                i,
                                Container(
                                  key: ValueKey(player),
                                  child: DraggablePlayerWidget(
                                      player: player, index: i),
                                )))
                            .values
                            .toList())),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Info : Ce jeu de carte se joue dans le ${game!.gameType.direction}',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
                ),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).primaryColor),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).cardColor),
                                shape: MaterialStateProperty
                                    .all<OutlinedBorder>(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            CustomProperties.borderRadius)))),
                            onPressed: () async => {
                                  await _createGame(),
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      CustomRouteLeftAndRight(
                                          builder: (context) => _newGame!
                                                      .gameType !=
                                                  GameType.TAROT
                                              ? PlayBeloteScreen(
                                                  teamGame: _newGame
                                                      as Belote<BelotePlayers>)
                                              : PlayTarotGame(
                                                  tarotGame:
                                                      _newGame as Tarot)),
                                      ModalRoute.withName('/'))
                                },
                            label: Text('Démarrer la partie',
                                style: TextStyle(fontSize: 23)),
                            icon: Icon(Icons.check, size: 30))))
              ],
            )));
  }
}
