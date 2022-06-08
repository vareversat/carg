import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/french_belote_round.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BeloteRound', () {
    test('Is contract fulfilled', () {
      final beloteRound = FrenchBeloteRound();
      expect(beloteRound.contractFulfilled, true);
    });

    test('Compute score - fulfilled', () {
      final beloteRound = FrenchBeloteRound();
      beloteRound.taker = BeloteTeamEnum.US;
      beloteRound.defender = BeloteTeamEnum.THEM;
      beloteRound.dixDeDer = BeloteTeamEnum.US;
      beloteRound.beloteRebelote = null;
      beloteRound.usTrickScore = 110;
      beloteRound.themTrickScore = 50;
      expect(beloteRound.contractFulfilled, true);
      expect(beloteRound.takerScore, 120);
      expect(beloteRound.defenderScore, 50);
    });

    test('Compute score - fulfilled - BeloteRebelote - US', () {
      final beloteRound = FrenchBeloteRound();
      beloteRound.taker = BeloteTeamEnum.US;
      beloteRound.defender = BeloteTeamEnum.THEM;
      beloteRound.dixDeDer = BeloteTeamEnum.US;
      beloteRound.beloteRebelote = BeloteTeamEnum.US;
      beloteRound.usTrickScore = 110;
      beloteRound.themTrickScore = 50;
      expect(beloteRound.contractFulfilled, true);
      expect(beloteRound.takerScore, 140);
      expect(beloteRound.defenderScore, 50);
    });

    test('Compute score - not fulfilled - BeloteRebelote - THEM', () {
      final beloteRound = FrenchBeloteRound();
      beloteRound.taker = BeloteTeamEnum.US;
      beloteRound.dixDeDer = BeloteTeamEnum.US;
      beloteRound.defender = BeloteTeamEnum.THEM;
      beloteRound.usTrickScore = 70;
      beloteRound.themTrickScore = 90;
      beloteRound.beloteRebelote = BeloteTeamEnum.US;
      expect(beloteRound.contractFulfilled, true);
      expect(beloteRound.takerScore, 100);
      expect(beloteRound.defenderScore, 90);
    });

    test('Compute score - fulfilled - Dix de Der - US', () {
      final beloteRound = FrenchBeloteRound();
      beloteRound.taker = BeloteTeamEnum.US;
      beloteRound.dixDeDer = BeloteTeamEnum.US;
      beloteRound.defender = BeloteTeamEnum.THEM;
      beloteRound.beloteRebelote = null;
      beloteRound.usTrickScore = 110;
      beloteRound.themTrickScore = 50;
      expect(beloteRound.contractFulfilled, true);
      expect(beloteRound.takerScore, 120);
      expect(beloteRound.defenderScore, 50);
    });

    test('Compute score - fulfilled - Dix de Der - THEM', () {
      final beloteRound = FrenchBeloteRound();
      beloteRound.taker = BeloteTeamEnum.US;
      beloteRound.defender = BeloteTeamEnum.THEM;
      beloteRound.dixDeDer = BeloteTeamEnum.THEM;
      beloteRound.beloteRebelote = null;
      beloteRound.usTrickScore = 110;
      beloteRound.themTrickScore = 50;
      expect(beloteRound.contractFulfilled, true);
      expect(beloteRound.takerScore, 110);
      expect(beloteRound.defenderScore, 60);
    });

    test('Compute score - failed', () {
      final beloteRound = FrenchBeloteRound();
      beloteRound.taker = BeloteTeamEnum.THEM;
      beloteRound.defender = BeloteTeamEnum.US;
      beloteRound.dixDeDer = BeloteTeamEnum.US;
      beloteRound.beloteRebelote = null;
      beloteRound.usTrickScore = 110;
      beloteRound.themTrickScore = 50;
      expect(beloteRound.contractFulfilled, false);
      expect(beloteRound.takerScore, 0);
      expect(beloteRound.defenderScore, 160);
    });
  });
}
