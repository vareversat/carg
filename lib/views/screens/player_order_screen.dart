import 'package:carg/helpers/correct_instance.dart';
import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/player.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/services/game/abstract_game_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/dialogs.dart';
import 'package:carg/views/screens/play/play_belote_screen.dart';
import 'package:carg/views/screens/play/play_tarot_game_screen.dart';
import 'package:carg/views/widgets/players/draggable_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlayerOrderScreen extends StatefulWidget {
  final Game game;
  final List<Player> playerList;
  final String title;
  final AbstractGameService gameService;

  const PlayerOrderScreen(
      {super.key,
      required this.playerList,
      required this.game,
      required this.title,
      required this.gameService});

  @override
  State<StatefulWidget> createState() {
    return _PlayerOrderScreenState();
  }
}

class _PlayerOrderScreenState extends State<PlayerOrderScreen> {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  late final List<Player> playerListForTeam = List.from(widget.playerList);
  late final List<Player> playerListForOrder = List.from(widget.playerList);
  Game? _newGame;

  Future _createGame() async {
    Dialogs.showLoadingDialog(
        context, _keyLoader, AppLocalizations.of(context)!.gameIsStarting);
    var gameTmp = (await widget.gameService.createGameWithPlayerList(
        playerListForOrder.map((e) => e.id).toList(),
        playerListForTeam.map((e) => e.id).toList(),
        DateTime.now()));
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
      var player = playerListForOrder[oldIndex];
      playerListForOrder.removeAt(oldIndex);
      playerListForOrder.insert(newIndex, player);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Text(widget.title,
              style: CustomTextStyle.screenHeadLine1(context)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context)!.orderOfPlay,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Flexible(
                child: ReorderableListView(
                    onReorder: _onReorder,
                    children: playerListForOrder
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
                widget.game.gameType.direction(context),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).cardColor),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          CustomProperties.borderRadius,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () async => {
                    await _createGame(),
                    Navigator.pushAndRemoveUntil(
                        context,
                        CustomRouteFade(
                          builder: (context) => _newGame!.gameType !=
                                  GameType.TAROT
                              ? PlayBeloteScreen(
                                  gameService: widget.gameService,
                                  scoreService:
                                      CorrectInstance.ofScoreService(_newGame!),
                                  roundService:
                                      CorrectInstance.ofRoundService(_newGame!),
                                  beloteGame: _newGame as Belote<BelotePlayers>)
                              : PlayTarotGameScreen(
                                  tarotGame: _newGame as Tarot,
                                ),
                        ),
                        ModalRoute.withName('/'))
                  },
                  label: Text(
                    AppLocalizations.of(context)!.startTheGame,
                    style: const TextStyle(fontSize: 23),
                  ),
                  icon: const Icon(
                    Icons.check,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
