import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/players/tarot_players.dart';

class Tarot extends Game<TarotPlayers> {
  Tarot(
      {super.id,
      DateTime? startingDate,
      super.endingDate,
      super.winner,
      bool? isEnded,
      TarotPlayers? players,
      super.notes,
      GameType? gameType})
      : super(
            gameType: gameType ?? GameType.TAROT,
            players: players ?? TarotPlayers(),
            startingDate: startingDate ?? DateTime.now(),
            isEnded: isEnded ?? false);

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
