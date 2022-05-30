import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/coinche_belote_contract_name.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:carg/models/score/misc/belote_contract_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoincheRound', () {
    final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50);

    test('Is contract fulfilled', () {
      expect(coincheRound.contractFulfilled, true);
    });

    test('Compute score - Set contract', () {
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.beloteRebelote = null;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 90;
      expect(coincheRound.takerScore, 210);
      expect(coincheRound.defenderScore, 50);
    });

    test('Compute score - fulfilled', () {
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.beloteRebelote = null;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.contractFulfilled, true);
      expect(coincheRound.takerScore, 220);
      expect(coincheRound.defenderScore, 50);
    });

    test('Compute score - fulfilled - BeloteRebelote - US', () {
      coincheRound.dixDeDer = BeloteTeamEnum.THEM;
      coincheRound.beloteRebelote = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 120;
      expect(coincheRound.contractFulfilled, true);
      expect(coincheRound.takerScore, 250);
      expect(coincheRound.defenderScore, 60);
    });

    test('Compute score - fulfilled - BeloteRebelote - THEM', () {
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.beloteRebelote = BeloteTeamEnum.THEM;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.contractFulfilled, true);
      expect(coincheRound.takerScore, 220);
      expect(coincheRound.defenderScore, 70);
    });

    test('Compute score - fulfilled - Dix de Der - US', () {
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.contractFulfilled, true);
      expect(coincheRound.takerScore, 220);
      expect(coincheRound.defenderScore, 50);
    });

    test('Compute score - fulfilled - Dix de Der - THEM', () {
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.THEM;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.contractFulfilled, true);
      expect(coincheRound.takerScore, 210);
      expect(coincheRound.defenderScore, 60);
    });

    test('Compute score - Contract - Coinche', () {
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.COINCHE;
      coincheRound.contract = 100;
      expect(coincheRound.takerScore, 440);
      expect(coincheRound.defenderScore, 50);
    });

    test('Compute score - Contract - Sur Coinche', () {
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.SURCOINCHE;
      coincheRound.contract = 100;
      expect(coincheRound.takerScore, 880);
      expect(coincheRound.defenderScore, 50);
    });

    test('Compute score - failed', () {
      coincheRound.taker = BeloteTeamEnum.THEM;
      coincheRound.defender = BeloteTeamEnum.US;
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.contractFulfilled, false);
      expect(coincheRound.takerScore, 0);
      expect(coincheRound.defenderScore, 270);
    });

    test('Compute score - fulfilled - Dix de Der - US - Capot', () {
      coincheRound.taker = BeloteTeamEnum.US;
      coincheRound.defender = BeloteTeamEnum.THEM;
      coincheRound.usTrickScore = 152;
      coincheRound.themTrickScore = 0;
      coincheRound.beloteRebelote = BeloteTeamEnum.THEM;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contractType = BeloteContractType.CAPOT;
      expect(coincheRound.contractFulfilled, true);
      expect(coincheRound.contract, 162);
      expect(coincheRound.takerScore, 250);
      expect(coincheRound.defenderScore, 20);
    });

    test('Compute score - fulfilled - Dix de Der - US - Capot failed', () {
      coincheRound.taker = BeloteTeamEnum.US;
      coincheRound.defender = BeloteTeamEnum.THEM;
      coincheRound.usTrickScore = 140;
      coincheRound.themTrickScore = 12;
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contractType = BeloteContractType.CAPOT;
      expect(coincheRound.contractFulfilled, false);
      expect(coincheRound.contract, 162);
      expect(coincheRound.takerScore, 10);
      expect(coincheRound.defenderScore, 410);
    });

    test('Compute score - fulfilled - Dix de Der - US - Generale', () {
      coincheRound.taker = BeloteTeamEnum.US;
      coincheRound.defender = BeloteTeamEnum.THEM;
      coincheRound.usTrickScore = 152;
      coincheRound.themTrickScore = 0;
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contractType = BeloteContractType.GENERALE;
      expect(coincheRound.contractFulfilled, true);
      expect(coincheRound.contract, 162);
      expect(coincheRound.takerScore, 500);
      expect(coincheRound.defenderScore, 0);
    });

    test('Compute score - fulfilled - Dix de Der - US - Failed generale', () {
      coincheRound.taker = BeloteTeamEnum.US;
      coincheRound.defender = BeloteTeamEnum.THEM;
      coincheRound.usTrickScore = 152;
      coincheRound.themTrickScore = 0;
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contractType = BeloteContractType.FAILED_GENERALE;
      expect(coincheRound.contractFulfilled, false);
      expect(coincheRound.contract, 162);
      expect(coincheRound.takerScore, 10);
      expect(coincheRound.defenderScore, 660);
    });
  });
}
