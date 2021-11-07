import 'package:carg/models/score/misc/coinche_belote_contract_type.dart';
import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/misc/coinche_belote_contract_name.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:enum_to_string/enum_to_string.dart';

class CoincheBeloteRound extends BeloteRound {
  late int _contract;
  late CoincheBeloteContractName _contractName;
  late CoincheBeloteContractType _contractType;

  CoincheBeloteRound(
      {index,
      cardColor,
      contract,
      contractFulfilled,
      dixDeDer,
      beloteRebelote,
      taker,
      takerScore,
      defenderScore,
      usTrickScore,
      themTrickScore,
      contractName,
      contractType,
      defender})
      : super(
            index: index,
            cardColor: cardColor,
            contractFulfilled: contractFulfilled,
            dixDeDer: dixDeDer,
            beloteRebelote: beloteRebelote,
            taker: taker,
            takerScore: takerScore,
            defenderScore: defenderScore,
            usTrickScore: usTrickScore,
            themTrickScore: themTrickScore,
            defender: defender) {
    _contract = contract ?? 0;
    _contractName = contractName ?? CoincheBeloteContractName.NORMAL;
    _contractType = contractType ?? CoincheBeloteContractType.NORMAL;
  }

  @override
  bool get contractFulfilled {
    var totalTackerScore = getTrickPointsOfTeam(taker) +
        getDixDeDerOfTeam(taker) +
        getBeloteRebeloteOfTeam(taker);
    var totalDefenderScore = getTrickPointsOfTeam(defender) +
        getDixDeDerOfTeam(defender) +
        getBeloteRebeloteOfTeam(defender);
    if (contractType != CoincheBeloteContractType.FAILED_GENERALE) {
      return totalTackerScore >= contract &&
          totalTackerScore > totalDefenderScore;
    } else {
      return false;
    }
  }

  CoincheBeloteContractType get contractType => _contractType;

  set contractType(CoincheBeloteContractType value) {
    _contractType = value;
    if (value != CoincheBeloteContractType.NORMAL) {
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
  void computeRound() {
    var takerTrickPoints = getTrickPointsOfTeam(taker);
    var defenderTrickPoints = getTrickPointsOfTeam(defender);
    if (contractFulfilled) {
      var takerScoreTmp = takerTrickPoints +
          getDixDeDerOfTeam(taker) +
          getBeloteRebeloteOfTeam(taker) +
          contract;
      takerScore = roundScore(
          contractType.bonus(takerScoreTmp) * contractName.multiplier);
      defenderScore = roundScore(defenderTrickPoints +
          getDixDeDerOfTeam(defender) +
          getBeloteRebeloteOfTeam(defender));
    } else {
      var defenderScoreTmp = BeloteRound.totalScore +
          contractType.bonus(contract) +
          getBeloteRebeloteOfTeam(defender) +
          getDixDeDerOfTeam(defender);
      takerScore =
          roundScore(getBeloteRebeloteOfTeam(taker) + getDixDeDerOfTeam(taker));
      defenderScore = roundScore(defenderScoreTmp * contractName.multiplier);
    }
    notifyListeners();
  }

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
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({
      'contract': contract,
      'contract_name': EnumToString.convertToString(contractName),
      'contract_type': EnumToString.convertToString(contractType),
    });
    return tmpJSON;
  }

  factory CoincheBeloteRound.fromJSON(Map<String, dynamic> json) {
    return CoincheBeloteRound(
        index: json['index'],
        cardColor:
            EnumToString.fromString(CardColor.values, json['card_color']),
        dixDeDer:
            EnumToString.fromString(BeloteTeamEnum.values, json['dix_de_der']),
        beloteRebelote: EnumToString.fromString(
            BeloteTeamEnum.values, json['belote_rebelote'] ?? ''),
        contract: json['contract'],
        contractFulfilled: json['contract_fulfilled'],
        taker: EnumToString.fromString(BeloteTeamEnum.values, json['taker']),
        defender:
            EnumToString.fromString(BeloteTeamEnum.values, json['defender']),
        takerScore: json['taker_score'],
        defenderScore: json['defender_score'],
        usTrickScore: json['us_trick_score'],
        themTrickScore: json['them_trick_score'],
        contractName: EnumToString.fromString(
            CoincheBeloteContractName.values, json['contract_name']),
        contractType: EnumToString.fromString(
            CoincheBeloteContractType.values, json['contract_type'] ?? ''));
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
        'contractType: $contractType,  \n}';
  }
}
