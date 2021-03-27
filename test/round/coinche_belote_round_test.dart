import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/coinche_belote_contract_name.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoincheRound', () {
    final coincheRound = CoincheBeloteRound(
        contract: 100,
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        contractName: CoincheBeloteContractName.NORMAL,
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
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.beloteRebelote = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.contractFulfilled, true);
      expect(coincheRound.takerScore, 240);
      expect(coincheRound.defenderScore, 50);
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
  });
}
