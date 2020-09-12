import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/team_game.dart';
import 'package:carg/services/game/coinche_game_service.dart';

class CoincheGame extends TeamGame {
  CoincheGame({id, startingDate, endingDate, winner, isEnded, us, them})
      : super(
            id: id,
            gameType: GameType.COINCHE,
            gameService: CoincheGameService(),
            startingDate: startingDate,
            endingDate: endingDate,
            winner: winner,
            isEnded: isEnded,
            us: us,
            them: them);

  @override
  Map<String, dynamic> toJSON() {
    return super.toJSON();
  }

  factory CoincheGame.fromJSON(Map<String, dynamic> json, String id) {
    if (json == null) {
      return null;
    }
    return CoincheGame(
        id: id,
        startingDate: DateTime.parse(json['starting_date']),
        endingDate: json['ending_date'] != null
            ? DateTime.parse(json['ending_date'])
            : null,
        isEnded: json['is_ended'],
        us: json['us'],
        them: json['them'],
        winner: json['winners']);
  }
}
