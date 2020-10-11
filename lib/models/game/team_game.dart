import 'package:carg/models/game/game.dart';
import 'package:carg/models/player/team_game_players.dart';
import 'package:flutter/cupertino.dart';

abstract class TeamGame extends Game {
  String us;
  String them;

  TeamGame(
      {id,
      @required gameType,
      @required gameService,
      @required scoreService,
      startingDate,
      endingDate,
      winner,
      isEnded,
      this.us,
      this.them})
      : super(
            id: id,
            gameType: gameType,
            startingDate: startingDate,
            endingDate: endingDate,
            players: TeamGamePlayers(),
            gameService: gameService,
            scoreService: scoreService,
            winner: winner,
            isEnded: isEnded);

  @override
  Map<String, dynamic> toJSON() {
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({'us': us, 'them': them});
    return tmpJSON;
  }
}
