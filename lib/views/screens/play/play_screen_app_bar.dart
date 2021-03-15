import 'package:carg/models/game/game_type.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/screens/rules_screen.dart';
import 'package:flutter/material.dart';

class PlayScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GameType gameType;

  const PlayScreenAppBar({required this.gameType});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RulesScreen(gameType: gameType),
              ),
            ),
          ),
        ],
        title: Text(gameType.name,
            style: CustomTextStyle.screenHeadLine1(context)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context, 1),
            icon: Icon(Icons.cancel)));
  }

  @override
  Size get preferredSize => Size.fromHeight(70.0);
}
