import 'package:carg/models/score/misc/belote_contract_type.dart';
import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/misc/contree_belote_contract_name.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:enum_to_string/enum_to_string.dart';

class ContreeBeloteRound extends BeloteRound {
  late int _contract;
  late ContreeBeloteContractName _contractName;
  late BeloteContractType _contractType;

  ContreeBeloteRound({
    super.index,
    CardColor? super.cardColor,
    bool? super.contractFulfilled,
    BeloteTeamEnum? super.dixDeDer,
    BeloteTeamEnum? super.beloteRebelote,
    BeloteTeamEnum? super.taker,
    BeloteTeamEnum? super.defender,
    int? super.takerScore,
    int? super.defenderScore,
    int? super.usTrickScore,
    int? super.themTrickScore,
    int? contract,
    ContreeBeloteContractName? contractName,
    BeloteContractType? contractType,
  }) {
    _contract = contract ?? 0;
    _contractName = contractName ?? ContreeBeloteContractName.NORMAL;
    _contractType = contractType ?? BeloteContractType.NORMAL;
  }

  @override
  bool get contractFulfilled {
    var totalTackerScore = getTrickPointsOfTeam(taker) +
        getDixDeDerOfTeam(taker) +
        getBeloteRebeloteOfTeam(taker);
    var totalDefenderScore = getTrickPointsOfTeam(defender) +
        getDixDeDerOfTeam(defender) +
        getBeloteRebeloteOfTeam(defender);

    return contractType != BeloteContractType.FAILED_GENERALE
        ? totalTackerScore >= contract && totalTackerScore > totalDefenderScore
        : false;
  }

  BeloteContractType get contractType => _contractType;

  set contractType(BeloteContractType value) {
    _contractType = value;
    if (value != BeloteContractType.NORMAL) {
      contract = BeloteRound.totalScore;
    }
    computeRound();
  }

  ContreeBeloteContractName get contractName => _contractName;

  set contractName(ContreeBeloteContractName value) {
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
        contractType.bonus(takerScoreTmp) * contractName.multiplier,
      );
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

  factory ContreeBeloteRound.fromJSON(Map<String, dynamic> json) {
    return ContreeBeloteRound(
      index: json['index'],
      cardColor: EnumToString.fromString(CardColor.values, json['card_color']),
      dixDeDer:
          EnumToString.fromString(BeloteTeamEnum.values, json['dix_de_der']),
      beloteRebelote: EnumToString.fromString(
        BeloteTeamEnum.values,
        json['belote_rebelote'] ?? '',
      ),
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
        ContreeBeloteContractName.values,
        json['contract_name'],
      ),
      contractType: EnumToString.fromString(
        BeloteContractType.values,
        json['contract_type'] ?? '',
      ),
    );
  }

  static List<ContreeBeloteRound> fromJSONList(List<dynamic> jsonList) {
    return jsonList.map((json) => ContreeBeloteRound.fromJSON(json)).toList();
  }

  @override
  String toString() {
    return 'ContreeBeloteRound{ '
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
        'contractType: $contractType, '
        'defender: $defender}';
  }
}
