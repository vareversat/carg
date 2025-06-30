import 'package:carg/helpers/correct_instance.dart';
import 'package:carg/helpers/custom_route.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/player.dart';
import 'package:carg/models/players/players.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/dialogs.dart';
import 'package:carg/views/screens/player_order_screen.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:carg/views/widgets/players/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerPickerScreen extends StatefulWidget {
  final Game? game;
  final String? title;

  const PlayerPickerScreen({
    super.key,
    required this.game,
    required this.title,
  });

  @override
  State<StatefulWidget> createState() {
    return _PlayerPickerScreenState();
  }
}

class _PlayerPickerScreenState extends State<PlayerPickerScreen> {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final _playerService = PlayerService();
  List<Player>? newPlayers;

  _PlayerPickerScreenState();

  Future _getPlayers() async {
    Dialogs.showLoadingDialog(
      context,
      _keyLoader,
      '${AppLocalizations.of(context)!.loading}...',
    );
    var playerListTmp = <Player>[];
    for (var playerId in widget.game!.players!.playerList!) {
      var player = await _playerService.get(playerId);
      if (player != null) {
        playerListTmp.add(player);
      }
    }
    setState(() {
      newPlayers = playerListTmp;
    });
    Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    widget.game!.players!.reset();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text(
            widget.title!,
            style: CustomTextStyle.screenHeadLine1(context),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              AppLocalizations.of(context)!.playerSelection,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChangeNotifierProvider.value(
              value: widget.game!.players!,
              child: Consumer<Players>(
                builder: (context, playersData, child) =>
                    Text(playersData.getSelectedPlayersStatus(context)),
              ),
            ),
          ),
          Flexible(
            child: FutureBuilder<List<Player>>(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.connectionState == ConnectionState.none) {
                  return Container(
                    alignment: Alignment.center,
                    child: const Icon(Icons.error),
                  );
                }
                if (snapshot.data != null) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChangeNotifierProvider.value(
                        value: snapshot.data![index],
                        child: Consumer<Player>(
                          builder: (context, playerData, child) => PlayerWidget(
                            player: playerData,
                            onTap: () => widget.game!.players!.onSelectedPlayer(
                              playerData,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return ErrorMessageWidget(
                    message: AppLocalizations.of(context)!.noPlayerYet,
                  );
                }
              },
              future: _playerService.searchPlayers(
                currentPlayer: Provider.of<AuthService>(
                  context,
                  listen: false,
                ).getPlayer(),
              ),
            ),
          ),
          ChangeNotifierProvider.value(
            value: widget.game!.players!,
            child: Consumer<Players>(
              builder: (context, playersData, child) => playersData.isFull()
                  ? Container(
                      color: Theme.of(context).colorScheme.primary,
                      width: double.infinity,
                      height: 80,
                      child: TextButton(
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        onPressed: () async => {
                          await _getPlayers(),
                          widget.game!.players!.reset(),
                          Navigator.push(
                            context,
                            CustomRouteLeftToRight(
                              builder: (context) => PlayerOrderScreen(
                                playerList: newPlayers!,
                                title: widget.title!,
                                game: widget.game!,
                                gameService: CorrectInstance.ofGameService(
                                  widget.game!,
                                ),
                              ),
                            ),
                          ),
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.playerOrder,
                              style: const TextStyle(fontSize: 23),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.arrow_right_alt_outlined,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
