import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/misc/team_game_enum.dart';
import 'package:carg/models/score/round/team_game_round.dart';
import 'package:enum_to_string/enum_to_string.dart';

class CoincheRound extends TeamGameRound {
  int contract;

  CoincheRound(
      {index,
      cardColor,
      this.contract,
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
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({'contract': contract});
    return tmpJSON;
  }

  factory CoincheRound.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return CoincheRound(
        index: json['index'],
        cardColor:
            EnumToString.fromString(CardColor.values, json['card_color']),
        dixDeDer:
            EnumToString.fromString(TeamGameEnum.values, json['dix_de_der']),
        beloteRebelote: EnumToString.fromString(
            TeamGameEnum.values, json['belote_rebelote']),
        contract: json['contract'],
        contractFulfilled: json['contract_fulfilled'],
        taker: EnumToString.fromString(TeamGameEnum.values, json['taker']),
        takerScore: json['taker_score'],
        defenderScore: json['defender_score']);
  }

  static List<CoincheRound> fromJSONList(List<dynamic> jsonList) {
    return jsonList.map((json) => CoincheRound.fromJSON(json)).toList();
  }

  @override
  String toString() {
    return 'CoincheRound{cardColor: $cardColor, contract: $contract, beloteRebelote : $beloteRebelote, dixDeDer: $dixDeDer, contractFulfilled: $contractFulfilled, taker: $taker, takerScore: $takerScore, defenderScore: $defenderScore}';
  }
}
