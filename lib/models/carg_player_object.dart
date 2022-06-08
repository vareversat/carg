import 'package:carg/models/carg_object.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game_stats.dart';
import 'package:collection/collection.dart';

abstract class CargPlayerObject extends CargObject {
  late List<GameStats>? gameStatsList;

  CargPlayerObject({String? id, List<GameStats>? gameStatsList})
      : super(id: id) {
    this.gameStatsList = gameStatsList ?? <GameStats>[];
  }

  void incrementPlayedGamesByOne(Game game) {
    GameStats stat;
    var index = gameStatsList!
        .indexWhere((element) => element.gameType.name == game.gameType.name);
    if (index == -1) {
      stat = GameStats(gameType: game.gameType, wonGames: 0, playedGames: 1);
      gameStatsList!.add(stat);
    } else {
      stat = gameStatsList![index];
      stat.playedGames += 1;
      gameStatsList!.removeAt(index);
      gameStatsList!.add(stat);
    }
  }

  void incrementWonGamesByOne(Game game) {
    GameStats stat;
    var index = gameStatsList!
        .indexWhere((element) => element.gameType.name == game.gameType.name);
    if (index == -1) {
      stat = GameStats(gameType: game.gameType, wonGames: 1, playedGames: 0);
      gameStatsList!.add(stat);
    } else {
      stat = gameStatsList![index];
      stat.wonGames += 1;
      gameStatsList!.removeAt(index);
      gameStatsList!.add(stat);
    }
  }

  double totalWinPercentage() {
    return double.parse(
        ((totalWonGames() * 100) / totalPlayedGames()).toStringAsFixed(1));
  }

  int totalWonGames() {
    var total = 0;
    for (var gameStat in gameStatsList!) {
      total += gameStat.wonGames;
    }
    return total;
  }

  int totalPlayedGames() {
    var total = 0;
    for (var gameStat in gameStatsList!) {
      total += gameStat.playedGames;
    }
    return total;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is CargPlayerObject &&
          runtimeType == other.runtimeType &&
          const ListEquality().equals(gameStatsList, other.gameStatsList);

  @override
  int get hashCode => super.hashCode ^ gameStatsList.hashCode;
}
