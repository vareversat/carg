import 'package:carg/models/player.dart';
import 'package:carg/models/players/players.dart';

class TarotGamePlayers extends Players {
  TarotGamePlayers({playerList}) : super(playerList: playerList);

  @override
  void onSelectedPlayer(Player player) {
    if (playerList.length < 5 && !playerList.contains(player)) {
      player.selected = true;
      playerList.add(player.id);
      notifyListeners();
    } else if (playerList.contains(player)) {
      player.selected = false;
      playerList.remove(player);
      notifyListeners();
    }
  }

  @override
  String getSelectedPlayersStatus() {
    return 'Joueurs : ' + playerList.length.toString() + '/5';
  }

  @override
  bool isFull() {
    return playerList.length >= 3;
  }

  @override
  String toString() {
    return 'TarotGamePlayers{playerList: $playerList}';
  }

  @override
  Map<String, dynamic> toJSON() {
    return super.toJSON();
  }

  factory TarotGamePlayers.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return TarotGamePlayers(
      playerList: json['player_list'],
    );
  }
}
