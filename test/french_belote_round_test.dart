import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/french_belote_round.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BeloteRound', () {
    final beloteRound = FrenchBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50);

    test('Is contract fulfilled', () {
      expect(beloteRound.isContractFulfilled(), true);
    });

    test('Compute score - fulfilled', () {
      beloteRound.dixDeDer = null;
      expect(beloteRound.takerScore, 110);
      expect(beloteRound.defenderScore, 50);
    });

    test('Compute score - fulfilled - BeloteRebelote - US', () {
      beloteRound.dixDeDer = null;
      beloteRound.beloteRebelote = BeloteTeamEnum.US;
      expect(beloteRound.takerScore, 130);
      expect(beloteRound.defenderScore, 50);
    });

    test('Compute score - fulfilled - BeloteRebelote - THEM', () {
      beloteRound.dixDeDer = null;
      beloteRound.beloteRebelote = BeloteTeamEnum.THEM;
      expect(beloteRound.takerScore, 110);
      expect(beloteRound.defenderScore, 70);
    });

    test('Compute score - fulfilled - Dix de Der - US', () {
      beloteRound.beloteRebelote = null;
      beloteRound.dixDeDer = BeloteTeamEnum.US;
      expect(beloteRound.takerScore, 120);
      expect(beloteRound.defenderScore, 50);
    });

    test('Compute score - fulfilled - Dix de Der - THEM', () {
      beloteRound.beloteRebelote = null;
      beloteRound.dixDeDer = BeloteTeamEnum.THEM;
      expect(beloteRound.takerScore, 110);
      expect(beloteRound.defenderScore, 60);
    });

    test('Compute score - failed', () {
      beloteRound.taker = BeloteTeamEnum.THEM;
      beloteRound.defender = BeloteTeamEnum.US;
      beloteRound.beloteRebelote = null;
      beloteRound.dixDeDer = null;
      expect(beloteRound.takerScore, 0);
      expect(beloteRound.defenderScore, 160);
    });

  });
}
