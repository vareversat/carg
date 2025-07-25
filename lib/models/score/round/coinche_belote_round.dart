import 'package:carg/models/score/misc/belote_contract_type.dart';
import 'package:carg/models/score/misc/belote_special_round.dart';
import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/misc/coinche_belote_contract_name.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:enum_to_string/enum_to_string.dart';

class CoincheBeloteRound<CoincheBeloteGameSetting> extends BeloteRound {
  late int _contract;
  late CoincheBeloteContractName _contractName;
  late BeloteContractType _contractType;

  CoincheBeloteRound({
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
    super.isManualMode,
    contract,
    CoincheBeloteContractName? contractName,
    BeloteContractType? contractType,
    super.beloteSpecialRound,
    super.beloteSpecialRoundPlayer,
  }) {
    _contract = contract ?? 0;
    _contractName = contractName ?? CoincheBeloteContractName.NORMAL;
    _contractType = contractType ?? BeloteContractType.NORMAL;
  }

  @override
  bool get contractFulfilled {
    if (!isManualMode) {
      var totalTackerScore =
          getTrickPointsOfTeam(taker) +
          getDixDeDerOfTeam(taker) +
          getBeloteRebeloteOfTeam(taker);
      var totalDefenderScore =
          getTrickPointsOfTeam(defender) +
          getDixDeDerOfTeam(defender) +
          getBeloteRebeloteOfTeam(defender);
      if (contractType != BeloteContractType.FAILED_GENERALE) {
        return totalTackerScore >= contract &&
            totalTackerScore > totalDefenderScore;
      } else {
        return false;
      }
    } else {
      return takerScore >= contract;
    }
  }

  BeloteContractType get contractType => _contractType;

  set contractType(BeloteContractType value) {
    _contractType = value;
    if (value != BeloteContractType.NORMAL) {
      contract = BeloteRound.totalScore;
    }
    computeRound();
  }

  CoincheBeloteContractName get contractName => _contractName;

  set contractName(CoincheBeloteContractName value) {
    _contractName = value;
    computeRound();
  }

  int get contract => _contract;

  set contract(int value) {
    _contract = value;
    computeRound();
  }

  @override
  int computeDefenderRound() {
    int score = getBeloteRebeloteOfTeam(defender);
    if (!contractFulfilled) {
      if (settings != null && settings!.sumTrickPointsAndContract) {
        score +=
            BeloteRound.totalScore +
            contractType.bonus(contract) +
            getTrickPointsOfTeam(defender);
      } else {
        score += contract;
      }
    } else {
      if (settings != null && settings!.sumTrickPointsAndContract) {
        score += getTrickPointsOfTeam(defender) + getDixDeDerOfTeam(defender);
      }
    }
    return roundScore(
      score * (!contractFulfilled ? contractName.multiplier : 1),
    );
  }

  @override
  int computeTakerRound() {
    int score = getBeloteRebeloteOfTeam(taker);
    if (contractFulfilled) {
      if (settings != null && settings!.sumTrickPointsAndContract) {
        score +=
            contract + getTrickPointsOfTeam(taker) + getDixDeDerOfTeam(taker);
      } else {
        score += contract;
      }
      score = contractType.bonus(score);
    }
    return roundScore(
      score * (contractFulfilled ? contractName.multiplier : 1),
    );
  }

  @override
  String getRoundWidgetCentralElement() {
    return contract.toString();
  }

  @override
  Map<String, dynamic> toJSON() {
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({
      'contract': contract,
      'contract_name': EnumToString.convertToString(contractName),
      'contract_type': EnumToString.convertToString(contractType),
    });
    return tmpJSON;
  }

  factory CoincheBeloteRound.specialRound(
    BeloteSpecialRound beloteSpecialRound,
    String playerID,
  ) {
    return CoincheBeloteRound(
      defenderScore: 0,
      beloteSpecialRound: beloteSpecialRound,
      beloteSpecialRoundPlayer: playerID,
    );
  }

  factory CoincheBeloteRound.fromJSON(Map<String, dynamic> json) {
    return CoincheBeloteRound(
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
      contract: json['contract'],
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
      contractName: EnumToString.fromString(
        CoincheBeloteContractName.values,
        json['contract_name'],
      ),
      contractType: EnumToString.fromString(
        BeloteContractType.values,
        json['contract_type'] ?? '',
      ),
      beloteSpecialRound: EnumToString.fromString(
        BeloteSpecialRound.values,
        json['belote_special_round'] ?? '',
      ),
      beloteSpecialRoundPlayer: json['belote_special_round_player'],
      isManualMode: json['is_manual_mode'],
    );
  }

  static List<CoincheBeloteRound> fromJSONList(List<dynamic> jsonList) {
    return jsonList.map((json) => CoincheBeloteRound.fromJSON(json)).toList();
  }

  @override
  String toString() {
    return 'CoincheRound{ '
        'index: $index, \n'
        'cardColor: $cardColor,  \n'
        'contract: $contract,  \n'
        'beloteRebelote : $beloteRebelote,  \n'
        'dixDeDer: $dixDeDer,  \n'
        'contractFulfilled: $contractFulfilled,  \n'
        'taker: $taker,  \n'
        'defender: $defender,  \n'
        'takerScore: $takerScore,  \n'
        'defenderScore: $defenderScore,  \n'
        'usTrickScore: $usTrickScore,  \n'
        'themTrickScore: $themTrickScore,  \n'
        'contractName: $contractName,  \n'
        'isManualMode: $isManualMode,  \n'
        'contractType: $contractType,  \n}';
  }
}
