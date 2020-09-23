import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/misc/team_game_enum.dart';
import 'package:carg/models/score/round/team_game_round.dart';
import 'package:enum_to_string/enum_to_string.dart';

class BeloteRound extends TeamGameRound {
  BeloteRound(
      {index,
      cardColor,
      contractFulfilled,
      dixDeDer,
      beloteRebelote,
      taker,
      takerScore,
      defenderScore})
      : super(
            index: index,
            cardColor: cardColor,
            contractFulfilled: contractFulfilled,
            dixDeDer: dixDeDer,
            beloteRebelote: beloteRebelote,
            taker: taker,
            takerScore: takerScore,
            defenderScore: defenderScore);

  @override
  Map<String, dynamic> toJSON() {
    return super.toJSON();
  }

  factory BeloteRound.fromJSON(Map<dynamic, dynamic> json) {
    if (json == null) {
      return null;
    }
    return BeloteRound(
        index: json['index'],
        cardColor:
            EnumToString.fromString(CardColor.values, json['card_color']),
        dixDeDer:
            EnumToString.fromString(TeamGameEnum.values, json['dix_de_der']),
        beloteRebelote: EnumToString.fromString(
            TeamGameEnum.values, json['belote_rebelote']),
        contractFulfilled: json['contract_fulfilled'],
        taker: EnumToString.fromString(TeamGameEnum.values, json['taker']),
        takerScore: json['taker_score'],
        defenderScore: json['defender_score']);
  }

  static List<BeloteRound> fromJSONList(List<dynamic> jsonList) {
    if (jsonList != null) {
      return jsonList.map((json) => BeloteRound.fromJSON(json)).toList();
    }
    return [];
  }

  @override
  String toString() {
    return 'BeloteRound{cardColor: $cardColor, dixDeDer: $dixDeDer, beloteRebelote: $beloteRebelote, contractFulfilled: $contractFulfilled, taker: $taker, takerScore: $takerScore, defenderScore: $defenderScore}';
  }
}
