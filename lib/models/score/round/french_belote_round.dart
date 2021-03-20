import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:enum_to_string/enum_to_string.dart';

class FrenchBeloteRound extends BeloteRound {
  FrenchBeloteRound(
      {index,
      cardColor,
      contractFulfilled,
      dixDeDer,
      beloteRebelote,
      taker,
      defender,
      takerScore,
      defenderScore,
      usTrickScore,
      themTrickScore})
      : super(
            index: index,
            cardColor: cardColor,
            contractFulfilled: contractFulfilled,
            dixDeDer: dixDeDer,
            beloteRebelote: beloteRebelote,
            taker: taker,
            defender: defender,
            takerScore: takerScore,
            defenderScore: defenderScore,
            usTrickScore: usTrickScore,
            themTrickScore: themTrickScore);

  @override
  void computeRound() {
    if (contractFulfilled) {
      takerScore = getPointsOfTeam(taker) + getBeloteRebeloteOfTeam(taker);
      defenderScore =
          getPointsOfTeam(defender) + getBeloteRebeloteOfTeam(defender);
    } else {
      takerScore = getBeloteRebeloteOfTeam(taker);
      defenderScore =
          BeloteRound.totalScore + getBeloteRebeloteOfTeam(defender);
    }
    notifyListeners();
  }

  @override
  bool get contractFulfilled => contractFulfilled = (beloteRebelote != null)
      ? getPointsOfTeam(taker) > 80
      : getPointsOfTeam(taker) > 90;

  @override
  int getPointsOfTeam(BeloteTeamEnum? team) {
    switch (team) {
      case BeloteTeamEnum.US:
        return usTrickScore + getDixDeDerOfTeam(BeloteTeamEnum.US);
      case BeloteTeamEnum.THEM:
        return themTrickScore + getDixDeDerOfTeam(BeloteTeamEnum.THEM);
      case null:
        return 0;
    }
  }

  @override
  Map<String, dynamic> toJSON() {
    return super.toJSON();
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
