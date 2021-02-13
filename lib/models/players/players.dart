import 'package:carg/models/player.dart';
import 'package:flutter/foundation.dart';

abstract class Players with ChangeNotifier {
  List<String> playerList;

  Players({playerList}) {
    if (playerList == null) {
      this.playerList = [];
    } else {
      this.playerList = (playerList as List).map((e) => e.toString()).toList();
    }
  }

  Players.prefilledList({playerList}) {
    if (playerList == null) {
      this.playerList = [' ', ' ', ' ', ' '];
    } else {
      this.playerList = (playerList as List).map((e) => e.toString()).toList();
    }
  }

  void onSelectedPlayer(Player player);

  String getSelectedPlayersStatus();

  bool isFull();

  void reset();

  Map<String, dynamic> toJSON() {
    return {
      'player_list': playerList.map((e) => e).toList(),
    };
  }
}
