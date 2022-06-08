import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/players/belote_players.dart';

class ContreeBelote extends Belote {
  ContreeBelote(
      {String? id,
      GameType? gameType,
      DateTime? startingDate,
      DateTime? endingDate,
      String? winner,
      bool? isEnded,
      BelotePlayers? players,
      String? notes})
      : super(
            id: id,
            gameType: GameType.CONTREE,
            players: players ?? BelotePlayers(),
            endingDate: endingDate,
            startingDate: startingDate,
            isEnded: isEnded ?? false,
            winner: winner,
            notes: notes);

  @override
  Map<String, dynamic> toJSON() {
    return super.toJSON();
  }

  factory ContreeBelote.fromJSON(Map<String, dynamic>? json, String id) {
    return ContreeBelote(
        id: id,
        startingDate: DateTime.parse(json?['starting_date']),
        endingDate: json?['ending_date'] != null
            ? DateTime.parse(json?['ending_date'])
            : null,
        isEnded: json?['is_ended'],
        players: BelotePlayers.fromJSON(json?['players']),
        winner: json?['winners'],
        notes: json?['notes']);
  }
}
