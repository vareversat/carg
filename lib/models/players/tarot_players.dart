import 'package:carg/models/player.dart';
import 'package:carg/models/players/players.dart';

class TarotPlayers extends Players {
  TarotPlayers({playerList}) : super(playerList: playerList);

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
  String getSelectedPlayersStatus() {
    return 'Joueurs : ${playerList!.length}/5';
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
