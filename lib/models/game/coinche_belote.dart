import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/services/game/coinche_belote_service.dart';
import 'package:carg/services/score/coinche_belote_score_service.dart';

class CoincheBelote extends Belote {
  CoincheBelote({id, startingDate, endingDate, winner, isEnded, players})
      : super(
      id: id,
      gameType: GameType.COINCHE,
      gameService: CoincheBeloteService(),
      scoreService: CoincheScoreService(),
      players: players ?? BelotePlayers(),
      startingDate: startingDate ?? DateTime.now(),
      endingDate: endingDate,
      winner: winner,
      isEnded: isEnded ?? false);

  @override
  Map<String, dynamic> toJSON() {
    return super.toJSON();
  }

  factory CoincheBelote.fromJSON(Map<String, dynamic>? json, String id) {
    return CoincheBelote(
        id: id,
        startingDate: DateTime.parse(json?['starting_date']),
        endingDate: json?['ending_date'] != null
            ? DateTime.parse(json?['ending_date'])
            : null,
        isEnded: json?['is_ended'],
        players: BelotePlayers.fromJSON(json?['players']),
        winner: json?['winners']);
  }
}
