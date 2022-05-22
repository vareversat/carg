import 'package:carg/models/carg_object.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game_stats.dart';

abstract class CargPlayerObject extends CargObject {
  List<GameStats>? gameStatsList;

  CargPlayerObject({String? id, this.gameStatsList}) : super(id: id);

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
      stat = GameStats(gameType: game.gameType, wonGames: 1, playedGames: 1);
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


}
