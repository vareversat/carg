import 'package:carg/models/carg_object.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game_stats.dart';
import 'package:carg/models/player.dart';
import 'package:carg/models/players/players.dart';
import 'package:carg/services/game/game_service.dart';
import 'package:carg/services/score/score_service.dart';
import 'package:intl/intl.dart';

abstract class Game<T extends Players> extends CargObject {
  DateTime startingDate;
  DateTime? endingDate;
  bool? isEnded;
  String? winner;
  T? players;
  GameService gameService;
  ScoreService scoreService;
  late GameType gameType;

  Game(
      {String? id,
      required gameType,
      required this.gameService,
      required this.scoreService,
      this.players,
      required this.startingDate,
      this.endingDate,
      this.winner,
      this.isEnded = false})
      : super(id: id) {
    this.gameType = gameType ?? GameType.UNDEFINE;
  }

  void incrementPlayerPlayedGamesByOne(Player player) {
    GameStats stat;
    var index = player.gameStatsList!
        .indexWhere((element) => element.gameType.name == gameType.name);
    if (index == -1) {
      stat = GameStats(gameType: gameType, wonGames: 0, playedGames: 1);
      player.gameStatsList!.add(stat);
    } else {
      stat = player.gameStatsList![index];
      stat.playedGames += 1;
      player.gameStatsList!.removeAt(index);
      player.gameStatsList!.add(stat);
    }
  }

  void incrementPlayerWonGamesByOne(Player player) {
    GameStats stat;
    var index = player.gameStatsList!
        .indexWhere((element) => element.gameType.name == gameType.name);
    if (index == -1) {
      stat = GameStats(gameType: gameType, wonGames: 1, playedGames: 1);
      player.gameStatsList!.add(stat);
    } else {
      stat = player.gameStatsList![index];
      stat.wonGames += 1;
      player.gameStatsList!.removeAt(index);
      player.gameStatsList!.add(stat);
    }
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'starting_date': DateFormat('yyyy-MM-ddTHH:mm:ss').format(startingDate),
      'ending_date': endingDate != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss').format(endingDate!)
          : null,
      'is_ended': isEnded,
      'winners': winner
    };
  }

  @override
  String toString() {
    return 'Game{startingDate: $startingDate, '
        'endingDate: $endingDate, isEnded: $isEnded, '
        'winner: $winner, players: $players, '
        'gameService: $gameService, '
        'scoreService: $scoreService, _gameType: $gameType}';
  }
}
