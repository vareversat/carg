import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/misc/contract_name.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:enum_to_string/enum_to_string.dart';

class CoincheBeloteRound extends BeloteRound {
  int _contract;
  ContractName _contractName;

  CoincheBeloteRound({index,
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
    _contractName = contractName ?? ContractName.NORMAL;
  }

  ContractName get contractName => _contractName;

  set contractName(ContractName value) {
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
    if (isContractFulfilled()) {
      takerScore = contractName.bonus(
          contract + getPointsOfTeam(taker) + getBeloteRebeloteOfTeam(taker),
          contract);
      defenderScore =
          getPointsOfTeam(defender) + getBeloteRebeloteOfTeam(defender);
    } else {
      takerScore = getBeloteRebeloteOfTeam(taker);
      defenderScore = contractName.bonus(
          BeloteRound.totalScore + contract +
              getBeloteRebeloteOfTeam(defender),
          contract);
    }
    notifyListeners();
  }

  @override
  bool isContractFulfilled() {
    contractFulfilled = getPointsOfTeam(taker) >= contract;
    return contractFulfilled;
  }

  @override
  Map<String, dynamic> toJSON() {
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({
      'contract': contract,
      'contract_name': EnumToString.convertToString(contractName)
    });
    return tmpJSON;
  }

  factory CoincheBeloteRound.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return CoincheBeloteRound(
        index: json['index'],
        cardColor:
            EnumToString.fromString(CardColor.values, json['card_color']),
        dixDeDer:
            EnumToString.fromString(BeloteTeamEnum.values, json['dix_de_der']),
        beloteRebelote: EnumToString.fromString(
            BeloteTeamEnum.values, json['belote_rebelote']),
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
            ContractName.values, json['contract_name']));
  }

  static List<CoincheBeloteRound> fromJSONList(List<dynamic> jsonList) {
    return jsonList.map((json) => CoincheBeloteRound.fromJSON(json)).toList();
  }

  @override
  String toString() {
    return 'CoincheRound{ '
        'index: $index, '
        'cardColor: $cardColor, '
        'contract: $contract, '
        'beloteRebelote : $beloteRebelote, '
        'dixDeDer: $dixDeDer, '
        'contractFulfilled: $contractFulfilled, '
        'taker: $taker, '
        'takerScore: $takerScore, '
        'defenderScore: $defenderScore, '
        'usTrickScore: $usTrickScore, '
        'themTrickScore: $themTrickScore, '
        'contractName: $contractName, '
        'defender: $defender}';
  }
}
