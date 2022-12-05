import 'package:carg/models/player.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

abstract class Players with ChangeNotifier {
  List<dynamic>? playerList;

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

  String getSelectedPlayersStatus(BuildContext context);

  bool isFull();

  void reset();

  Map<String, dynamic> toJSON() {
    return {
      'player_list': playerList!.map((e) => e).toList(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Players &&
          runtimeType == other.runtimeType &&
          const ListEquality().equals(playerList, other.playerList);

  @override
  int get hashCode => playerList.hashCode;
}
