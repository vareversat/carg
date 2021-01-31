import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/team_game.dart';
import 'package:carg/models/players/team_game_players.dart';
import 'package:carg/services/game/belote_game_service.dart';
import 'package:carg/services/score/belote_score_service.dart';

class BeloteGame extends TeamGame {
  BeloteGame({id, startingDate, endingDate, winner, isEnded, players})
      : super(
            id: id,
            gameType: GameType.BELOTE,
            gameService: BeloteGameService(),
            scoreService: BeloteScoreService(),
            players: players ?? TeamGamePlayers(),
            startingDate: startingDate ?? DateTime.now(),
            endingDate: endingDate,
            winner: winner,
            isEnded: isEnded ?? false);

  @override
  Map<String, dynamic> toJSON() {
    return super.toJSON();
  }

  factory BeloteGame.fromJSON(Map<String, dynamic> json, String id) {
    if (json == null) {
      return null;
    }
    return BeloteGame(
        id: id,
        startingDate: DateTime.parse(json['starting_date']),
        endingDate: json['ending_date'] != null
            ? DateTime.parse(json['ending_date'])
            : null,
        isEnded: json['is_ended'],
        players: TeamGamePlayers.fromJSON(json['players']),
        winner: json['winners']);
  }
}
