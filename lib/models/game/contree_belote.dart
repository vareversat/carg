import 'package:carg/const.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/setting/contree_belote_game_setting.dart';
import 'package:carg/models/players/belote_players.dart';

class ContreeBelote extends Belote {
  ContreeBelote({
    super.id,
    GameType? gameType,
    DateTime? super.startingDate,
    super.endingDate,
    super.winner,
    bool? isEnded,
    BelotePlayers? players,
    super.notes,
    ContreeBeloteGameSetting? settings,
  }) : super(
          gameType: GameType.CONTREE,
          players: players ?? BelotePlayers(),
          isEnded: isEnded ?? false,
          settings: settings ??
              ContreeBeloteGameSetting(
                maxPoint: Const.defaultMaxPoints,
                isInfinite: false,
                addContractToScore: true,
              ),
        );

  factory ContreeBelote.fromJSON(Map<String, dynamic>? json, String id) {
    return ContreeBelote(
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
