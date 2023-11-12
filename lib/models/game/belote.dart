import 'package:carg/models/game/game.dart';
import 'package:carg/models/players/belote_players.dart';

abstract class Belote<T extends BelotePlayers> extends Game<T> {
  Belote({
    super.id,
    super.gameType,
    super.startingDate,
    super.endingDate,
    super.winner,
    super.isEnded,
    super.notes,
    super.players,
  });

  @override
  Map<String, dynamic> toJSON() {
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({'players': players!.toJSON()});

    return tmpJSON;
  }
}
