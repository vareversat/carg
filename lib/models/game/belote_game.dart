import 'package:carg/models/game/game.dart';
import 'package:carg/models/players/belote_players.dart';

abstract class Belote<T extends BelotePlayers> extends Game<T> {
  Belote(
      {id,
      gameType,
      startingDate,
      endingDate,
      winner,
      isEnded,
      notes,
      T? players})
      : super(
            id: id,
            gameType: gameType,
            endingDate: endingDate,
            players: players,
            startingDate: startingDate,
            winner: winner,
            isEnded: isEnded,
            notes: notes);

  @override
  Map<String, dynamic> toJSON() {
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({'players': players!.toJSON()});
    return tmpJSON;
  }
}
