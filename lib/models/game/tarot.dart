import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/players/tarot_players.dart';
import 'package:carg/services/game/tarot_service.dart';
import 'package:carg/services/score/tarot_score_service.dart';

class Tarot extends Game<TarotPlayers> {
  Tarot({id, startingDate, endingDate, winner, isEnded, players, notes})
      : super(
            id: id,
            gameType: GameType.TAROT,
            gameService: TarotService(),
            scoreService: TarotScoreService(),
            players: players ?? TarotPlayers(),
            startingDate: startingDate,
            endingDate: endingDate,
            winner: winner,
            notes: notes,
            isEnded: isEnded);

  @override
  Map<String, dynamic> toJSON() {
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({'players': players!.toJSON()});
    return tmpJSON;
  }

  factory Tarot.fromJSON(Map<String, dynamic>? json, String id) {
    return Tarot(
        id: id,
        startingDate: DateTime.parse(json?['starting_date']),
        endingDate: json?['ending_date'] != null
            ? DateTime.parse(json?['ending_date'])
            : null,
        isEnded: json?['is_ended'],
        winner: json?['winner'],
        players: TarotPlayers.fromJSON(json?['players']),
        notes: json?['notes']);
  }
}
