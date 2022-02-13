import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/services/game/french_belote_service.dart';
import 'package:carg/services/score/french_belote_score_service.dart';

class FrenchBelote extends Belote {
  FrenchBelote(
      {String? id,
      GameType? gameType,
      FrenchBeloteService? gameService,
      FrenchBeloteScoreService? scoreService,
      DateTime? startingDate,
      DateTime? endingDate,
      String? winner,
      bool? isEnded,
      BelotePlayers? players,
      String? notes})
      : super(
            id: id,
            gameType: gameType ?? GameType.BELOTE,
            gameService: gameService ?? FrenchBeloteService(),
            scoreService: scoreService ?? FrenchBeloteScoreService(),
            players: players ?? BelotePlayers(),
            endingDate: endingDate,
            startingDate: startingDate ?? DateTime.now(),
            isEnded: isEnded ?? false,
            winner: winner,
            notes: notes);

  @override
  Map<String, dynamic> toJSON() {
    return super.toJSON();
  }

  factory FrenchBelote.fromJSON(Map<String, dynamic>? json, String id) {
    return FrenchBelote(
        id: id,
        startingDate: DateTime.parse(json?['starting_date']),
        endingDate: json?['ending_date'] != null
            ? DateTime.parse(json?['ending_date'])
            : null,
        isEnded: json?['is_ended'] as bool,
        players: BelotePlayers.fromJSON(json?['players']),
        winner: json?['winners'],
        notes: json?['notes']);
  }
}
