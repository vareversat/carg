import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/player.dart';
import 'package:carg/models/players/players.dart';
import 'package:carg/services/auth_service.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/styles/properties.dart';
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

  const PlayerPickerScreen({Key? key, required this.game, required this.title})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerPickerScreenState();
  }
}

class _PlayerPickerScreenState extends State<PlayerPickerScreen> {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final PlayerService _playerService = PlayerService();
  List<Player>? newPlayers;

  _PlayerPickerScreenState();

  Future _getPlayers() async {
    Dialogs.showLoadingDialog(context, _keyLoader, 'Chargement...');
    var playerListTmp = <Player>[];
    for (var playerId in widget.game!.players!.playerList!) {
      playerListTmp.add(await _playerService.getPlayer(playerId));
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
            title:
            Text(
                widget.title!, style: CustomTextStyle.screenHeadLine1(context)),
          ),
        ),
        body: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text('Sélection des joueurs',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChangeNotifierProvider.value(
                value: widget.game!.players!,
                child: Consumer<Players>(
                  builder: (context, playersData, child) =>
                      Text(playersData.getSelectedPlayersStatus()),
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
                        child: const Icon(Icons.error));
                  }
                  if (snapshot.data != null) {
                    return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChangeNotifierProvider.value(
                              value: snapshot.data![index],
                              child: Consumer<Player>(
                                  builder: (context, playerData, child) =>
                                      PlayerWidget(
                                          player: playerData,
                                          onTap: () =>
                                              widget.game!.players!
                                                  .onSelectedPlayer(
                                                  playerData))));
                        });
                  } else {
                    return const ErrorMessageWidget(
                        message: "Vous n'avez accès à aucun joueurs");
                  }
                },
                future: _playerService.searchPlayers(
                    playerId: Provider.of<AuthService>(context, listen: false)
                        .getPlayerIdOfUser(),
                    admin: Provider.of<AuthService>(context, listen: false)
                        .getAdmin()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ChangeNotifierProvider.value(
                value: widget.game!.players!,
                child: Consumer<Players>(
                    builder: (context, playersData, child) =>
                    playersData
                        .isFull()
                        ? SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                    Color>(
                                    Theme
                                        .of(context)
                                        .primaryColor),
                                foregroundColor:
                                MaterialStateProperty.all<Color>(
                                    Theme
                                        .of(context)
                                        .cardColor),
                                shape: MaterialStateProperty.all<
                                    OutlinedBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            CustomProperties
                                                .borderRadius)))),
                            onPressed: () async =>
                            {
                              await _getPlayers(),
                              widget.game!.players!.reset(),
                              Navigator.push(
                                  context,
                                  CustomRouteLeftToRight(
                                    builder: (context) =>
                                        PlayerOrderScreen(
                                            playerList: newPlayers!,
                                            title: widget.title!,
                                            game: widget.game!),
                                  ))
                            },
                            label: const Text('Ordre des joueurs',
                                style: TextStyle(fontSize: 23)),
                            icon: const Icon(
                              Icons.arrow_right_alt,
                              size: 30,
                            )),
                      ),
                    )
                        : Container()),
              ),
            )
          ],
        ));
  }
}
