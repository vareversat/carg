import 'package:carg/models/player/player.dart';
import 'package:carg/models/player/players.dart';
import 'package:flutter/material.dart';

class TarotGamePlayersRound extends Players {
  String _attackPlayer;
  String _calledPlayer;
  List<dynamic> playerList;

  TarotGamePlayersRound({attackPlayer, calledPlayer, players}) {
    _attackPlayer = attackPlayer;
    _calledPlayer = calledPlayer;
    playerList = players;
  }

  String get attackPlayer => _attackPlayer;

  set attackPlayer(String value) {
    _attackPlayer = value;
  }

  String get calledPlayer => _calledPlayer;

  set calledPlayer(String value) {
    _calledPlayer = value;
  }

  bool isPlayerSelected(String playerId) {
    return attackPlayer == playerId || calledPlayer == playerId;
  }

  @override
  void onSelectedPlayer(Player player) {}

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
  List<String> getPlayerIds() {
    return playerList;
  }

  Map<String, dynamic> toJSON() {
    return {
      'attack_player': attackPlayer,
      'called_player': calledPlayer,
      'players': playerList,
    };
  }

  factory TarotGamePlayersRound.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return TarotGamePlayersRound(
      attackPlayer: json['attack_player'],
      calledPlayer: json['called_player'],
      players: json['players'],
    );
  }

  @override
  String toString() {
    return 'TarotGamePlayersRound{_attackPlayer: $_attackPlayer, '
        '_calledPlayer: $_calledPlayer, '
        'players: $playerList}';
  }
}
