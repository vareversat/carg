import 'package:carg/models/score/misc/team_game_enum.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BeloteRound', () {
    final beloteRound = BeloteRound(
        taker: TeamGameEnum.US,
        defender: TeamGameEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 52);

    test('Is contract fulfilled', () {
      expect(beloteRound.isContractFulfilled(), true);
    });

    test('Compute score - fulfilled', () {
      beloteRound.dixDeDer = null;
      expect(beloteRound.takerScore, 110);
      expect(beloteRound.defenderScore, 52);
    });

    test('Compute score - fulfilled - BeloteRebelote - US', () {
      beloteRound.dixDeDer = null;
      beloteRound.beloteRebelote = TeamGameEnum.US;
      expect(beloteRound.takerScore, 130);
      expect(beloteRound.defenderScore, 52);
    });

    test('Compute score - fulfilled - BeloteRebelote - THEM', () {
      beloteRound.dixDeDer = null;
      beloteRound.beloteRebelote = TeamGameEnum.THEM;
      expect(beloteRound.takerScore, 110);
      expect(beloteRound.defenderScore, 72);
    });

    test('Compute score - fulfilled - Dix de Der - US', () {
      beloteRound.beloteRebelote = null;
      beloteRound.dixDeDer = TeamGameEnum.US;
      expect(beloteRound.takerScore, 120);
      expect(beloteRound.defenderScore, 52);
    });

    test('Compute score - fulfilled - Dix de Der - THEM', () {
      beloteRound.beloteRebelote = null;
      beloteRound.dixDeDer = TeamGameEnum.THEM;
      expect(beloteRound.takerScore, 110);
      expect(beloteRound.defenderScore, 62);
    });

    test('Compute score - failed', () {
      beloteRound.taker = TeamGameEnum.THEM;
      beloteRound.defender = TeamGameEnum.US;
      beloteRound.beloteRebelote = null;
      beloteRound.dixDeDer = null;
      expect(beloteRound.takerScore, 0);
      expect(beloteRound.defenderScore, 160);
    });

  });
}
