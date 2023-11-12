import 'package:carg/models/player.dart';
import 'package:carg/models/players/players.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TarotPlayers extends Players {
  TarotPlayers({super.playerList});

  @override
  void onSelectedPlayer(Player player) {
    if (playerList!.length < 5 && !playerList!.contains(player.id)) {
      player.selected = true;
      playerList!.add(player.id);
      notifyListeners();
    } else if (playerList!.contains(player.id)) {
      player.selected = false;
      playerList!.remove(player.id);
      notifyListeners();
    }
  }

  @override
  String getSelectedPlayersStatus(BuildContext context) {
    return '${AppLocalizations.of(context)!.player(playerList!.length)} : ${playerList!.length}/5';
  }

  @override
  bool isFull() {
    return playerList!.length >= 3;
  }

  @override
  String toString() {
    return 'TarotGamePlayers{player_list: $playerList}';
  }

  factory TarotPlayers.fromJSON(Map<String, dynamic> json) {
    return TarotPlayers(
      playerList: json['player_list'],
    );
  }

  @override
  void reset() {
    playerList = [];
  }
}
