import 'package:carg/models/game/game.dart';
import 'package:carg/models/player.dart';
import 'package:flutter/material.dart';

class WaitingRoomScreen extends StatefulWidget {
  final Game game;
  final List<Player> playerList;

  const WaitingRoomScreen(
      {Key? key, required this.game, required this.playerList})
      : super(key: key);

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
