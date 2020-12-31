import 'package:carg/models/score/misc/contract_name.dart';
import 'package:carg/models/score/misc/team_game_enum.dart';
import 'package:carg/models/score/round/coinche_round.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoincheRound', () {
    final coincheRound = CoincheRound(
        contract: 100,
        taker: TeamGameEnum.US,
        defender: TeamGameEnum.THEM,
        contractName: ContractName.NORMAL,
        usTrickScore: 110,
        themTrickScore: 52);

    test('Is contract fulfilled', () {
      expect(coincheRound.isContractFulfilled(), true);
    });

    test('Compute score - fulfilled', () {
      coincheRound.dixDeDer = null;
      expect(coincheRound.takerScore, 210);
      expect(coincheRound.defenderScore, 52);
    });

    test('Compute score - fulfilled - BeloteRebelote - US', () {
      coincheRound.dixDeDer = null;
      coincheRound.beloteRebelote = TeamGameEnum.US;
      expect(coincheRound.takerScore, 230);
      expect(coincheRound.defenderScore, 52);
    });

    test('Compute score - fulfilled - BeloteRebelote - THEM', () {
      coincheRound.dixDeDer = null;
      coincheRound.beloteRebelote = TeamGameEnum.THEM;
      expect(coincheRound.takerScore, 210);
      expect(coincheRound.defenderScore, 72);
    });

    test('Compute score - fulfilled - Dix de Der - US', () {
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = TeamGameEnum.US;
      expect(coincheRound.takerScore, 220);
      expect(coincheRound.defenderScore, 52);
    });

    test('Compute score - fulfilled - Dix de Der - THEM', () {
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = TeamGameEnum.THEM;
      expect(coincheRound.takerScore, 210);
      expect(coincheRound.defenderScore, 62);
    });

    test('Compute score - failed', () {
      coincheRound.taker = TeamGameEnum.THEM;
      coincheRound.defender = TeamGameEnum.US;
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = null;
      expect(coincheRound.takerScore, 0);
      expect(coincheRound.defenderScore, 260);
    });

  });
}
