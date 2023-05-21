import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/player.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/models/players/players.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/game/abstract_game_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/dialogs.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:carg/views/screens/play/play_belote_screen.dart';
import 'package:carg/views/screens/play/play_tarot_game_screen.dart';
import 'package:carg/views/screens/register/waiting_room_screen.dart';
import 'package:carg/views/widgets/players/draggable_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PlayerOrderScreen extends StatefulWidget {
  final Game game;
  final List<Player> playerList;
  final AbstractGameService gameService;

  const PlayerOrderScreen(
      {Key? key,
      required this.playerList,
      required this.game,
      required this.gameService})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerOrderScreenState();
  }
}

class _PlayerOrderScreenState extends State<PlayerOrderScreen> {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  late final List<Player> playerListForTeam = List.from(widget.playerList);
  late final List<Player> playerListForOrder = List.from(widget.playerList);

  List<Player> _getRealPlayers() {
    var myId =
        Provider.of<AuthService>(context, listen: false).getPlayer()!.id!;
    return widget.playerList
        .expand((e) => [if (!e.owned && e.id != myId) e])
        .toList();
  }

  String _getRealPlayersUsernames(List<Player> players) {
    var message = '';
    for (var i = 0; i < players.length; i++) {
      if (i == 0) {
        message += players[i].userName;
      } else if (i == players.length - 1) {
        message +=
            " ${AppLocalizations.of(context)!.and} ${players[i].userName}";
      } else {
        message += ", ${players[i].userName}";
      }
    }
    return message;
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

  Future<Game?> _createGame(BuildContext localContext) async {
    var realPlayers = _getRealPlayers();
    var newGame = await widget.gameService.createGameWithPlayerList(
        playerListForOrder.map((e) => e.id).toList(),
        playerListForTeam.map((e) => e.id).toList(),
        DateTime.now());

    /// If other real players, show the dialog
    if (realPlayers.isNotEmpty) {
      var sendNotification = await displayDialog(realPlayers, newGame);
      if (sendNotification == null || sendNotification != true) {
        return null;
      } else {
        return newGame;
      }
    } else {
      return newGame;
    }
  }

  Future<bool?> displayDialog(List<Player> realPlayerList, Game newGame) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => WarningDialog(
        onConfirmButtonMessage: AppLocalizations.of(context)!.yes,
        onCancelButtonMessage: AppLocalizations.of(context)!.no,
        onConfirm: () => {true},
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .messageStartGame(realPlayerList.length),
              style: const TextStyle(
                fontSize: 23,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                _getRealPlayersUsernames(realPlayerList),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.doYouWantToContinue,
              style: const TextStyle(
                fontSize: 23,
              ),
            )
          ],
        ),
        title: AppLocalizations.of(context)!.information,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Text(
            widget.game.gameType.name,
            style: CustomTextStyle.screenHeadLine1(
              context,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.orderOfPlay,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              child: ReorderableListView(
                onReorder: _onReorder,
                children: playerListForOrder
                    .asMap()
                    .map(
                      (i, player) => MapEntry(
                        i,
                        DraggablePlayerWidget(
                          player: player,
                          index: i,
                          key: ValueKey(
                            player,
                          ),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
            ),
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
                  onPressed: () async {
                    var newGame = await _createGame(context);
                    if (newGame != null) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        CustomRouteFade(
                          builder: (context) => newGame.gameType !=
                                  GameType.TAROT
                              ? PlayBeloteScreen(
                                  beloteGame: newGame as Belote<BelotePlayers>)
                              : PlayTarotGameScreen(
                                  tarotGame: newGame as Tarot,
                                ),
                        ),
                        ModalRoute.withName('/'),
                      );
                    }
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
