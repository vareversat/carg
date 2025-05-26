import 'package:carg/models/game/setting/contree_belote_game_setting.dart';
import 'package:carg/models/score/misc/belote_contract_type.dart';
import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/contree_belote_contract_name.dart';
import 'package:carg/models/score/round/contree_belote_round.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final gameSettingAddToContract = ContreeBeloteGameSetting(
      maxPoint: 1000, isInfinite: false, sumTrickPointsAndContract: true);
  final gameSettingNoAddToContract = ContreeBeloteGameSetting(
      maxPoint: 1000, isInfinite: false, sumTrickPointsAndContract: false);

  group('ContreeRound', () {
    test('Is contract fulfilled', () {
      final contreeRound = ContreeBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          usTrickScore: 110,
          themTrickScore: 50,
          settings: gameSettingAddToContract);
      expect(contreeRound.contractFulfilled, true);
    });

    test('Compute score - Set contract', () {
      final contreeRound = ContreeBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          usTrickScore: 110,
          themTrickScore: 50,
          settings: gameSettingAddToContract);
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.beloteRebelote = null;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 90;
      expect(contreeRound.takerScore, 210);
      expect(contreeRound.defenderScore, 50);
    });

    test('Compute score - Set contract', () {
      final contreeRound = ContreeBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          usTrickScore: 110,
          themTrickScore: 50,
          settings: gameSettingNoAddToContract);
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.beloteRebelote = null;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 90;
      expect(contreeRound.takerScore, 90);
      expect(contreeRound.defenderScore, 0);
    });

    test('Compute score - fulfilled', () {
      final contreeRound = ContreeBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          usTrickScore: 110,
          themTrickScore: 50,
          settings: gameSettingAddToContract);
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.beloteRebelote = null;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.contractFulfilled, true);
      expect(contreeRound.takerScore, 220);
      expect(contreeRound.defenderScore, 50);
    });

    test('Compute score - fulfilled', () {
      final contreeRound = ContreeBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          usTrickScore: 110,
          themTrickScore: 50,
          settings: gameSettingNoAddToContract);
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.beloteRebelote = null;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.contractFulfilled, true);
      expect(contreeRound.takerScore, 100);
      expect(contreeRound.defenderScore, 0);
    });

    test('Compute score - fulfilled - BeloteRebelote - US', () {
      final contreeRound = ContreeBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          usTrickScore: 110,
          themTrickScore: 50,
          settings: gameSettingAddToContract);
      contreeRound.dixDeDer = BeloteTeamEnum.THEM;
      contreeRound.beloteRebelote = BeloteTeamEnum.US;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 120;
      expect(contreeRound.contractFulfilled, true);
      expect(contreeRound.takerScore, 250);
      expect(contreeRound.defenderScore, 60);
    });

    test('Compute score - fulfilled - BeloteRebelote - THEM', () {
      final contreeRound = ContreeBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          usTrickScore: 110,
          themTrickScore: 50,
          settings: gameSettingAddToContract);
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.beloteRebelote = BeloteTeamEnum.THEM;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.contractFulfilled, true);
      expect(contreeRound.takerScore, 220);
      expect(contreeRound.defenderScore, 70);
    });

    test('Compute score - fulfilled - Dix de Der - US', () {
      final contreeRound = ContreeBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          usTrickScore: 110,
          themTrickScore: 50,
          settings: gameSettingAddToContract);
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.contractFulfilled, true);
      expect(contreeRound.takerScore, 220);
      expect(contreeRound.defenderScore, 50);
    });

    test('Compute score - fulfilled - Dix de Der - THEM', () {
      final contreeRound = ContreeBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          usTrickScore: 110,
          themTrickScore: 50,
          settings: gameSettingAddToContract);
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.THEM;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.contractFulfilled, true);
      expect(contreeRound.takerScore, 210);
      expect(contreeRound.defenderScore, 60);
    });

    test('Compute score - Contract - Contre', () {
      final contreeRound = ContreeBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          usTrickScore: 110,
          themTrickScore: 50,
          settings: gameSettingAddToContract);
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.contractName = ContreeBeloteContractName.CONTRE;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.contractFulfilled, true);
      expect(contreeRound.takerScore, 440);
      expect(contreeRound.defenderScore, 50);
    });

    test('Compute score - Contract - Sur Contré', () {
      final contreeRound = ContreeBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          usTrickScore: 110,
          themTrickScore: 50,
          settings: gameSettingAddToContract);
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.contractName = ContreeBeloteContractName.SURCONTRE;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.takerScore, 880);
      expect(contreeRound.defenderScore, 50);
    });

    test('Compute score - failed', () {
      final contreeRound = ContreeBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          usTrickScore: 110,
          themTrickScore: 50,
          settings: gameSettingAddToContract);
      contreeRound.taker = BeloteTeamEnum.THEM;
      contreeRound.defender = BeloteTeamEnum.US;
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.contractFulfilled, false);
      expect(contreeRound.takerScore, 0);
      expect(contreeRound.defenderScore, 370);
    });

    test('Compute score - fulfilled - Dix de Der - US - Capot', () {
      final contreeRound = ContreeBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          usTrickScore: 110,
          themTrickScore: 50,
          settings: gameSettingAddToContract);
      contreeRound.taker = BeloteTeamEnum.US;
      contreeRound.defender = BeloteTeamEnum.THEM;
      contreeRound.usTrickScore = 152;
      contreeRound.themTrickScore = 0;
      contreeRound.beloteRebelote = BeloteTeamEnum.THEM;
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.CAPOT;
      expect(contreeRound.contractFulfilled, true);
      expect(contreeRound.contract, 162);
      expect(contreeRound.takerScore, 250);
      expect(contreeRound.defenderScore, 20);
    });

    test('Compute score - fulfilled - Dix de Der - US - Capot failed', () {
      final contreeRound = ContreeBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          usTrickScore: 110,
          themTrickScore: 50,
          settings: gameSettingAddToContract);
      contreeRound.taker = BeloteTeamEnum.US;
      contreeRound.defender = BeloteTeamEnum.THEM;
      contreeRound.usTrickScore = 140;
      contreeRound.themTrickScore = 12;
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.CAPOT;
      expect(contreeRound.contractFulfilled, false);
      expect(contreeRound.contract, 162);
      expect(contreeRound.takerScore, 0);
      expect(contreeRound.defenderScore, 420);
    });

    test('Compute score - fulfilled - Dix de Der - US - Generale', () {
      final contreeRound = ContreeBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          usTrickScore: 110,
          themTrickScore: 50,
          settings: gameSettingAddToContract);
      contreeRound.taker = BeloteTeamEnum.US;
      contreeRound.defender = BeloteTeamEnum.THEM;
      contreeRound.usTrickScore = 152;
      contreeRound.themTrickScore = 0;
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.GENERALE;
      expect(contreeRound.contractFulfilled, true);
      expect(contreeRound.contract, 162);
      expect(contreeRound.takerScore, 500);
      expect(contreeRound.defenderScore, 0);
    });

    test('Compute score - fulfilled - Dix de Der - US - Failed generale', () {
      final contreeRound = ContreeBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          usTrickScore: 110,
          themTrickScore: 50,
          settings: gameSettingAddToContract);
      contreeRound.taker = BeloteTeamEnum.US;
      contreeRound.defender = BeloteTeamEnum.THEM;
      contreeRound.usTrickScore = 152;
      contreeRound.themTrickScore = 0;
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.FAILED_GENERALE;
      expect(contreeRound.contractFulfilled, false);
      expect(contreeRound.contract, 162);
      expect(contreeRound.takerScore, 0);
      expect(contreeRound.defenderScore, 660);
    });
  });
}
