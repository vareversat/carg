import 'package:carg/models/player.dart';
import 'package:carg/views/dialogs/player_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerWidget extends StatelessWidget {
  final Player player;
  final Function onTap;

  PlayerWidget({@required this.player, this.onTap});

  Future _showEditPlayerDialog(BuildContext context) async {
    await showDialog(
        context: context,
        child: PlayerInfoDialog(player: player, isEditing: false));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap == null ? _showEditPlayerDialog(context) : onTap(),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: player.selected
                ? BorderSide(width: 2, color: Theme.of(context).primaryColor)
                : BorderSide(width: 0, color: Colors.white)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  player.profilePicture != ''
                      ? Flexible(
                          flex: 2,
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
                  Flexible(
                    flex: 6,
                    child: Text(
                      player.userName,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.trophy, size: 15),
                        Text(
                          '  ' + player.totalWonGames().toString(),
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          ' - ',
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          player.totalPlayedGames().toString() + '  ',
                          style: TextStyle(fontSize: 17),
                        ),
                        Icon(FontAwesomeIcons.gamepad, size: 15)
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
