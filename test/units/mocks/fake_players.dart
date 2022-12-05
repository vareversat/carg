import 'package:carg/models/player.dart';
import 'package:carg/models/players/players.dart';
import 'package:flutter/widgets.dart';

class FakePlayers extends Players {
  FakePlayers(List<String> players) : super(playerList: players);

  @override
  String getSelectedPlayersStatus(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  bool isFull() {
    throw UnimplementedError();
  }

  @override
  void onSelectedPlayer(Player player) {}

  @override
  void reset() {}
}
