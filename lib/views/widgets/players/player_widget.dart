import 'package:carg/models/player.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/dialogs/player_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerWidget extends StatelessWidget {
  final Player player;
  final Function? onTap;

  PlayerWidget({required this.player, this.onTap});

  Future _showEditPlayerDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) =>
            PlayerInfoDialog(player: player, isEditing: false));
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
                MaterialStateProperty.all<Color>(Theme.of(context).cardColor),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(CustomProperties.borderRadius),
                    side: player.selected
                        ? BorderSide(
                            width: 2, color: Theme.of(context).primaryColor)
                        : BorderSide.none)),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
                EdgeInsets.only(right: 0, left: 15))),
        child: Container(
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
                              color: Theme.of(context).primaryColor,
                            ),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(player.profilePicture,
                                    scale: 1)))),
                  )
                : Container(),
            Container(
              width: 220,
              child: Text(
                player.userName!,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 22),
              ),
            ),
            Container(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.trophy, size: 13),
                      Text(
                        '  ' + player.totalWonGames().toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.gamepad, size: 13),
                      Text(
                        '  ' + player.totalPlayedGames().toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: !player.owned
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
              ),
            )
          ]),
        ),
      ),
    );
  }
}
