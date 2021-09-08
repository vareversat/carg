import 'package:carg/models/player.dart';
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
    return InkWell(
      onTap: () => onTap == null ? _showEditPlayerDialog(context) : onTap!(),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: player.selected
                ? BorderSide(width: 2, color: Theme.of(context).primaryColor)
                : BorderSide(width: 0, color: Colors.white)),
        child: Container(
          height: 50,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            player.profilePicture != ''
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
              width: 210,
              child: Text(
                player.userName!,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.trophy, size: 12),
                        Text(
                          '  ' + player.totalWonGames().toString(),
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.gamepad, size: 12),
                        Text(
                          '  ' + player.totalPlayedGames().toString(),
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 10,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: player.ownedBy == ''
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).cardColor,
              ),
            )
          ]),
        ),
      ),
    );
  }
}
