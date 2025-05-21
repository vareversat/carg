import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/setting/belote_game_setting.dart';
import 'package:carg/models/players/belote_players.dart';

abstract class Belote<T extends BelotePlayers, S extends BeloteGameSetting>
    extends Game<T, S> {
  Belote({
    super.id,
    super.gameType,
    super.startingDate,
    super.endingDate,
    super.winner,
    super.isEnded,
    super.notes,
    super.players,
    required super.settings,
  });

  @override
  Map<String, dynamic> toJSON() {
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({'players': players!.toJSON()});
    return tmpJSON;
  }
}
