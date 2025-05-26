import 'package:carg/const.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/setting/tarot_game_setting.dart';
import 'package:carg/models/players/tarot_players.dart';

class Tarot extends Game<TarotPlayers, TarotGameSetting> {
  Tarot({
    super.id,
    DateTime? startingDate,
    super.endingDate,
    super.winner,
    bool? isEnded,
    TarotPlayers? players,
    super.notes,
    GameType? gameType,
    TarotGameSetting? settings,
  }) : super(
         gameType: gameType ?? GameType.TAROT,
         players: players ?? TarotPlayers(),
         startingDate: startingDate ?? DateTime.now(),
         isEnded: isEnded ?? false,
         settings:
             settings ??
             TarotGameSetting(
               maxPoint: Const.defaultMaxPoints,
               isInfinite: false,
             ),
       );

  @override
  Map<String, dynamic> toJSON() {
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({'players': players!.toJSON()});
    return tmpJSON;
  }

  factory Tarot.fromJSON(Map<String, dynamic>? json, String id) {
    return Tarot(
      id: id,
      startingDate: DateTime.parse(json?['starting_date']),
      endingDate: json?['ending_date'] != null
          ? DateTime.parse(json?['ending_date'])
          : null,
      isEnded: json?['is_ended'],
      winner: json?['winner'],
      players: TarotPlayers.fromJSON(json?['players']),
      notes: json?['notes'],
      settings: json?['settings'] != null
          ? TarotGameSetting.fromJSON(json?['settings'])
          : null,
    );
  }
}
