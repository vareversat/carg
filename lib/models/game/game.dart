import 'package:carg/models/carg_object.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/player/players.dart';
import 'package:carg/services/game/game_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

abstract class Game extends CargObject {
  DateTime startingDate;
  DateTime endingDate;
  bool isEnded;
  String winner;
  Players players;
  GameType gameType;
  GameService gameService;

  Game(
      {String id,
      @required this.gameType,
      @required this.gameService,
      this.players,
      this.startingDate,
      this.endingDate,
      this.winner,
      this.isEnded = false})
      : super(id: id);

  @override
  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'starting_date': DateFormat('yyyy-MM-ddTHH:mm:ss').format(startingDate),
      'ending_date': endingDate != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss').format(endingDate)
          : null,
      'is_ended': isEnded,
      'winners': winner
    };
  }

  @override
  String toString() {
    return 'Game{startingDate: $startingDate, endingDate: $endingDate, isEnded: $isEnded, winner: $winner, players: $players, gameType: $gameType, gameService: $gameService}';
  }
}
