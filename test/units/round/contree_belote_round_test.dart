import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/coinche_belote_contract_name.dart';
import 'package:carg/models/score/round/contree_belote_round.dart';
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
      contreeRound.contractName = CoincheBeloteContractName.NORMAL;
      contreeRound.contract = 90;
      expect(contreeRound.takerScore, 210);
      expect(contreeRound.defenderScore, 50);
    });

    test('Compute score - fulfilled', () {
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.beloteRebelote = null;
      contreeRound.contractName = CoincheBeloteContractName.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.contractFulfilled, true);
      expect(contreeRound.takerScore, 220);
      expect(contreeRound.defenderScore, 50);
    });

    test('Compute score - fulfilled - BeloteRebelote - US', () {
      contreeRound.dixDeDer = BeloteTeamEnum.THEM;
      contreeRound.beloteRebelote = BeloteTeamEnum.US;
      contreeRound.contractName = CoincheBeloteContractName.NORMAL;
      contreeRound.contract = 120;
      expect(contreeRound.contractFulfilled, true);
      expect(contreeRound.takerScore, 250);
      expect(contreeRound.defenderScore, 60);
    });

    test('Compute score - fulfilled - BeloteRebelote - THEM', () {
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.beloteRebelote = BeloteTeamEnum.THEM;
      contreeRound.contractName = CoincheBeloteContractName.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.contractFulfilled, true);
      expect(contreeRound.takerScore, 220);
      expect(contreeRound.defenderScore, 70);
    });

    test('Compute score - fulfilled - Dix de Der - US', () {
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.contractName = CoincheBeloteContractName.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.contractFulfilled, true);
      expect(contreeRound.takerScore, 220);
      expect(contreeRound.defenderScore, 50);
    });

    test('Compute score - fulfilled - Dix de Der - THEM', () {
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.THEM;
      contreeRound.contractName = CoincheBeloteContractName.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.contractFulfilled, true);
      expect(contreeRound.takerScore, 210);
      expect(contreeRound.defenderScore, 60);
    });

    test('Compute score - Contract - Contré', () {
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.contractName = CoincheBeloteContractName.COINCHE;
      contreeRound.contract = 100;
      expect(contreeRound.takerScore, 440);
      expect(contreeRound.defenderScore, 50);
    });

    test('Compute score - Contract - Sur Contré', () {
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.contractName = CoincheBeloteContractName.SURCOINCHE;
      contreeRound.contract = 100;
      expect(contreeRound.takerScore, 880);
      expect(contreeRound.defenderScore, 50);
    });

    test('Compute score - failed', () {
      contreeRound.taker = BeloteTeamEnum.THEM;
      contreeRound.defender = BeloteTeamEnum.US;
      contreeRound.beloteRebelote = null;
      contreeRound.dixDeDer = BeloteTeamEnum.US;
      contreeRound.contractName = CoincheBeloteContractName.NORMAL;
      contreeRound.contract = 100;
      expect(contreeRound.contractFulfilled, false);
      expect(contreeRound.takerScore, 0);
      expect(contreeRound.defenderScore, 270);
    });
  });
}
