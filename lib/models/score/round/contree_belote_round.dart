import 'package:carg/models/score/misc/belote_contract_type.dart';
import 'package:carg/models/score/misc/belote_special_round.dart';
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
    int? contract,
    ContreeBeloteContractName? contractName,
    BeloteContractType? contractType,
    super.beloteSpecialRound,
    super.beloteSpecialRoundPlayer,
  }) {
    _contract = contract ?? 0;
    _contractName = contractName ?? ContreeBeloteContractName.NORMAL;
    _contractType = contractType ?? BeloteContractType.NORMAL;
  }

  @override
  bool get contractFulfilled {
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
    if (contractFulfilled) {
      var takerScoreTmp = getTotalPointsOfTeam(taker) + contract;
      var defenderScoreTmp = getTotalPointsOfTeam(defender);
      takerScore = roundScore(
        contractType.bonus(takerScoreTmp) * contractName.multiplier,
      );
      defenderScore = roundScore(defenderScoreTmp);
    } else {
      var defenderScoreTmp =
          BeloteRound.totalScore +
          contractType.bonus(contract) +
          getBeloteRebeloteOfTeam(defender) +
          getDixDeDerOfTeam(defender);
      takerScore = roundScore(
        getBeloteRebeloteOfTeam(taker) + getDixDeDerOfTeam(taker),
      );
      defenderScore = roundScore(defenderScoreTmp * contractName.multiplier);
    }
    notifyListeners();
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

  factory ContreeBeloteRound.specialRound(
    BeloteSpecialRound beloteSpecialRound,
    String playerID,
  ) {
    return ContreeBeloteRound(
      defenderScore: 0,
      beloteSpecialRound: beloteSpecialRound,
      beloteSpecialRoundPlayer: playerID,
    );
  }

  factory ContreeBeloteRound.fromJSON(Map<String, dynamic> json) {
    return ContreeBeloteRound(
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
        ContreeBeloteContractName.values,
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
