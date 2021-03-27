import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/screens/rules_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlayScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Game game;

  const PlayScreenAppBar({required this.game});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        toolbarHeight: 80,
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RulesScreen(gameType: game.gameType),
              ),
            ),
          ),
        ],
        title: Column(
          children: [
            Text(game.gameType.name,
                style: CustomTextStyle.screenHeadLine1(context)),
            Text(
                'Commencée le ${DateFormat('d MMMM yyyy à HH:mm').format(game.startingDate)}',
                style: TextStyle(fontSize: 12)),
            Divider(color: Colors.transparent, height: 5),
            if (game.isEnded)
              Text(
                  'Terminée le ${DateFormat('d MMMM yyyy à HH:mm').format(game.endingDate!)}',
                  style: TextStyle(fontSize: 12))
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context, 1),
            icon: Icon(Icons.cancel)));
  }

  @override
  Size get preferredSize => Size.fromHeight(80.0);
}
