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
    var takerTrickPoints = getTrickPointsOfTeam(taker);
    var defenderTrickPoints = getTrickPointsOfTeam(defender);
    if (contractFulfilled) {
      takerScore = roundScore(takerTrickPoints +
          getDixDeDerOfTeam(taker, takerTrickPoints) +
          getBeloteRebeloteOfTeam(taker));
      defenderScore = roundScore(defenderTrickPoints +
          getDixDeDerOfTeam(defender, defenderTrickPoints) +
          getBeloteRebeloteOfTeam(defender));
    } else {
      takerScore = roundScore(getBeloteRebeloteOfTeam(taker));
      defenderScore = roundScore(BeloteRound.totalTrickScore +
          getDixDeDerOfTeam(defender, defenderTrickPoints) +
          getBeloteRebeloteOfTeam(defender));
    }
    notifyListeners();
  }

  @override
  bool get contractFulfilled => contractFulfilled =
      getTrickPointsOfTeam(taker) + getDixDeDerOfTeam(taker, 0) >= 80;

  @override
  int getTrickPointsOfTeam(BeloteTeamEnum? team) {
    switch (team) {
      case BeloteTeamEnum.US:
        return usTrickScore;
      case BeloteTeamEnum.THEM:
        return themTrickScore;
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
