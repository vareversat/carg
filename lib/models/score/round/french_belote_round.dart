import 'package:carg/models/score/misc/belote_special_round.dart';
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
    super.beloteSpecialRound,
    super.beloteSpecialRoundPlayer,
    super.isManualMode,
  });

  @override
  int computeDefenderRound() {
    int score = getBeloteRebeloteOfTeam(defender);
    if (!contractFulfilled) {
      score += BeloteRound.totalScore;
    } else {
      score += getDixDeDerOfTeam(defender) + getTrickPointsOfTeam(defender);
    }
    return roundScore(score);
  }

  @override
  int computeTakerRound() {
    int score = getBeloteRebeloteOfTeam(taker);
    if (contractFulfilled) {
      score += getDixDeDerOfTeam(taker) + getTrickPointsOfTeam(taker);
    }
    return roundScore(score);
  }

  @override
  bool get contractFulfilled {
    if (!isManualMode) {
      return getTrickPointsOfTeam(taker) +
              getDixDeDerOfTeam(taker) +
              getBeloteRebeloteOfTeam(taker) >
          getTrickPointsOfTeam(defender) +
              getDixDeDerOfTeam(defender) +
              getBeloteRebeloteOfTeam(defender);
    } else {
      return takerScore > BeloteRound.totalScore / 2;
    }
  }

  @override
  String getRoundWidgetCentralElement() {
    return cardColor.symbol;
  }

  factory FrenchBeloteRound.specialRound(
    BeloteSpecialRound beloteSpecialRound,
    String playerID,
  ) {
    return FrenchBeloteRound(
      defenderScore: 0,
      beloteSpecialRound: beloteSpecialRound,
      beloteSpecialRoundPlayer: playerID,
    );
  }

  factory FrenchBeloteRound.fromJSON(Map<String, dynamic> json) {
    return FrenchBeloteRound(
      index: json['index'],
      cardColor: EnumToString.fromString(CardColor.values, json['card_color']),
      dixDeDer: EnumToString.fromString(
        BeloteTeamEnum.values,
        json['dix_de_der'],
      ),
      beloteRebelote: EnumToString.fromString(
        BeloteTeamEnum.values,
        json['belote_rebelote'] ?? '',
      ),
      contractFulfilled: json['contract_fulfilled'],
      taker: EnumToString.fromString(BeloteTeamEnum.values, json['taker']),
      defender: EnumToString.fromString(
        BeloteTeamEnum.values,
        json['defender'],
      ),
      takerScore: json['taker_score'],
      defenderScore: json['defender_score'],
      usTrickScore: json['us_trick_score'],
      themTrickScore: json['them_trick_score'],
      beloteSpecialRound: EnumToString.fromString(
        BeloteSpecialRound.values,
        json['belote_special_round'] ?? '',
      ),
      beloteSpecialRoundPlayer: json['belote_special_round_player'],
      isManualMode: json['is_manual_mode'],
    );
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
        'isManualMode: $isManualMode, '
        'themTrickScore: $themTrickScore}';
  }
}
