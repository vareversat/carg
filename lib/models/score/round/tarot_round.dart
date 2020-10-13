import 'package:carg/models/score/misc/tarot_contract.dart';
import 'package:carg/models/score/misc/tarot_perk.dart';
import 'package:carg/models/score/misc/tarot_poignee.dart';
import 'package:carg/models/score/round/round.dart';
import 'package:enum_to_string/enum_to_string.dart';

class TarotRound extends Round {
  String attackPlayer;
  List<String> defensePlayers;
  int attackScore;
  int defenseScore;
  int boutCount;
  String playerCalled;
  TarotContract tarotContract;
  TarotPerk tarotPerk;
  TarotPoignee tarotPoignee;

  TarotRound(
      {index,
      this.attackPlayer,
      this.boutCount,
      this.defensePlayers,
      this.attackScore,
      this.defenseScore,
      this.playerCalled,
      this.tarotContract,
      this.tarotPerk,
      this.tarotPoignee})
      : super(index: index);

  Map<String, dynamic> toJSON() {
    return {
      'index': index,
      'attack_player': attackPlayer,
      'bout_count': boutCount,
      'defense_players': defensePlayers,
      'attack_score': attackScore,
      'defense_score': defenseScore,
      'player_called': playerCalled,
      'tarot_poignee': EnumToString.convertToString(tarotPoignee),
      'tarot_contract': EnumToString.convertToString(tarotContract),
      'tarot_perk': EnumToString.convertToString(tarotPerk)
    };
  }

  factory TarotRound.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return TarotRound(
        index: json['index'],
        attackPlayer: json['attack_player'],
        boutCount: json['bout_count'],
        defensePlayers: json['defense_players'],
        attackScore: json['attack_score'],
        defenseScore: json['defense_score'],
        playerCalled: json['player_called'],
        tarotPoignee:
            EnumToString.fromString(TarotPoignee.values, json['tarot_poignee']),
        tarotContract: EnumToString.fromString(
            TarotContract.values, json['tarot_contract']),
        tarotPerk:
            EnumToString.fromString(TarotPerk.values, json['tarot_perk']));
  }

  static List<TarotRound> fromJSONList(List<dynamic> jsonList) {
    return jsonList.map((json) => TarotRound.fromJSON(json)).toList();
  }

  @override
  String toString() {
    return 'TarotRound{attackPlayer: $attackPlayer, endCount: $boutCount, defensePlayers: $defensePlayers, attackScore: $attackScore, defenseScore: $defenseScore, playerCalled: $playerCalled, contract: $tarotContract, tarotPerk: $tarotPerk}';
  }

  @override
  void computeRound() {
    // TODO: implement computeRound
  }

  @override
  String realTimeDisplay() {
    // TODO: implement realTimeDisplay
    throw UnimplementedError();
  }
}
