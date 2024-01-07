import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:enum_to_string/enum_to_string.dart';

class FrenchBeloteRound extends BeloteRound {
  FrenchBeloteRound({
    super.index,
    super.cardColor,
    super.contractFulfilled,
    super.dixDeDer,
    super.beloteRebelote,
    super.taker,
    super.defender,
    super.takerScore,
    super.defenderScore,
    super.usTrickScore,
    super.themTrickScore,
    super.settings,
  });

  @override
  void computeRound() {
    if (contractFulfilled) {
      takerScore = roundScore(getTotalPointsOfTeam(taker));
      defenderScore = roundScore(getTotalPointsOfTeam(defender));
    } else {
      takerScore = roundScore(getBeloteRebeloteOfTeam(taker));
      defenderScore = roundScore(
          BeloteRound.totalScore + getBeloteRebeloteOfTeam(defender));
    }
    notifyListeners();
  }

  @override
  bool get contractFulfilled {
    return getTrickPointsOfTeam(taker) +
            getDixDeDerOfTeam(taker) +
            getBeloteRebeloteOfTeam(taker) >
        getTrickPointsOfTeam(defender) +
            getDixDeDerOfTeam(defender) +
            getBeloteRebeloteOfTeam(defender);
  }

  factory FrenchBeloteRound.fromJSON(Map<String, dynamic> json) {
    return FrenchBeloteRound(
        index: json['index'],
        cardColor:
            EnumToString.fromString(CardColor.values, json['card_color']),
        dixDeDer:
            EnumToString.fromString(BeloteTeamEnum.values, json['dix_de_der']),
        beloteRebelote: EnumToString.fromString(
            BeloteTeamEnum.values, json['belote_rebelote'] ?? ''),
        contractFulfilled: json['contract_fulfilled'],
        taker: EnumToString.fromString(BeloteTeamEnum.values, json['taker']),
        defender:
            EnumToString.fromString(BeloteTeamEnum.values, json['defender']),
        takerScore: json['taker_score'],
        defenderScore: json['defender_score'],
        usTrickScore: json['us_trick_score'],
        themTrickScore: json['them_trick_score']);
  }

  static List<FrenchBeloteRound> fromJSONList(List<dynamic> jsonList) {
    return jsonList.map((json) => FrenchBeloteRound.fromJSON(json)).toList();
  }

  @override
  String toString() {
    return 'BeloteRound{ '
        'index: $index, '
        'cardColor: $cardColor, '
        'dixDeDer: $dixDeDer, '
        'beloteRebelote: $beloteRebelote, '
        'contractFulfilled: $contractFulfilled, '
        'taker: $taker, '
        'defender: $defender, '
        'takerScore: $takerScore, '
        'defenderScore: $defenderScore, '
        'usTrickScore: $usTrickScore, '
        'themTrickScore: $themTrickScore}';
  }
}
