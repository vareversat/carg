import 'package:carg/models/player.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/dialogs/player_info_dialog.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerWidget extends StatelessWidget {
  final Player player;
  final Function? onTap;

  const PlayerWidget({super.key, required this.player, this.onTap});

  Future _showEditPlayerDialog(BuildContext context) async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) => PlayerInfoDialog(
            player: player,
            playerService: PlayerService(),
            isNewPlayer: false));
    if (result != null) {
      InfoSnackBar.showSnackBar(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ElevatedButton(
            onPressed: () =>
                onTap == null ? _showEditPlayerDialog(context) : onTap!(),
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(Theme.of(context).cardColor),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            CustomProperties.borderRadius),
                        side: player.selected
                            ? BorderSide(
                                width: 2, color: player.getSideColor(context))
                            : BorderSide.none)),
                padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(
                    const EdgeInsets.only(right: 0, left: 15))),
            child: SizedBox(
                height: 60,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  player.profilePicture != ''
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: player.getSideColor(context),
                                  ),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(player.profilePicture,
                                          scale: 1)))),
                        )
                      : const SizedBox(),
                  Flexible(
                      flex: 7,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                player.userName,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 22),
                              ),
                            )
                          ])),
                  Flexible(
                      flex: 2,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: <Widget>[
                                const Icon(FontAwesomeIcons.trophy, size: 13),
                                Text(
                                  '  ${player.totalWonGames()}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(children: <Widget>[
                              const Icon(FontAwesomeIcons.gamepad, size: 13),
                              Text(
                                '  ${player.totalPlayedGames()}',
                                style: const TextStyle(fontSize: 16),
                              )
                            ])
                          ])),
                  Container(
                      width: 15,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          color: player.getSideColor(context)))
                ]))));
  }
}
