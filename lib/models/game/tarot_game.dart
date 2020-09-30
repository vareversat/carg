import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/player/tarot_game_players.dart';
import 'package:carg/services/game/tarot_game_service.dart';

class TarotGame extends Game {
  List<String> playerIds;

  TarotGame({id, startingDate, endingDate, winner, isEnded, this.playerIds})
      : super(
            id: id,
            gameType: GameType.TAROT,
            gameService: TarotGameService(),
            startingDate: startingDate,
            endingDate: endingDate,
            winner: winner,
            isEnded: isEnded,
            players: TarotGamePlayers());

  @override
  Map<String, dynamic> toJSON() {
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({'playerIds': playerIds});
    return tmpJSON;
  }

  factory TarotGame.fromJSON(Map<String, dynamic> json, String id) {
    if (json == null) {
      return null;
    }
    return TarotGame(
        id: id,
        startingDate: DateTime.parse(json['starting_date']),
        endingDate: json['ending_date'] != null
            ? DateTime.parse(json['ending_date'])
            : null,
        isEnded: json['is_ended'],
        winner: json['winner'],
        playerIds: json['playerIds']);
  }

  @override
  String toString() {
    return super.toString();
  }
}
