import 'package:carg/models/game/game_type.dart';
import 'package:enum_to_string/enum_to_string.dart';

class GameStats {
  GameType gameType;
  int wonGames;
  int playedGames;

  GameStats({this.gameType, this.wonGames, this.playedGames});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStats &&
          runtimeType == other.runtimeType &&
          gameType == other.gameType &&
          wonGames == other.wonGames &&
          playedGames == other.playedGames;

  factory GameStats.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return GameStats(
        gameType: EnumToString.fromString(GameType.values, json['game_type']),
        wonGames: json['won_games'],
        playedGames: json['played_games']);
  }

  double winPercentage() {
    return double.parse(((wonGames * 100) / playedGames).toStringAsFixed(1));
  }

  static List<GameStats> fromJSONList(List<dynamic> jsonList) {
    return jsonList?.map((json) => GameStats.fromJSON(json))?.toList() ?? [];
  }

  Map<String, dynamic> toJSON() {
    return {
      'game_type': EnumToString.convertToString(gameType),
      'won_games': wonGames,
      'played_games': playedGames,
    };
  }

  @override
  String toString() {
    return 'GameStats{gameType: $gameType, wonGames: $wonGames, playedGames: $playedGames}';
  }
}
