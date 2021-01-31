import 'package:carg/models/player.dart';
import 'package:carg/models/players/players.dart';
import 'package:flutter/material.dart';

class TarotRoundPlayers extends Players {
  String attackPlayer;
  String calledPlayer;

  TarotRoundPlayers({this.attackPlayer, this.calledPlayer, playerList})
      : super(playerList: playerList);

  bool isPlayerSelected(String playerId) {
    return attackPlayer == playerId || calledPlayer == playerId;
  }

  Color getSelectedColor(String playerId, BuildContext context) {
    if (calledPlayer == playerId) {
      return Colors.yellow;
    }
    if (attackPlayer == playerId) {
      return Theme.of(context).accentColor;
    }
    return null;
  }

  void onSelectedPlayer2(String player) {
    if (playerList.length <= 4) {
      attackPlayer = (player != attackPlayer ? player : null);
    } else {
      if (attackPlayer == null && calledPlayer == null) {
        attackPlayer = (player != attackPlayer ? player : null);
      } else if (attackPlayer != null && calledPlayer == null) {
        calledPlayer =
            (player != calledPlayer && player != attackPlayer ? player : null);
        attackPlayer = (player == attackPlayer ? null : attackPlayer);
      } else if (attackPlayer != null && calledPlayer != null) {
        calledPlayer = (player != calledPlayer ? player : null);
      }
    }
    notifyListeners();
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
  Map<String, dynamic> toJSON() {
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({
      'attack_player': attackPlayer,
      'called_player': calledPlayer,
    });
    return tmpJSON;
  }

  factory TarotRoundPlayers.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return TarotRoundPlayers(
      attackPlayer: json['attack_player'],
      calledPlayer: json['called_player'],
      playerList: json['player_list'],
    );
  }

  @override
  String toString() {
    return 'TarotGamePlayersRound{attackPlayer: $attackPlayer, '
        'calledPlayer: $calledPlayer, '
        'playerList: $playerList}';
  }

  @override
  void onSelectedPlayer(Player player) {
    throw UnimplementedError();
  }
}
