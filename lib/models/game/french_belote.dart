import 'package:carg/const.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/setting/french_belote_game_setting.dart';
import 'package:carg/models/players/belote_players.dart';

class FrenchBelote extends Belote {
  FrenchBelote(
      {super.id,
      GameType? gameType,
      DateTime? startingDate,
      super.endingDate,
      super.winner,
      bool? isEnded,
      BelotePlayers? players,
      super.notes,
      FrenchBeloteGameSetting? settings})
      : super(
          gameType: gameType ?? GameType.BELOTE,
          players: players ?? BelotePlayers(),
          startingDate: startingDate ?? DateTime.now(),
          isEnded: isEnded ?? false,
          settings: settings ??
              FrenchBeloteGameSetting(
                maxPoint: Const.defaultMaxPoints,
                isInfinite: false,
                addContractToScore: false,
              ),
        );


  factory FrenchBelote.fromJSON(Map<String, dynamic>? json, String id) {
    return FrenchBelote(
        id: id,
        startingDate: DateTime.parse(json?['starting_date']),
        endingDate: json?['ending_date'] != null
            ? DateTime.parse(json?['ending_date'])
            : null,
        isEnded: json?['is_ended'],
        players: BelotePlayers.fromJSON(json?['players']),
        winner: json?['winners'],
        notes: json?['notes']);
  }
}
