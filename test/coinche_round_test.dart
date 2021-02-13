import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/contract_name.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoincheRound', () {
    final coincheRound = CoincheBeloteRound(
        contract: 100,
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        contractName: ContractName.NORMAL,
        usTrickScore: 110,
        themTrickScore: 52);

    test('Is contract fulfilled', () {
      expect(coincheRound.isContractFulfilled(), true);
    });

    test('Compute score - Set contract', () {
      coincheRound.dixDeDer = null;
      coincheRound.beloteRebelote = null;
      coincheRound.contractName = ContractName.NORMAL;
      coincheRound.contract = 90;
      expect(coincheRound.takerScore, 200);
      expect(coincheRound.defenderScore, 52);
    });

    test('Compute score - fulfilled', () {
      coincheRound.dixDeDer = null;
      coincheRound.beloteRebelote = null;
      coincheRound.contractName = ContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.takerScore, 210);
      expect(coincheRound.defenderScore, 52);
    });

    test('Compute score - fulfilled - BeloteRebelote - US', () {
      coincheRound.dixDeDer = null;
      coincheRound.beloteRebelote = BeloteTeamEnum.US;
      coincheRound.contractName = ContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.takerScore, 230);
      expect(coincheRound.defenderScore, 52);
    });

    test('Compute score - fulfilled - BeloteRebelote - THEM', () {
      coincheRound.dixDeDer = null;
      coincheRound.beloteRebelote = BeloteTeamEnum.THEM;
      coincheRound.contractName = ContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.takerScore, 210);
      expect(coincheRound.defenderScore, 72);
    });

    test('Compute score - fulfilled - Dix de Der - US', () {
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = ContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.takerScore, 220);
      expect(coincheRound.defenderScore, 52);
    });

    test('Compute score - fulfilled - Dix de Der - THEM', () {
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.THEM;
      coincheRound.contractName = ContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.takerScore, 210);
      expect(coincheRound.defenderScore, 62);
    });

    test('Compute score - Contract - Coinche', () {
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = null;
      coincheRound.contractName = ContractName.COINCHE;
      coincheRound.contract = 100;
      expect(coincheRound.takerScore, 420);
      expect(coincheRound.defenderScore, 52);
    });

    test('Compute score - Contract - Sur Coinche', () {
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = null;
      coincheRound.contractName = ContractName.SURCOINCHE;
      coincheRound.contract = 100;
      expect(coincheRound.takerScore, 840);
      expect(coincheRound.defenderScore, 52);
    });

    test('Compute score - failed', () {
      coincheRound.taker = BeloteTeamEnum.THEM;
      coincheRound.defender = BeloteTeamEnum.US;
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = null;
      coincheRound.contractName = ContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.takerScore, 0);
      expect(coincheRound.defenderScore, 260);
    });
  });
}
