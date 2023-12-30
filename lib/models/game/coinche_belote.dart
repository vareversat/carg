import 'package:carg/const.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/setting/coinche_belote_game_setting.dart';
import 'package:carg/models/players/belote_players.dart';

class CoincheBelote extends Belote {
  CoincheBelote({
    super.id,
    GameType? gameType,
    DateTime? super.startingDate,
    super.endingDate,
    super.winner,
    bool? isEnded,
    BelotePlayers? players,
    super.notes,
    CoincheBeloteGameSetting? settings,
  }) : super(
          gameType: GameType.COINCHE,
          players: players ?? BelotePlayers(),
          isEnded: isEnded ?? false,
          settings: settings ??
              CoincheBeloteGameSetting(
                maxPoint: Const.defaultMaxPoints,
                addContractToScore: true,
              ),
        );

  factory CoincheBelote.fromJSON(Map<String, dynamic>? json, String id) {
    return CoincheBelote(
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
