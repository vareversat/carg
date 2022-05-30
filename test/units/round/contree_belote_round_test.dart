import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/contree_belote_contract_name.dart';
import 'package:carg/models/score/round/contree_belote_round.dart';
import 'package:carg/models/score/misc/belote_contract_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContreeRound', () {
    final contreeRound = ContreeBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50);

    test('Is contract fulfilled', () {
      expect(contreeRound.contractFulfilled, true);
    });

    test('Compute score - Set contract', () {
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.beloteRebelote = null;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 90;
      expect(contreeRound.takerScore, 210);
      expect(contreeRound.defenderScore, 50);
    });

    test('Compute score - fulfilled', () {
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.beloteRebelote = null;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.contractFulfilled, true);
      expect(contreeRound.takerScore, 220);
      expect(contreeRound.defenderScore, 50);
    });

    test('Compute score - fulfilled - BeloteRebelote - US', () {
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
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.THEM;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.contractFulfilled, true);
      expect(contreeRound.takerScore, 210);
      expect(contreeRound.defenderScore, 60);
    });

    test('Compute score - Contract - Contré', () {
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.contractName = ContreeBeloteContractName.CONTRE;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.takerScore, 440);
      expect(contreeRound.defenderScore, 50);
    });

    test('Compute score - Contract - Sur Contré', () {
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.contractName = ContreeBeloteContractName.SURCONTRE;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.takerScore, 880);
      expect(contreeRound.defenderScore, 50);
    });

    test('Compute score - failed', () {
      contreeRound.taker = BeloteTeamEnum.THEM;
      contreeRound.defender = BeloteTeamEnum.US;
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.contractName = ContreeBeloteContractName.NORMAL;
      contreeRound.contractType = BeloteContractType.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.contractFulfilled, false);
      expect(contreeRound.takerScore, 0);
      expect(contreeRound.defenderScore, 270);
    });

    test('Compute score - fulfilled - Dix de Der - US - Capot', () {
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
      expect(contreeRound.takerScore, 10);
      expect(contreeRound.defenderScore, 410);
    });

    test('Compute score - fulfilled - Dix de Der - US - Generale', () {
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
      expect(contreeRound.takerScore, 10);
      expect(contreeRound.defenderScore, 660);
    });
  });
}
