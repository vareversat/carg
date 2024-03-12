import 'package:carg/models/player.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:carg/views/widgets/players/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ShareUserScreen extends StatelessWidget {
  final Player player;
  final AbstractPlayerService playerService;

  const ShareUserScreen(
      {super.key, required this.player, required this.playerService});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text(AppLocalizations.of(context)!.share,
              style: CustomTextStyle.screenHeadLine1(context)),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              AppLocalizations.of(context)!.playerSelection,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            child: FutureBuilder<List<Player>>(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.connectionState == ConnectionState.none) {
                  return Container(
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.error,
                    ),
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
                            onTap: () => player.sharePlayer(playerData),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return ErrorMessageWidget(
                      message: AppLocalizations.of(context)!.noPlayerYet);
                }
              },
              future: playerService.searchPlayers(
                  currentPlayer:
                      Provider.of<AuthService>(context, listen: false)
                          .getPlayer(),
                  myPlayers: false),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ChangeNotifierProvider.value(
              value: player,
              child: Consumer<Player>(
                builder: (context, playersData, child) => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor,
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).cardColor,
                      ),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            CustomProperties.borderRadius,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () async => {
                      await playerService.update(player),
                      Navigator.of(context).pop()
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.validate,
                          style: const TextStyle(
                            fontSize: 23,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.check,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
