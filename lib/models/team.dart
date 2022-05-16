import 'package:carg/models/carg_object.dart';
import 'package:collection/collection.dart';

class Team extends CargObject {
  String? name;
  int playedGames;
  int wonGames;
  List<dynamic>? players;
  List<dynamic>? games;

  Team(
      {String? id,
      this.playedGames = 1,
      this.wonGames = 0,
      this.name,
      this.players,
      this.games})
      : super(id: id);

  factory Team.fromJSON(Map<String, dynamic>? json, String id) {
    return Team(
        id: id,
        playedGames: json?['played_games'],
        wonGames: json?['won_games'] ?? 0,
        name: json?['name'],
        players: json?['players'],
        games: json?['games']);
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'played_games': playedGames,
      'won_games': wonGames,
      'name': name,
      'players': players,
      'games': games
    };
  }

  @override
  String toString() {
    return 'Team{id: $id, \n'
        'name: $name, \n'
        'playedGames: $playedGames, \n'
        'wonGames: $wonGames, \n'
        'players: $players, \n'
        'games: $games}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Team &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          playedGames == other.playedGames &&
          wonGames == other.wonGames &&
          const ListEquality().equals(players, other.players) &&
          const ListEquality().equals(games, other.games);

  @override
  int get hashCode =>
      super.hashCode ^
      name.hashCode ^
      playedGames.hashCode ^
      wonGames.hashCode ^
      players.hashCode ^
      games.hashCode;
}
